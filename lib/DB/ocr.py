import datetime
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from paddleocr import PaddleOCR
import os

app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///NoUserOCR.db'
db = SQLAlchemy(app)

class NoUserOCR(db.Model):
    num = db.Column(db.Integer, primary_key=True)
    allergies = db.Column(db.String(128), nullable=True)
    timestamp = db.Column(db.DateTime, default=datetime.datetime.now, nullable=False)
    
if __name__ == '__main__':
    with app.app_context():
        db.create_all() 

# 필터링 적용부분
@app.route('/ftr', methods=['GET', 'POST']) 
def allergies():
    if request.method == 'GET':
        try:
            # 최근에 저장된 알레르기 정보 가져오기
            recently = NoUserOCR.query.order_by(NoUserOCR.timestamp.desc()).first()
            if recently:
                allergies = recently.allergies.replace('"', '').split(", ") if recently.allergies else []
                return jsonify({'allergies': allergies}), 200
            else:
                return jsonify({'message': '사용자 정보를 찾을 수 없습니다.'}), 404
        except Exception as e:
            return jsonify({'message': f'에러 발생: {e}'}), 500
    elif request.method == 'POST':
        data = request.json
        print("선택한 알레르기:", data)
        
        allergies = data.get('allergies')
        timestamp = data.get('timestamp')

        existing_allergies = NoUserOCR.query.filter_by(allergies=allergies).first()
        if existing_allergies:
            return jsonify({'message': '중복됨'}), 409

        new_db = NoUserOCR(allergies=allergies, timestamp=timestamp)
        try:
            db.session.add(new_db)
            db.session.commit()
            return jsonify({'message': '필터링 성공!!'}), 201
        except Exception as e:
            db.session.rollback()
            return jsonify({'message': '필터링 실패 ㅠ.ㅠ'}), 500
    else:
        return jsonify({'message': '지원하지 않는 메서드입니다.'}), 405


ocr = PaddleOCR(lang="korean")


# 이미지가 있는 경로
img_dir = "assets/ocrimg/"

# OCR 수행 함수
def perform_ocr(image_path):
    result = ocr.ocr(image_path, cls=False)
    ocr_texts = []
    for line in result[0]:
        ocr_texts.append(line[1][0]) 
    return ocr_texts



    
@app.route('/result', methods=['GET'])
def get_ocr_result():
    # 최근에 업로드된 이미지 파일 경로 가져오기
    file_times = [(file, os.path.getmtime(os.path.join(img_dir, file))) for file in os.listdir(img_dir)]
    file_times.sort(key=lambda x: x[1], reverse=True)
    recent_file = file_times[0][0]
    recent_file_path = os.path.join(img_dir, recent_file)
    
    # OCR 수행
    ocr_texts = perform_ocr(recent_file_path)

    # 최근에 저장된 정보 가져오기
    recently = NoUserOCR.query.order_by(NoUserOCR.timestamp.desc()).first()
        
    if recently:
        allergies_str = recently.allergies.strip('[]')
        allergies_list = allergies_str.replace('"', '').split(',')
        
        

    # OCR 텍스트에서 하이라이팅 단어 찾기 
        for text in ocr_texts:
            highlighted_text = [] #이게 하이라이팅 단어
            displayed_allergies = set() #  # 하이라이팅 단어 중복 방지
            for word in text.split():  # 단어 단위로 분리해서 반복
                original_word = word  
        for allergy in allergies_list:  # 이게 사용자의 알레르기 부분

            #사용자 알레르기와 일치하는 단어가 있는 경우
            if allergy in word and allergy not in displayed_allergies:  
                        word = word.replace(allergy, '『' + allergy + '』') 
                        print("알레르기 단어 발견:", allergy)  
                        
                        #ocr 텍스트들을 highlighted_text 여기에 추가
                        highlighted_text.append(word if word != original_word else original_word)
                        highlighted_texts.append(' '.join(highlighted_text))


            else: #하이라이팅이 없는 경우
                highlighted_texts = ocr_texts

    print('일반:', ocr_texts)
    print('하이라이팅:', highlighted_texts)
    
    return jsonify({'text': [' '.join(text) for text in highlighted_texts]}), 200

            
       





# 이미지를 받아서 OCR을 수행하는 엔드포인트
@app.route('/ocr', methods=['POST'])
def ocr_image():
    if 'image' not in request.files:
        return jsonify({'message': '이미지가 없습니다.'}), 400
    
    image = request.files['image']

    if image.filename == '':
        return jsonify({'message': '이미지가 선택되지 않았습니다.'}), 400

    # 이미지를 저장할 경로
    filepath = os.path.join(img_dir, image.filename)
    image.save(filepath)

    # OCR 수행
    ocr_texts = perform_ocr(filepath)
    # 최근에 저장된 정보 가져오기
    recently = NoUserOCR.query.order_by(NoUserOCR.timestamp.desc()).first()
    
    if recently:
        allergies = recently.allergies.replace('"', '').split(", ") if recently.allergies else []
        print('가져온 사용자 알레르기 정보:', allergies)
     # OCR 텍스트에서 하이라이팅 단어 찾기 
        for text in ocr_texts:
            highlighted_text = [] #이게 하이라이팅 단어
            displayed_allergies = set() #하이라이팅 단어 중복 방지
            for word in text.split():  # 단어 단위로 분리
                original_word = word  
        for allergy in allergies:  # 이게 사용자의 알레르기 부분

            #사용자 알레르기와 일치하는 단어가 있는 경우
            if allergy in word and allergy not in displayed_allergies:  
                        word = word.replace(allergy, '『' + allergy + '』') 
                        print("알레르기 단어 발견:", allergy)  
                        
                        #ocr 텍스트들을 highlighted_text 여기에 추가
                        highlighted_text.append(word if word != original_word else original_word)
                        highlighted_texts.append(' '.join(highlighted_text))


            else: #하이라이팅이 없는 경우
                highlighted_texts = ocr_texts

    print('일반:', ocr_texts)
    print('하이라이팅:', highlighted_texts)
    
    return jsonify({'text': [' '.join(text) for text in highlighted_texts]}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7000, debug=True)