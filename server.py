from flask import Flask, json, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
# from random import shuffle  # 랜덤을 위함
from random import sample, shuffle
import csv
import datetime
from datetime import timedelta
from paddleocr import PaddleOCR
from dateutil.parser import parse
import os
import random

from flask_jwt_extended import (
    JWTManager, create_access_token, jwt_required, get_jwt_identity
)

# Flask 앱 초기화
app = Flask(__name__)
CORS(app)
app.config['JWT_SECRET_KEY'] = 'banergy'  # 보안을 위한 임의의 시크릿 키
jwt = JWTManager(app)

# SQLite 데이터베이스 설정
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///banergy.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)


# Product 테이블 정의
class Product(db.Model):
    __tablename__ = 'products'
    id = db.Column(db.Integer, primary_key=True)
    barcode = db.Column(db.String(20), nullable=False)
    name = db.Column(db.String(80), nullable=False)
    kategorie = db.Column(db.String(255), nullable=True)
    frontproduct = db.Column(db.String(255), nullable=True)
    backproduct = db.Column(db.String(255), nullable=False)
    allergens = db.Column(db.String(255), nullable=True)

    def __repr__(self):
        return f'<Product {self.name}>'

# NoUserOCR 테이블 정의
class NoUserOCR(db.Model):
    __tablename__ = 'nouserocr'
    num = db.Column(db.Integer, primary_key=True)
    allergies = db.Column(db.String(128), nullable=True)
    timestamp = db.Column(db.DateTime, default=datetime.datetime.now, nullable=False)

# Mypage 테이블 정의
class Mypage(db.Model):
    __tablename__ = 'mypage'
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
    timestamp = db.Column(db.DateTime, default=datetime.datetime.now, nullable=False)

# user 테이블 정의
class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)
    name = db.Column(db.String(20), nullable=True)
    date = db.Column(db.String(80), nullable=True)
    gender = db.Column(db.String(20), nullable=False)
    allergies = db.Column(db.String(128), nullable=True)
    liked_products = db.Column(db.String(5012), nullable=True)

    def __repr__(self):
        return f'<User {self.username}>'


# user_reason 테이블 정의
class Reason(db.Model):
    __tablename__ = 'user_reason'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    reason = db.Column(db.String(255), nullable=False)

    def __repr__(self):
        return f'<Reason(user_id={self.user_id}, reason={self.reason})>'


# 데이터베이스 생성 및 CSV 데이터 추가
def init(csv_file_path):
    with app.app_context():
        db.create_all()

        # CSV 파일에서 데이터를 읽어와 데이터베이스에 추가
        with open(csv_file_path, 'r', encoding='utf-8') as csvfile:
            csvreader = csv.DictReader(csvfile,
                                       fieldnames=['barcode', 'name', 'kategorie', 'frontproduct', 'backproduct',
                                                   'allergens'])
            for idx, row in enumerate(csvreader):
                if idx == 0:  # 첫 번째 행은 헤더이므로 건너뜁니다.
                    continue

                # 중복 체크
                existing_product = Product.query.filter_by(barcode=row['barcode']).first()
                if existing_product:
                    print(f"제품 '{row['name']}'(바코드: {row['barcode']})은 이미 데이터베이스에 존재합니다.")
                    continue

                new_product = Product(
                    barcode=row['barcode'],
                    name=row['name'],
                    kategorie=row['kategorie'],
                    frontproduct=row['frontproduct'],
                    backproduct=row['backproduct'],
                    allergens=row['allergens']
                )
                db.session.add(new_product)

        db.session.commit()


