from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash

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
    
if __name__ == '__main__':
    with app.app_context():
        db.create_all()    

@app.route('/sign', methods=['GET','POST'])
def sign():
    if request.method == 'POST':
        data = request.json  
        print("Received data:", data)

        if not data:
            return jsonify({'message': '입력한 정보 x'}), 400
        
        username = data.get('username')
        password = data.get('password')
        name = data.get('name')
        date = data.get('date')
        gender = data.get('gender')

        if not username or not password:
            return jsonify({'message': '사용자 이름과 비밀번호가 입력 x'}), 400

        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            return jsonify({'message': '중복됨'}), 409

        hashed_password = generate_password_hash(password)

        new_user = User(username=username, password=hashed_password, name=name, date=date, gender=gender)
        try:
            db.session.add(new_user)
            db.session.commit()
            return jsonify({'message': '회원가입 성공!!'}), 201
        except Exception as e:
            db.session.rollback()
            return jsonify({'message': '회원가입 실패 ㅠ.ㅠ'}), 500
    else:
        return jsonify({'message': 'POST 메서드만 허용됩니다.'}), 405


@app.route('/login', methods=['GET','POST'])
def login():
    data = request.json
    print("Received data:", data)
    
    if not data:
        return jsonify({'message': '데이터를 찾을 수 없습니다.'}), 400

    username = data.get('username')
    password = data.get('password')
    
    if not username or not password:
        return jsonify({'message': '사용자 이름과 비밀번호는 필수입니다.'}), 400
    
    user = User.query.filter_by(username=username).first()
    if user and check_password_hash(user.password, password):
        return jsonify({'message': '로그인 성공!!'}), 200
    else:
        return jsonify({'message': '아이디나 비밀번호를 다시 확인 ㅠㅠ'}), 401 

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)
