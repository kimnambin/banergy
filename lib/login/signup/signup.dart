// 회원가입 화면입니다.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:flutter_banergy/login/signup/joinwidget.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: JoinApp(),
    ),
  );
}

class JoinApp extends StatefulWidget {
  const JoinApp({super.key});

  @override
  State<JoinApp> createState() => _JoinAppState();
}

class _JoinAppState extends State<JoinApp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  // 회원가입 함수
  Future<void> _signup(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String date = _dateController.text;
    final String? gender = _selectedGender;

    try {
      final http.Response response = await http.post(
        Uri.parse('$_baseUrl:8000/logindb/sign'),
        body: jsonEncode({
          'username': username,
          'password': password,
          'name': name,
          'date': date,
          'gender': gender,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        _showResultDialog(
          context,
          message: '회원가입 완료!!',
          onConfirm: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginApp()),
            );
          },
        );
      } else {
        _showResultDialog(context, message: '입력한 정보를 확인해주세요.');
      }
    } catch (error) {
      debugPrint('Error sending request: $error');
    }
  }

  void _showResultDialog(
    BuildContext context, {
    required String message,
    VoidCallback? onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FirstApp()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/000.jpeg',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'PretendardSemiBold',
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildFieldLabel('아이디'),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(),
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 15),
                    _buildFieldLabel('비밀번호'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 15),
                    _buildFieldLabel('비밀번호 재확인'),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(),
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 15),
                    _buildFieldLabel('이름'),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return '다시 확인해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildFieldLabel('성별'),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        genderbox(
                          selectedGender: _selectedGender,
                          onChanged: (String? selectedGender) {
                            setState(() => _selectedGender = selectedGender);
                          },
                          hintText: '',
                          hintStyle: const TextStyle(color: Color(0xFF777777)),
                          iconColor: Colors.grey,
                          hintTextColor: Colors.grey,
                          border: const Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        const Positioned(
                          left: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.expand_more,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildFieldLabel('생년월일'),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        DatePickerButton(
                          controller: _dateController,
                          onChanged: (String selectedDate) {
                            setState(() {
                              _dateController.text = selectedDate;
                            });
                          },
                          backgroundColor: Colors.white,
                          hintText: '',
                          hintStyle: const TextStyle(color: Color(0xFF777777)),
                          iconColor: Colors.grey,
                          hintTextColor: Colors.grey,
                          border: const Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        const Positioned(
                          left: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.expand_more,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 65),
                    ElevatedButton(
                      onPressed: () => _signup(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF03C95B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontFamily: 'PretendardSemiBold',
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(fontFamily: 'PretendardBold', fontSize: 24),
      ),
    );
  }

  String? _validateUsername(String? value) {
    final RegExp pattern = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$');
    if (value == null || value.isEmpty) {
      return '아이디를 입력하세요.';
    }
    if (!pattern.hasMatch(value) || value.length < 5) {
      return '아이디는 5글자 이상의 영어 + 숫자 조합이어야 합니다.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final RegExp pattern =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]+$');
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요.';
    }
    if (!pattern.hasMatch(value) || value.length < 5) {
      return '비밀번호는 5글자 이상의 영어 + 숫자 + 특수문자 조합이어야 합니다.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호 재확인.';
    }
    if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }
}
