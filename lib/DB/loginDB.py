from sqlalchemy import JSON
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from paddleocr import PaddleOCR
import os
from flask_jwt_extended import (
    JWTManager, create_access_token, jwt_required, get_jwt_identity
)
from datetime import timedelta
from banergy_data import Product







app = Flask(__name__)
CORS(app)
app.config['JWT_SECRET_KEY'] = 'banergy'  # 보안을 위한 임의의 시크릿 키
jwt = JWTManager(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)
    name = db.Column(db.String(20), nullable=True)
    date = db.Column(db.String(80), nullable=True)
    gender = db.Column(db.String(20), nullable=False)
    allergies = db.Column(db.String(128), nullable=True)



    def __repr__(self):
        return f'<User {self.username}>'
    

#탈퇴 이유 모델
class Reason(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    reason = db.Column(db.String(255), nullable=False)

    def __repr__(self):
        return f'<Reason(user_id={self.user_id}, reason={self.reason})>'

                
if __name__ == '__main__':
    with app.app_context():
        db.create_all()    


#회원가입 부분
@app.route('/sign', methods=['GET','POST'])
def sign():
    if request.method == 'POST':
        data = request.json  
        print("Received data:", data)
        
        username = data.get('username')
        password = data.get('password')
        name = data.get('name')
        date = data.get('date')
        gender = data.get('gender')

        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            return jsonify({'message': '중복됨'}), 409


        new_user = User(username=username, password=password, name=name, date=date, gender=gender)
        try:
            db.session.add(new_user)
            db.session.commit()
            return jsonify({'message': '회원가입 성공!!'}), 201
        except Exception as e:
            db.session.rollback()
            return jsonify({'message': '회원가입 실패 ㅠ.ㅠ'}), 500


#로그인 부분
@app.route('/login', methods=['GET','POST'])
def login():
    data = request.json
    print("Received data:", data)
    
    username = data.get('username')
    password = data.get('password')
    
    user = User.query.filter_by(username=username , password = password).first()
    if user:
            expires = timedelta(days=3)
            access_token = create_access_token(identity=user.username, expires_delta=expires)
            #print("토큰 값:", access_token)
            allergies = user.allergies if user.allergies else "알레르기 정보X"
            print("알레르기 정보:", allergies)
            return jsonify({'message': '로그인 성공!!' , 'access_token': access_token}), 200
    else:
            return jsonify({'message': '로그인 실패 ㅠㅠ'}), 404
    

# 로그인한 사용자 정보
@app.route('/loginuser', methods=['GET'])
@jwt_required()  
def protectloginusered():
    current_username = get_jwt_identity()
    print("로그인한 정보:", current_username)
    user = User.query.filter_by(username=current_username).first()  # username 기준으로 사용자 조회
    if user:
        allergies_with_quotes = user.allergies.split(",") if user.allergies else []
        allergies = [allergy.strip('"') for allergy in allergies_with_quotes]  
        return jsonify({
            'username': user.username,
            'allergies': allergies,
            'name' : user.name 
        }), 200
    else:
        return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404


# 필터링 적용부분
@app.route('/allergies', methods=['GET','POST'])
@jwt_required()  
def allergies():
    current_username = get_jwt_identity()  # 현재 로그인한 사용자의 username 가져오기
    print("현재 로그인한 사용자:", current_username) 
    if request.method == 'POST':
        data = request.json
        allergies = data.get('allergies')
        print("받은 알레르기 정보:", allergies)  

        # 사용자를 찾아서 알레르기 정보 업데이트
        user = User.query.filter_by(username=current_username).first()  # username 기준으로 사용자 조회
        if user:
            user.allergies = allergies
            try:
                db.session.commit()
                return jsonify({'message': '알레르기 정보가 업데이트되었습니다.'}), 200
            except Exception as e:
                db.session.rollback()
                print("알레르기 정보 업데이트 실패:", str(e))  
                return jsonify({'message': '알레르기 정보 업데이트 실패 ㅠ.ㅠ'}), 500
        else:
            print("사용자를 찾을 수 없음")  
            return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404




# 아이디 찾기 
@app.route('/findid', methods=['GET','POST'])
def find_username():
    if request.method == 'POST':
        data = request.json
        name = data.get('name')  
        password = data.get('password')
        #date = data.get('date')
        
        user = User.query.filter_by(name=name , password=password).first()  
   
        if user:
            return jsonify({'username': user.username}), 200  
        else:
            return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404
    
# 비밀번호 찾기
@app.route('/findpw', methods=['GET','POST'])
def find_password():
    data = request.json
    name = data.get('name')
    username = data.get('username') 
    #date = data.get('date')
    user = User.query.filter_by(username=username, name=name ).first()  
    if user:
        return jsonify({'password':user.password }), 200
    else:
        return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404
    

# 비밀번호 변경하기
@app.route('/changepw', methods=['GET','POST'])
def change_password():
    if request.method == 'POST':
        data = request.json
        
        password = data.get('password')
        new_password = data.get('new_password')

        user = User.query.filter_by(password=password).first()

        if user:
            user.password = new_password
            try:
                db.session.commit()
                return jsonify({'message': '비밀번호 변경 성공!!'}), 200
            except Exception as e:
                db.session.rollback()
                return jsonify({'message': '비밀번호 변경 실패 ㅠ.ㅠ'}), 500
        else:
            return jsonify({'message': '사용자를 찾을 수 없거나 현재 비밀번호가 올바르지 않습니다.'}), 404

# 회원탈퇴하기
@app.route("/delete", methods=["POST", "DELETE"])
def delete_user():
    if request.method == 'POST' or request.method == 'DELETE':
        data = request.json
        password = data.get('password')
        reason_text = data.get('reason')  # 탈퇴 이유

        # 사용자 인증
        user = User.query.filter_by(password=password).first()

        if user:
            try:
                # 회원 삭제
                db.session.delete(user)
                db.session.commit()

                # 탈퇴 이유 추가
                new_reason = Reason(user_id=user.id, reason=reason_text)
                db.session.add(new_reason)
                db.session.commit()

                return jsonify({'message': '회원 탈퇴 성공'}), 200
            except Exception as e:
                db.session.rollback()
                return jsonify({'message': '회원 탈퇴 실패 ㅠ.ㅠ'}), 500
        else:
            return jsonify({'message': '사용자 인증 실패'}), 401





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



# 이미지를 받아서 OCR을 수행하는 엔드포인트
@app.route('/ocr', methods=['POST'])
@jwt_required()
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
    # 로그인한 사용자의 정보 가져오기
    current_username = get_jwt_identity()
    user = User.query.filter_by(username=current_username).first()

    if user:
        allergies = user.allergies.replace('"', '').split(", ") if user.allergies else []

        print("사용자의 알레르기 정보:", allergies)  # 사용자의 알레르기 정보 출력

        highlighted_texts = []
        for text in ocr_texts:
            highlighted_text = []
            for word in text.split():
                if word in allergies:
                    highlighted_text.append('<' + word + '>')
                else:
                    highlighted_text.append(word)
            highlighted_texts.append(highlighted_text)

        
        return jsonify({'text': [' '.join(text) for text in highlighted_texts]}), 200

    else:
        return jsonify({'message': '사용자 정보를 찾을 수 없습니다.'}), 404

# OCR 결과 부분
@app.route('/result', methods=['GET'])
@jwt_required()
def get_ocr_result():
    # 최근에 업로드된 이미지 파일 경로 가져오기
    file_times = [(file, os.path.getmtime(os.path.join(img_dir, file))) for file in os.listdir(img_dir)]
    file_times.sort(key=lambda x: x[1], reverse=True)
    recent_file = file_times[0][0]
    recent_file_path = os.path.join(img_dir, recent_file)
    
    # OCR 수행
    ocr_texts = perform_ocr(recent_file_path)

    # 로그인한 사용자의 정보 가져오기
    current_username = get_jwt_identity()
    user = User.query.filter_by(username=current_username).first()

    if user:
        # 사용자의 알레르기 정보에서 따옴표와 대괄호 제거
        allergies = [allergy.strip('[]"') for allergy in user.allergies.split(',')] if user.allergies else []

        print("사용자의 알레르기 정보:", allergies)  # 사용자의 알레르기 정보 출력

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
    app.run(host='0.0.0.0', port=3000, debug=True)
