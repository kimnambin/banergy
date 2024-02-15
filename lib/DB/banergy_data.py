from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
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
    kategorie = db.Column(db.String(255), nullable=True)
    name = db.Column(db.String(80), nullable=False)
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

            csvreader = csv.DictReader(csvfile, fieldnames=['barcode', 'kategorie', 'name', 'frontproduct', 'backproduct', 'allergens'])
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
                    kategorie=row['kategorie'],
                    name=row['name'],
                    frontproduct=row['frontproduct'],
                    backproduct=row['backproduct'],
                    allergens=row['allergens']
                )
                db.session.add(new_product)

        db.session.commit()

# 라우팅: 제품 목록 조회
@app.route('/', methods=['GET'])
def get_products():
    products = Product.query.all()
    product_list = []
    for product in products:
        product_data = {
            'id': product.id,
            'barcode': product.barcode,
            'kategorie': product.kategorie,
            'name': product.name,
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
            kategorie=data['kategorie'],
            name=data['name'],
            frontproduct=data['frontproduct'],
            backproduct=data['backproduct'],
            allergens=data['allergens']
        )
        db.session.add(new_product)
        db.session.commit()
        return jsonify({'message': '제품이 성공적으로 추가되었습니다.'}), 201

if __name__ == '__main__':
    app.run(debug=True)