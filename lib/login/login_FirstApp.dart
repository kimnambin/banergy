// 인트로가 끝난 뒤 보여주는 첫 화면입니다.
// 로그인/회원가입/아이디·비밀번호 찾기/비회원 이용 중 하나를 고르는 진입점 역할만 합니다.

import 'package:flutter/material.dart';
import 'package:flutter_banergy/NoUser/Nouserfiltering.dart';
import 'package:flutter_banergy/login/login_id_find.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:flutter_banergy/login/login_pw_find.dart';
import 'package:flutter_banergy/login/signup/signup.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MaterialApp(
      home: FirstApp(),
    ),
  );
}

// ignore: must_be_immutable
class FirstApp extends StatelessWidget {
  FirstApp({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      '가장 편한 방법으로\n시작해 보세요!',
                      style: TextStyle(
                        fontFamily: 'PretendardBold',
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(height: 130),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginApp()),
                      ),
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
                            '로그인',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'PretendardSemiBold',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JoinApp(),
                        ),
                      ),
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
                            '회원가입',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'PretendardSemiBold',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IDFindApp(),
                              ),
                            );
                          },
                          child: const Text(
                            '아이디 찾기',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PretendardSemiBold',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PWFindApp(),
                              ),
                            );
                          },
                          child: const Text(
                            '비밀번호 찾기',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PretendardSemiBold',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Nouserfiltering(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Color(0xFFBDBDBD)),
                        ),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text(
                            '비회원으로 이용하기',
                            style: TextStyle(
                              fontFamily: 'PretendardSemiBold',
                              fontSize: 18,
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