# ========================== banergy_data =========================== #
@app.route('/', methods=['GET'])
def get_products():
    query = request.args.get('query', '')

    if query:
        # 검색어가 있는 경우 검색어를 포함하는 제품 정보를 반환합니다.
        if query == '라면':
            products = Product.query.filter(Product.kategorie.like("%라면%")).all()
        elif query == '간식':
            products = Product.query.filter(Product.kategorie.like("%간식%")).all()
        elif query == '음료':
            products = Product.query.filter(Product.kategorie.like("%음료%")).all()
        elif query == '과자':
            products = Product.query.filter(Product.kategorie.like("%과자%")).all()
        elif query == '가공식품':
            products = Product.query.filter(Product.kategorie.like("%가공식품%")).all()
        else:
            # 다른 검색어의 경우 제품명에 검색어를 포함하는 제품 정보를 반환합니다.
            products = Product.query.filter(Product.name.like(f"%{query}%")).all()
    else:
        # 바코드와 검색어가 모두 없는 경우 모든 제품 정보를 반환합니다.
        products = Product.query.all()

    shuffle(products)  # 랜덤으로 보여줌

    product_list = []
    for product in products:
        product_data = {
            'id': product.id,
            'barcode': product.barcode,
            'name': product.name,
            'kategorie': product.kategorie,
            'frontproduct': product.frontproduct,
            'backproduct': product.backproduct,
            'allergens': product.allergens
        }
        product_list.append(product_data)
    return jsonify(product_list)

    

@app.route('/scan', methods=['GET'])
def scan_products():
    query = request.args.get('query', '')
    barcode = request.args.get('barcode', '')

    if barcode:
        # 바코드가 있는 경우 바코드에 해당하는 제품 정보를 반환합니다.
        products = Product.query.filter_by(barcode=barcode).all()
    elif query:
        # 검색어가 있는 경우 검색어를 포함하는 제품 정보를 반환합니다.
        products = Product.query.filter(Product.name.like(f"%{query}%")).all()

    else:
        # 바코드와 검색어가 모두 없는 경우 모든 제품 정보를 반환합니다.
        products = Product.query.all()

    product_list = []
    for product in products:
        product_data = {
            'id': product.id,
            'barcode': product.barcode,
            'name': product.name,
            'kategorie': product.kategorie,
            'frontproduct': product.frontproduct,
            'backproduct': product.backproduct,
            'allergens': product.allergens
        }
        product_list.append(product_data)
    return jsonify(product_list)


# 라우팅: 제품 추가
@app.route('/add', methods=['POST'])
def add_product():
    if request.method == 'POST':
        data = request.get_json()

        # 중복 체크
        existing_product = Product.query.filter_by(barcode=data['barcode']).first()
        if existing_product:
            return jsonify({'message': '이미 존재하는 제품입니다.'}), 400

        new_product = Product(
            barcode=data['barcode'],
            name=data['name'],
            kategorie=data['kategorie'],
            frontproduct=data['frontproduct'],
            backproduct=data['backproduct'],
            allergens=data['allergens']
        )
        db.session.add(new_product)
        db.session.commit()
        return jsonify({'message': '제품이 성공적으로 추가되었습니다.'}), 201

# ========================== banergy_data =========================== #

# ========================== nouser =========================== #
# 필터링 적용부분
@app.route('/nouser/ftr', methods=['GET', 'POST'])
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


@app.route('/nouser/result', methods=['GET'])
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

@app.route('/nouser/ocr', methods=['POST'])
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

# ========================== nouser =========================== #

# ========================== mypage =========================== #
# 상품추가
@app.route('/mypage/add', methods=['POST'])
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
@app.route('/mypage/images/<int:image_id>', methods=['GET'])
def get_image(image_id):
    image = Mypage.query.get(image_id)
    if image:
        return jsonify({'title': image.addtitle, 'content': image.addcontent, 'path': image.addpath}), 200
    else:
        return jsonify({'message': '이미지를 찾을 수 없다 ㅠㅠ'}), 404


# 문의하기
@app.route('/mypage/inquiry', methods=['POST'])
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


