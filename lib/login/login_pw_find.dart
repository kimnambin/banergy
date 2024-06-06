import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:http/http.dart' as http;
//import 'joinwidget.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
  State<PWFindApp> createState() => _PWFindAppAppState();
}

class _PWFindAppAppState extends State<PWFindApp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  //final TextEditingController _dateController = TextEditingController();
  String _pw = '';
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

// pw찾기 함수
  Future<void> _findpw(BuildContext context) async {
    final String name = _nameController.text;
    final String username = _usernameController.text;
    //final String date = _dateController.text;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:3000/findpw'),
        body: jsonEncode({
          'name': name,
          'username': username,
          //'date': date,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // 입력정보가 맞을 때
        // ignore: use_build_context_synchronously
        setState(() {
          _pw = jsonDecode(response.body)['password'];
        });

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('회원님의 비밀번호는 "$_pw" 입니다.'),
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
        //  실패 시
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
        Uri.parse('$baseUrl:3000/sign'),
      );
      if (response.statusCode == 200) {
        _findpw;
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
            "비밀번호 찾기",
            style: TextStyle(fontFamily: 'PretendardSemiBold', fontSize: 20),
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
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    InputField(
                      label: '계정 이름',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: '계정 아이디',
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 95),
                    ElevatedButton(
                      onPressed: () => _findpw(context),
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
                                fontFamily: 'PretendardSemiBold', fontSize: 22),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          //bottomNavigationBar: BottomNavBar(),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final bool isTextArea;
  final String label;
  final TextEditingController controller;

  const InputField({
    this.isTextArea = false,
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
          controller: controller,
        ),
      ],
    );
  }
}
