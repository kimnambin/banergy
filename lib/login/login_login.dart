import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_find.dart';
import 'package:flutter_banergy/login/login_join.dart';
import 'package:flutter_banergy/main.dart';

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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 50, 160, 107)),
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
                    SizedBox(height: 100),

                    Image.asset(
                      'images/000.jpeg',
                      width: 200,
                      height: 200,
                    ),
                    Text('밴러지'),
                    SizedBox(height: 60),
                    Column(
                      children: [
                        InputField(
                          hintText: '아이디를 입력해주세요.',
                          label: '',
                          icon: Icons.account_box,
                          iconColor: Colors.grey,
                          hintTextColor: Colors.grey,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        SizedBox(height: 10),
                        InputField(
                          hintText: '비밀번호를 입력해주세요.',
                          label: '',
                          icon: Icons.lock_open,
                          iconColor: Colors.grey,
                          hintTextColor: Colors.grey,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 99, 255, 180), // 배경색 추가
                                content: Text('밴러지 로그인완료!!',
                                    style: TextStyle(
                                        color: Colors.black)), // 글자 색상 추가
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainpageApp(),
                                        ),
                                      );
                                    },
                                    child: Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text('로그인'),
                        ),
                      ),
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
                    ),
                    SizedBox(height: 10),

                    //텍스트 클릭 시 회원가입 창으로...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JoinApp()),
                            );
                          },
                          child: Text(
                            '회원가입',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FindApp()),
                            );
                          },
                          child: Text('아이디 찾기',
                              style: TextStyle(color: Colors.black)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FindApp()),
                            );
                          },
                          child: Text('비밀번호 찾기',
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

// 인풋 필드 선언
class InputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final Color iconColor; // 아이콘 색상 추가
  final Color hintTextColor; // 힌트 텍스트 색상 추가
  final BorderRadius borderRadius;

  InputField({
    required this.label,
    this.hintText = "",
    required this.icon,
    required this.iconColor,
    required this.hintTextColor,
    required this.borderRadius,
  });

//인풋 필드 내용
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 입력 항목입니다.';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hintTextColor),
            border: OutlineInputBorder(
              borderRadius: borderRadius,
            ),
            prefixIcon: Icon(icon, color: iconColor),
          ),
        ),
      ],
    );
  }
}