# 자유게시판
@app.route('/mypage/free', methods=['POST', 'GET'])
def free():
    if request.method == 'POST':
        data = request.json
        print("Received data:", data)

        freetitle = data.get('freetitle')
        freecontent = data.get('freecontent')
        timestamp = data.get('timestamp')
        print('현재시간:', timestamp)

        if freetitle is None or freecontent is None:
            return jsonify({'message': '제목 또는 내용이 누락되었습니다.'}), 400

        # timestamp가 없을 경우 현재 시간으로 설정
        if timestamp is None:
            timestamp = datetime.datetime.now()
        else:
            timestamp = parse(str(timestamp))

        new_mypage = Mypage(freetitle=freetitle, freecontent=freecontent, timestamp=timestamp)
        try:
            db.session.add(new_mypage)
            db.session.commit()
            return jsonify({'message': '자유게시판 성공!!'}), 201
        except Exception as e:
            db.session.rollback()
            return jsonify({'message': '자유게시판 실패: {}'.format(str(e))}), 500

    # 여기가 화면에 보여줄 부분
    elif request.method == 'GET':
        mypages = Mypage.query.all()
        Mypage_list = []

        for mypage in mypages:
            mypage_data = {
                'id': mypage.id,
                'freetitle': mypage.freetitle,
                'freecontent': mypage.freecontent,
                'timestamp': mypage.timestamp.isoformat()
            }
            Mypage_list.append(mypage_data)
            print('현재시간:', mypage.timestamp)
        return jsonify(Mypage_list)

# ========================== mypage =========================== #

# ========================== loginDB =========================== #
# 회원가입 부분
@app.route('/logindb/sign', methods=['GET', 'POST'])
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


# 로그인 부분
@app.route('/logindb/login', methods=['GET', 'POST'])
def login():
    data = request.json
    print("Received data:", data)

    username = data.get('username')
    password = data.get('password')

    user = User.query.filter_by(username=username, password=password).first()
    if user:
        expires = timedelta(days=3)
        access_token = create_access_token(identity=user.username, expires_delta=expires)
        # print("토큰 값:", access_token)
        allergies = user.allergies if user.allergies else "알레르기 정보X"
        print("알레르기 정보:", allergies)
        return jsonify({'message': '로그인 성공!!', 'access_token': access_token}), 200
    else:
        return jsonify({'message': '로그인 실패 ㅠㅠ'}), 404


# 로그인한 사용자 정보
@app.route('/logindb/loginuser', methods=['GET'])
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
            'name': user.name
        }), 200
    else:
        return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404


# 찜 추가하기
@app.route('/logindb/like', methods=['POST'])
@jwt_required()
def like():
    current_username = get_jwt_identity()  # 현재 로그인한 사용자의 username 가져오기
    data = request.json
    product_id = data.get('product_id')

    if not product_id:
        return jsonify({'message': '상품 ID가 필요합니다.'}), 400

    user = User.query.filter_by(username=current_username).first()
    if not user:
        return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404

    # 사용자의 좋아요 목록 가져오기 (JSON 형태의 문자열로 저장된 필드)
    liked_products = set(json.loads(user.liked_products or '[]'))

    try:
        if product_id in liked_products:
            liked_products.remove(product_id)
        else:
            liked_products.add(product_id)

        # 좋아요 목록을 다시 JSON 형태의 문자열로 저장하여 업데이트
        user.liked_products = json.dumps(list(liked_products))
        db.session.commit()

        return jsonify({'message': '좋아요 상태가 업데이트되었습니다.'}), 200

    except Exception as e:
        db.session.rollback()
        print("좋아요 상태 업데이트 실패:", str(e))
        return jsonify({'message': '좋아요 상태 업데이트 실패 ㅠ.ㅠ'}), 500

#좋아요 누른 상품들 제외하고 보여주기!!
@app.route('/logindb/show_product', methods=['GET'])
@jwt_required()
def get_product():
    current_username = get_jwt_identity()  # 현재 로그인한 사용자의 username 가져오기
    user = User.query.filter_by(username=current_username).first()  # 로그인한 사용자에서 찜한 상품들 가져오기
    
    if not user:
        return jsonify({'message': 'User not found'}), 404

   # 사용자가 좋아요한 상품 ID 리스트
    liked_product_ids = json.loads(user.liked_products or '[]')
    
    # 모든 상품 목록 가져오기
    all_products = Product.query.all()
    
    # 랜덤으로 30개 상품 선택
    random_products = sample(all_products, 30)
    
    # 좋아요하지 않은 상품 정보만 필터링하여 반환
    filtered_products = []
    for product in random_products:
        if product.id not in liked_product_ids:
            product_data = {
                'id': product.id,
                'barcode': product.barcode,
                'name': product.name,
                'kategorie': product.kategorie,
                'frontproduct': product.frontproduct,
                'backproduct': product.backproduct,
                'allergens': product.allergens
            }
            filtered_products.append(product_data)

    
    shuffle(filtered_products)  # 랜덤으로 보여줌
    return jsonify(filtered_products), 200



 # 찜 삭제하기
