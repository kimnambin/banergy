from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from random import shuffle #랜덤을 위함
import csv


# Flask 앱 초기화
app = Flask(__name__)
CORS(app)

# SQLite 데이터베이스 설정
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///products.db'
db = SQLAlchemy(app)

# 데이터 모델 정의
class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    barcode = db.Column(db.String(20), nullable=False)
    name = db.Column(db.String(80), nullable=False)
    kategorie = db.Column(db.String(255), nullable=True)
    frontproduct = db.Column(db.String(255), nullable=True)
    backproduct = db.Column(db.String(255), nullable=False)
    allergens = db.Column(db.String(255), nullable=True)

    def __repr__(self):
        return f'<Product {self.name}>'
    

# 데이터베이스 생성 및 CSV 데이터 추가
if __name__ == '__main__':
    with app.app_context():
        db.create_all()

        # CSV 파일에서 데이터를 읽어와 데이터베이스에 추가
        with open('C:/Users/82109/Desktop/src/flutter_banergy/lib/DB/product.csv', 'r', encoding='utf-8') as csvfile:
            csvreader = csv.DictReader(csvfile, fieldnames=['barcode', 'name', 'kategorie', 'frontproduct', 'backproduct', 'allergens'])
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


@app.route('/', methods=['GET'])
def get_products():
    query = request.args.get('query', '')
    
    if query:
        # 검색어가 있는 경우 검색어를 포함하는 제품 정보를 반환합니다.
        if query == '라면':
            products = Product.query.filter(Product.kategorie.like("%라면%")).all()
        elif query == '디저트':
            products = Product.query.filter(Product.kategorie.like("%디저트%")).all()
        elif query == '음료':
            products = Product.query.filter(Product.kategorie.like("%음료%")).all()
        #나중에 여기다 나머지 카테고리들 추가하기 (케이크 , 패스트푸드 , 밀키드 ,샌드위치)    
        else:
            # 다른 검색어의 경우 제품명에 검색어를 포함하는 제품 정보를 반환합니다.
            products = Product.query.filter(Product.name.like(f"%{query}%")).all()
    else:
        # 바코드와 검색어가 모두 없는 경우 모든 제품 정보를 반환합니다.
        products = Product.query.all()

    shuffle(products) #랜덤으로 보여줌

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

if __name__ == '__main__':

    app.run(host='0.0.0.0', port=8000, debug=True)

