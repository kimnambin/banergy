from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///mypage.db'
db = SQLAlchemy(app)

class Mypage(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    #문의하기
    inquirytitle = db.Column(db.String(20), nullable=True)
    inquirycontent = db.Column(db.String(255), nullable=True)

    #상품추가
    addtitle = db.Column(db.String(20), nullable=True)
    addcontent = db.Column(db.String(255), nullable=True)
    addpath = db.Column(db.String(255), nullable=True)

    #자유게시판
    freetitle = db.Column(db.String(40), nullable=True)
    freecontent = db.Column(db.String(255), nullable=True)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()     

# 상품추가
@app.route('/add', methods=['POST'])
def add_image():
    if 'image' not in request.files:
        return jsonify({'message': '올바른 파일이 아님'}), 400
    
    addpath = request.files['image']
    addtitle = request.form['addtitle']
    addcontent = request.form['addcontent']

    if addpath.filename == '':
        return jsonify({'message': '이미지가 선택되지 않았음'}), 400

    if addpath:
        # 이미지를 저장할 경로
        filepath = 'static/' + addpath.filename
        addpath.save(filepath)

        # 이미지 정보와 제목, 내용을 데이터베이스에 저장
        new_image = Mypage(addtitle=addtitle, addcontent=addcontent, addpath=filepath)
        db.session.add(new_image)
        db.session.commit()

        return jsonify({'message': '상품정보추가완료!!'}), 200

# 이미지를 받아오기 위함
@app.route('/images/<int:image_id>', methods=['GET'])
def get_image(image_id):
    image = Mypage.query.get(image_id)
    if image:
        return jsonify({'title': image.addtitle, 'content': image.addcontent, 'path': image.addpath}), 200
    else:
        return jsonify({'message': '이미지를 찾을 수 없다 ㅠㅠ'}), 404

# 문의하기
@app.route('/inquiry', methods=['POST'])
def inquiry():
    if request.method == 'POST':
        data = request.json  
        print("Received data:", data)
        
        inquirytitle = data.get('inquirytitle')
        inquirycontent = data.get('inquirycontent')
        
        if inquirytitle is None or inquirycontent is None:
            return jsonify({'message': '문의 제목 또는 내용이 누락되었습니다.'}), 400
        
        new_mypage = Mypage(inquirytitle=inquirytitle, inquirycontent=inquirycontent)
        try:
            db.session.add(new_mypage)
            db.session.commit()
            return jsonify({'message': '문의하기 성공!!'}), 201
        except Exception as e:
            db.session.rollback()
            return jsonify({'message': '문의하기 실패: {}'.format(str(e))}), 500


#자유게시판 
@app.route('/free', methods=['POST','GET'])
def free():
    if request.method == 'POST':
        data = request.json  
        print("Received data:", data)
        
        freetitle = data.get('freetitle')
        freecontent = data.get('freecontent')
        
        if freetitle is None or freecontent is None:
            return jsonify({'message': '제목 또는 내용이 누락되었습니다.'}), 400
        
        new_mypage = Mypage(freetitle=freetitle, freecontent=freecontent)
        try:
            db.session.add(new_mypage)
            db.session.commit()
            return jsonify({'message': '자유게시판 성공!!'}), 201
        except Exception as e:
            db.session.rollback()
            return jsonify({'message': '자유게시판 실패: {}'.format(str(e))}), 500
        
    #여기가 화면에 보여줄 부분    
    elif request.method == 'GET': 
        mypages = Mypage.query.all()  
        Mypage_list = []  
        
        
        for mypage in mypages:
            mypage_data = {
                'id': mypage.id,
                'freetitle': mypage.freetitle,
                'freecontent': mypage.freecontent
            }
            Mypage_list.append(mypage_data)
        
        return jsonify(Mypage_list)  # JSON 형식

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6000, debug=True)