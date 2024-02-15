import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SqliteModel {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await initDB();
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'user_database.db');

    return await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }
}

FutureOr<void> _onCreate(Database db, int version) {
  String sql = '''
  CREATE TABLE IF NOT EXISTS users(
    username TEXT, 
    password TEXT, 
    name TEXT, 
    date TEXT, 
    gender TEXT)
  ''';

  db.execute(sql);
}

FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}

Future<void> UserData(String username, String password, String name,
    String date, String gender) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'user_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE IF NOT EXISTS users(username TEXT, password TEXT, name TEXT, date TEXT, gender TEXT)',
      );
    },
    version: 1,
  );

  // 비밀번호 해싱
  var bytes = utf8.encode(password);
  var hashedPassword = sha256.convert(bytes).toString();

  // 사용자 정보 삽입
  await database.insert(
    'users',
    {
      'username': username,
      'password': hashedPassword,
      'name': name,
      'date': date,
      'gender': gender,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> getUserData() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'user_database.db'),
  );

  final List<Map<String, dynamic>> users = await database.query('users');

  for (final user in users) {
    print('User ID: ${user['username']}');
    print('Password: ${user['password']}');
    print('Name: ${user['name']}');
    print('Date: ${user['date']}');
    print('Gender: ${user['gender']}');
  }
}
