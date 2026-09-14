// 비밀번호 변경 화면입니다.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/common/labeled_text_field.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MaterialApp(home: Changeidpw()));
}

class Changeidpw extends StatefulWidget {
  const Changeidpw({super.key});

  @override
  State<Changeidpw> createState() => _ChangeidpwState();
}

class _ChangeidpwState extends State<Changeidpw> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController =
      TextEditingController();
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
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

  Future<void> _changePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String password = _passwordController.text;
    final String newPassword = _newPasswordController.text;

    try {
      final http.Response response = await http.post(
        Uri.parse('$_baseUrl:8000/logindb/changepw'),
        body: jsonEncode({'password': password, 'new_password': newPassword}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('비밀번호가 성공적으로 변경되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      ),
                    );
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
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('비밀번호를 다시 한번 확인해주세요.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      debugPrint('Error sending request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 변경하기', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabeledTextField(
                          label: '기존 비밀번호',
                          controller: _passwordController,
                          obscureText: true,
                          validator: _validatePassword,
                          labelStyle: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'PretendardSemiBold',
                          ),
                        ),
                        const SizedBox(height: 20),
                        LabeledTextField(
                          label: '새 비밀번호',
                          controller: _newPasswordController,
                          obscureText: true,
                          validator: _validatePassword,
                          labelStyle: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'PretendardSemiBold',
                          ),
                        ),
                        const SizedBox(height: 95),
                        ElevatedButton(
                          onPressed: () => _changePassword(context),
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
                                '완료',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
