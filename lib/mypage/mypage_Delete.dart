// ignore: file_names
// 회원 탈퇴 화면입니다.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/common/labeled_text_field.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(MaterialApp(home: Delete()));
}

// ignore: must_be_immutable
class Delete extends StatelessWidget {
  Delete({super.key});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  // 탈퇴하기
  Future<void> _delete(BuildContext context) async {
    final String reason = _reasonController.text;
    final String password = _passwordController.text;

    try {
      final http.Response response = await http.post(
        Uri.parse('$_baseUrl:8000/logindb/delete'),
        body: jsonEncode({'reason': reason, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        _showResultDialog(
          context,
          message: '탈퇴완료',
          onConfirm: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FirstApp()),
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        _showResultDialog(context, message: '비밀번호가 일치하지 않습니다.');
      }
      // ignore: empty_catches
    } catch (error) {}
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
        title: const Text('탈퇴하기', textAlign: TextAlign.center),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  LabeledTextField(
                    label: '계정 비밀번호',
                    controller: _passwordController,
                    obscureText: true,
                    labelStyle: const TextStyle(
                      fontFamily: 'PretendardSemiBold',
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LabeledTextField(
                    label: '탈퇴 사유',
                    controller: _reasonController,
                    labelStyle: const TextStyle(
                      fontFamily: 'PretendardSemiBold',
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 95),
                  ElevatedButton(
                    onPressed: () => _delete(context),
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
            ),
          ),
        ),
      ),
    );
  }
}
