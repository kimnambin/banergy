// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import '../mypage/mypage.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    home: Delete(),
  ));
}

// ignore: must_be_immutable
class Delete extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resonController = TextEditingController();
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  Delete({super.key});

  // 탈퇴하기
  Future<void> _delete(
      BuildContext context, MaterialPageRoute materialPageRoute) async {
    final String reason = _resonController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:3000/delete'),
        body: jsonEncode({
          'reason': reason,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        //  성공 시
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('탈퇴안료'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    //Navigator.push(
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstApp(),
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
        // 실패 시
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('비밀번호가 일치하지 않습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
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
    }
    // ignore: empty_catches
    catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "탈퇴하기",
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFF1F2F7),
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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      InputField(
                        label: '계정 비밀번호',
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        label: '탈퇴 사유',
                        controller: _resonController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 95),
                      ElevatedButton(
                        onPressed: () => _delete(
                          context,
                          MaterialPageRoute(builder: (context) => FirstApp()),
                        ),
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
                                  fontSize: 22),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class InputField extends StatelessWidget {
  final bool isTextArea;
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  const InputField({
    this.isTextArea = false,
    required this.label,
    required this.controller,
    super.key,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              const TextStyle(fontFamily: 'PretendardSemiBold', fontSize: 30),
        ),
        TextFormField(
          obscureText: obscureText,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(227, 227, 227, 1.0)),
            ),
          ),
          controller: controller,
        ),
      ],
    );
  }
}
