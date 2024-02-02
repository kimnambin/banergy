import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_id_find.dart';
import 'package:flutter_banergy/login/login_join.dart';
import 'package:flutter_banergy/login/login_pw_find.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/login/widget.dart';
//import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      home: LoginApp(),
    ),
  );
}

//글로벌 키 -->> validator 사용하기 위함
class LoginApp extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    Image.asset(
                      'images/000.jpeg',
                      width: 200,
                      height: 200,
                    ),
                    const Text(
                      '밴러지',
                      style: TextStyle(
                        fontSize: 16, // 원하는 폰트 크기 설정
                        fontWeight: FontWeight.bold, // 글자를 볼드로 설정
                      ),
                    ),
                    const SizedBox(height: 50),

                    Column(
                      children: [
                        BanergyInputField(
                          hintText: '아이디를 입력해주세요.',
                          label: '',
                          icon: Icons.account_box,
                          iconColor: Colors.grey,
                          hintTextColor: Colors.grey,
                          borderRadius: BorderRadius.circular(12.0),
                          controller: TextEditingController(),
                        ),
                        const SizedBox(height: 20),
                        BanergyInputField(
                          hintText: '비밀번호를 입력해주세요.',
                          label: '',
                          icon: Icons.lock_open,
                          iconColor: Colors.grey,
                          hintTextColor: Colors.grey,
                          borderRadius: BorderRadius.circular(12.0),
                          controller: TextEditingController(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    //Color.fromARGB(255, 99, 255, 180), // 배경색 추가
                                    Colors.white,
                                content: const Text('밴러지 로그인완료!!',
                                    style: TextStyle(
                                        color: Colors.black)), // 글자 색상 추가
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MainpageApp(),
                                        ),
                                      );
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromRGBO(38, 159, 115, 1.0),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text('로그인'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    //텍스트 클릭 시 회원가입 창으로...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const JoinApp()),
                            );
                          },
                          child: const Text(
                            '회원가입',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const IDFindApp()),
                            );
                          },
                          child: const Text('아이디 찾기',
                              style: TextStyle(color: Colors.black)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PWFindApp()),
                            );
                          },
                          child: const Text('비밀번호 찾기',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    )
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
