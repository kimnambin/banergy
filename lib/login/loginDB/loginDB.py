from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS


app = Flask(__name__)
CORS(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)
    name = db.Column(db.String(20), nullable=True)
    date = db.Column(db.String(80), nullable=True)
    gender = db.Column(db.String(20), nullable=False)


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
            return jsonify({'message': '로그인 성공!!'}), 200  
    else:
            return jsonify({'message': '로그인 실패 ㅠㅠ'}), 404

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


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)
