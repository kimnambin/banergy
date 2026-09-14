// 비밀번호 찾기 화면입니다.

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/common/labeled_text_field.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized(); // 서버 연동을 위함
  runApp(
    const MaterialApp(
      home: PWFindApp(),
    ),
  );
}

class PWFindApp extends StatefulWidget {
  const PWFindApp({super.key});

  @override
  State<PWFindApp> createState() => _PWFindAppState();
}

class _PWFindAppState extends State<PWFindApp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _password = '';
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  // 비밀번호 찾기 함수
  Future<void> _findPassword(BuildContext context) async {
    final String name = _nameController.text;
    final String username = _usernameController.text;

    try {
      final http.Response response = await http.post(
        Uri.parse('$_baseUrl:8000/logindb/findpw'),
        body: jsonEncode({'name': name, 'username': username}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _password =
              (json.decode(response.body) as Map<String, dynamic>)['password'];
        });
        _showResultDialog(
          message: '회원님의 비밀번호는 "$_password" 입니다.',
          onConfirm: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginApp()),
            );
          },
        );
      } else {
        _showResultDialog(message: '정보가 일치하지 않습니다.');
      }
    } catch (error) {
      debugPrint('서버에서 오류가 발생했음: $error');
    }
  }

  void _showResultDialog({required String message, VoidCallback? onConfirm}) {
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
                backgroundColor: const Color(0xFF03C95B),
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
        title: const Text(
          '비밀번호 찾기',
          style: TextStyle(fontFamily: 'PretendardSemiBold', fontSize: 20),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    LabeledTextField(
                      label: '계정 이름',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: '계정 아이디',
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 95),
                    ElevatedButton(
                      onPressed: () => _findPassword(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF03C95B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
