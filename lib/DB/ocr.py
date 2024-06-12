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
    
   #최근에 저장된 정보 가져오기
    recently = NoUserOCR.query.order_by(NoUserOCR.timestamp.desc()).first()

    if recently:
        # allergies = recently.allergies.replace('"', '').split(", ") if recently.allergies else []
        allergies_str = recently.allergies.strip('[]')  
        allergies_list = allergies_str.replace('"', '').split(',')

        allergies_list = [allergy.strip() for allergy in allergies_list]
        print('가져온 사용자 알레르기 정보:', allergies_list)

        highlighted_texts = []
        for text in ocr_texts:
            highlighted_text = []
            for word in text.split():
                if any(allergies_str in word for allergies_str in allergies_list):
                    highlighted_text.append('『' + word + '』')
                else:
                    highlighted_text.append(word)
            highlighted_texts.append(highlighted_text)


        print('일반:', ocr_texts) 
        print('하이라이팅:', highlighted_texts)
        return jsonify({'text': [' '.join(text) for text in highlighted_texts]}), 200

    else:
        return jsonify({'message': '사용자 정보를 찾을 수 없습니다.'}), 404



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
    #최근에 저장된 정보 가져오기
    recently = NoUserOCR.query.order_by(NoUserOCR.timestamp.desc()).first()
        
    if recently:
            allergies = recently.allergies.replace('"', '').split(", ") if recently.allergies else []
            print('가져온 사용자 알레르기 정보:', allergies)


    # 텍스트에서 특정 단어를 찾아 하이라이팅 적용
    highlighted_texts = []
    for text in ocr_texts:
            highlighted_text = []
            for word in text.split():
                if any(allergy in word for allergy in allergies):
                    highlighted_text.append('『' + word + '』')
                else:
                    highlighted_text.append(word)
            highlighted_texts.append(highlighted_text)


            print('일반:', ocr_texts) 
            print('하이라이팅:', highlighted_texts)
            return jsonify({'text': [' '.join(text) for text in highlighted_texts]}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7000, debug=True)