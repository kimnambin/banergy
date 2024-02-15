import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_id_find.dart';
import 'package:flutter_banergy/login/login_join.dart';
import 'package:flutter_banergy/login/login_pw_find.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/login/widget.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
                          // 입력한 아이디와 비밀번호 가져오기
                          String username = '사용자가 입력한 아이디';
                          String password = '사용자가 입력한 비밀번호';

                          // 데이터베이스에서 사용자 정보 조회
                          final database = await openDatabase(
                            join(await getDatabasesPath(), 'user_database.db'),
                          );
                          final List<Map<String, dynamic>> users =
                              await database.query(
                            'users',
                            where: 'username = ? AND password = ?',
                            whereArgs: [username, password],
                          );

                          if (users.isNotEmpty) {
                            // 로그인 성공
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: const Text(
                                    '밴러지 로그인!!',
                                    style: TextStyle(color: Colors.black),
                                  ),
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
                          } else {
                            // 로그인 실패
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: const Text(
                                    '아이디 또는 비밀번호가 일치하지 않습니다.',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // 다이얼로그 닫기
                                      },
                                      child: const Text('확인'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
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
