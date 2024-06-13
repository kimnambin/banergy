import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'joinwidget.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const MaterialApp(
      home: IDFindApp(),
    ),
  );
}

class IDFindApp extends StatefulWidget {
  const IDFindApp({super.key});

  @override
  State<IDFindApp> createState() => _IDFindAppState();
}

class _IDFindAppState extends State<IDFindApp> {
  //final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  //final TextEditingController _dateController = TextEditingController();
  String _username = '';
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

// id찾기 함수
  Future<void> _findid(BuildContext context) async {
    final String name = _nameController.text;
    // final String password = _passwordController.text;
    // final String date = _dateController.text;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:8000/logindb/findid'),
        body: jsonEncode({
          'name': name,
          // 'password': password,
          // 'date': date,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // 입력정보가 맞을 때
        // ignore: use_build_context_synchronously
        setState(() {
          _username = jsonDecode(response.body)['username'];
        });

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('회원님의 아이디는: "$_username" 입니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginApp(),
                      ),
                    );
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
      } else {
        // 실패 시
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('정보가 일치하지 않습니다.'),
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
    } catch (e) {
      // 오류 발생 시
      print('서버에서 오류가 발생했음');
    }
  }

  // 데이터 가져오는 함수
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:8000/logindb/sign'),
      );
      if (response.statusCode == 200) {
        _findid;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 발생 시 처리
      // 예: 오류 메시지 표시
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "아이디 찾기",
            style: TextStyle(fontFamily: 'PretendardSemiBold', fontSize: 22),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFF1F2F7),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  InputField(
                    label: '계정 이름',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),
                  // const InputField(
                  //   label: '계정 비밀번호',
                  //   //controller: _passwordController,
                  // ),
                  const SizedBox(height: 95),
                  ElevatedButton(
                      onPressed: () => _findid(context),
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
                                  fontSize: 22),
                            ),
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const InputField({
    required this.label,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: 'PretendardBold', fontSize: 30),
        ),
        TextFormField(
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