@app.route('/logindb/deletelike', methods=['POST'])
@jwt_required()
def deletelike():
    current_username = get_jwt_identity()  # 현재 로그인한 사용자의 username 가져오기
    data = request.json
    product_id = data.get('product_id')

    if not product_id:
        return jsonify({'message': '상품 ID가 필요합니다.'}), 400

    user = User.query.filter_by(username=current_username).first()
    if not user:
        return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404

    # 사용자의 좋아요 목록 가져오기 (JSON 형태의 문자열로 저장된 필드)
    liked_products = set(json.loads(user.liked_products or '[]'))

    if product_id in liked_products:
        liked_products.remove(product_id)
    else:
        return jsonify({'message': '해당 상품은 찜 x.'}), 400

    # 좋아요 목록을 다시 JSON 형태의 문자열로 저장하여 업데이트
    user.liked_products = json.dumps(list(liked_products))

    try:
        db.session.commit()
        return jsonify({'message': '찜이 취소되었습니다.'}), 200
    except Exception as e:
        db.session.rollback()
        print("찜 취소 실패:", str(e))
        return jsonify({'message': '찜 취소 실패'}), 500  


#찜 누른 상품들 
@app.route('/logindb/getlike', methods=['GET'])
@jwt_required()
def get_liked_products():
    current_username = get_jwt_identity()
    user = User.query.filter_by(username=current_username).first()
    if not user:
        return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404

    liked_product_ids = json.loads(user.liked_products or '[]')

    liked_products = Product.query.filter(Product.id.in_(liked_product_ids)).all()

    liked_products_list = [
        {
            'id': product.id,
            'barcode': product.barcode,
            'name': product.name,
            'kategorie': product.kategorie,
            'frontproduct': product.frontproduct,
            'backproduct': product.backproduct,
            'allergens': product.allergens
        } for product in liked_products
    ]

    return jsonify({'liked_products': liked_products_list}), 200




# 필터링 적용부분
@app.route('/logindb/allergies', methods=['GET', 'POST'])
@jwt_required()
def logindb_allergies():
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
@app.route('/logindb/findid', methods=['GET', 'POST'])
def find_username():
    if request.method == 'POST':
        data = request.json
        name = data.get('name')
        # password = data.get('password')
        # date = data.get('date')

        user = User.query.filter_by(name=name).first()

        if user:
            return jsonify({'username': user.username}), 200
        else:
            return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404


# 비밀번호 찾기
@app.route('/logindb/findpw', methods=['GET', 'POST'])
def find_password():
    data = request.json
    name = data.get('name')
    username = data.get('username')
    # date = data.get('date')
    user = User.query.filter_by(username=username, name=name).first()
    if user:
        return jsonify({'password': user.password}), 200
    else:
        return jsonify({'message': '사용자를 찾을 수 없습니다.'}), 404


# 비밀번호 변경하기
@app.route('/logindb/changepw', methods=['GET', 'POST'])
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
@app.route("/logindb/delete", methods=["POST", "DELETE"])
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


# 이미지를 받아서 OCR을 수행하는 엔드포인트
@app.route('/logindb/ocr', methods=['POST'])
@jwt_required()
def logindb_ocr_image():
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
@app.route('/logindb/result', methods=['GET'])
@jwt_required()
def logindb_get_ocr_result():
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

# ========================== loginDB =========================== #

if __name__ == '__main__':
    csv_file_path = './product.csv'
    init(csv_file_path)
    app.run(host='0.0.0.0', port=8000, debug=True)