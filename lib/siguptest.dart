import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UserRegistrationScreen extends StatefulWidget {
  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  void _registerUser() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String date = _dateController.text;
    final String gender = _genderController.text;

    try {
      var dio = Dio();
      var response = await dio.post(
        'http://192.168.216.174:3000/sign',
        data: {
          'username': username,
          'password': password,
          'name': name,
          'date': date,
          'gender': gender,
        },
      );

      // 서버로부터의 응답 처리
      print(response.data);
    } catch (e) {
      // 오류 처리
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserRegistrationScreen(),
  ));
}
