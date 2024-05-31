from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)
    name = db.Column(db.String(20), nullable=True)
    date = db.Column(db.String(80), nullable=True)
    gender = db.Column(db.String(20), nullable=False)
    allergies = db.Column(db.String(128), nullable=True)