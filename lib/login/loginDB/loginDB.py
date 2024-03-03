from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import csv

app = Flask(__name__)
CORS(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), nullable=False)
    password = db.Column(db.String(80), nullable=False)
    name = db.Column(db.String(20), nullable=True)
    date = db.Column(db.String(80), nullable=True)
    gender = db.Column(db.String(20), nullable=False)

    def __repr__(self):
        return f'<User {self.username}>'

if __name__ == '__main__':
    with app.app_context():
        db.create_all()

        with open('C:/Users/82109/Desktop/src/flutter_banergy/lib/login/loginDB/user.csv', 'r', encoding='utf-8') as csvfile:
            csvreader = csv.DictReader(csvfile, fieldnames=['username', 'password', 'name', 'date', 'gender'])
            for idx, row in enumerate(csvreader):
                if idx == 0:
                    continue
                new_user = User(username=row['username'], password=row['password'], name=row['name'], date=row['date'], gender=row['gender'])
                db.session.add(new_user)
        db.session.commit()

@app.route('/user', methods=['POST'])
def get_users():
    user_list = []
    for user in User.query.all():
        user_data = {
            'id': user.id,
            'username': user.username,
            'password': user.password,
            'name': user.name,
            'date': user.date,
            'gender': user.gender
        }
        user_list.append(user_data)
    return jsonify(user_list)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
