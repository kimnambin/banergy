import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:http/http.dart' as http;
//import 'joinwidget.dart';

void main() async {
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
  final TextEditingController _dateController = TextEditingController();
  String _pw = '';

// pw찾기 함수
  Future<void> _findpw(BuildContext context) async {
    final String name = _nameController.text;
    final String username = _usernameController.text;
    final String date = _dateController.text;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.174:3000/findpw'),
        body: jsonEncode({
          'name': name,
          'username': username,
          'date': date,
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
        Uri.parse('http://192.168.1.174:3000/sign'),
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
          backgroundColor: const Color.fromARGB(255, 29, 171, 102),
          title: const Text("비밀번호 찾기"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginApp()),
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
                    const SizedBox(height: 60),
                    Image.asset(
                      'images/000.jpeg',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 50),
                    Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: '이름',
                            prefixIcon: const Icon(Icons.account_circle,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '다시 확인해주세요.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: '아이디를 입력해주세요.',
                            prefixIcon: const Icon(Icons.account_box,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) {
                            String pattern =
                                r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$';
                            RegExp regex = RegExp(pattern);

                            if (value == null || value.isEmpty) {
                              return '아이디를 입력하세요.';
                            } else if (!regex.hasMatch(value) ||
                                value.length < 5) {
                              return '아이디는 5글자 이상의 영어 + 숫자 조합이어야 합니다.';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // DatePickerButton(
                        //   controller: _dateController,
                        //   onChanged: (selectedDate) {
                        //     setState(() {
                        //       _dateController.text = selectedDate.toString();
                        //     });
                        //   },
                        //   label: '',
                        //   hintText: '생년월일',
                        //   iconColor: Colors.grey,
                        //   hintTextColor: Colors.grey,
                        //   icon: Icons.calendar_today,
                        //   borderRadius: BorderRadius.circular(12.0),
                        // ),
                        // const SizedBox(height: 35),
                        ElevatedButton(
                          onPressed: () => _findpw(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 29, 171, 102),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Center(
                              child: Text('완료'),
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
