// ignore_for_file: use_build_context_synchronously
//인트로 끝나고 보이는 페이지
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/NoUser/Nouserfiltering.dart';
import 'package:flutter_banergy/login/login_id_find.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:flutter_banergy/login/signup/signup.dart';
import 'package:flutter_banergy/login/login_pw_find.dart';
import 'package:flutter_banergy/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MaterialApp(
      home: FirstApp(),
    ),
  );
}

// ignore: must_be_immutable
class FirstApp extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  FirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 앱 시작 시 자동 로그인 시도
    autoLogin(context);

    return MaterialApp(
        home: Scaffold(
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
                        MaterialPageRoute(
                          builder: (context) => LoginApp(),
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
                          child: SizedBox(
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
                          )),
                    ),

                    //회원가입 이용하기
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
                          child: SizedBox(
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
                          )),
                    ),
                    const SizedBox(height: 40),

                    //텍스트 클릭 시 해당 창으로...
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
                          child: const Text('아이디 찾기',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'PretendardSemiBold',
                                  fontSize: 16)),
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
                          child: const Text('비밀번호 찾기',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'PretendardSemiBold',
                                  fontSize: 16)),
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
                                fontFamily: 'PretendardSemiBold', fontSize: 18),
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
    ));
  }

  // 로그인 함수
  Future<void> _login(BuildContext context) async {
    String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    //로그인 유지
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:8000/logindb/login'),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // 로그인 성공 시
      if (response.statusCode == 200) {
        //로그인 유지를 위함
        final authToken = jsonDecode(response.body)['access_token'];
        await saveToken(authToken);
        await fetchUserInfo(authToken);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('로그인 성공'),
              content: const Text('밴러지에 로그인하였습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    //Navigator.push(
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainpageApp(),
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
        // 로그인 실패 시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('로그인 실패'),
              content: const Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
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
      if (kDebugMode) {
        print('서버에서 오류가 발생했음');
      }
    }
  }

  // 로그인 유지를 위한 토큰
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // 사용자 정보를 가져오는 함수
  Future<void> fetchUserInfo(String token) async {
    String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final username = jsonDecode(response.body)['username'];
        if (kDebugMode) {
          print('로그인한 사용자: $username');
        }
      } else {
        throw Exception('Failed to fetch user info');
      }
    } catch (error) {
      // 오류 발생 시 처리
    }
  }

  // 자동 로그인
  Future<void> autoLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      String? authToken = prefs.getString('authToken');
      if (authToken != null) {
        // 토큰이 유효한지 확인하고 사용자 정보 가져오기
        final isValid = await _validateToken(authToken);
        if (isValid) {
          // 유효한 경우 사용자 정보 가져오기
          await fetchUserInfo(authToken);
          // 홈 화면으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainpageApp(),
            ),
          );
          return;
        } else {
          // 토큰이 만료된 경우 로그아웃 처리
          await logout(context);
        }
      }
    }
  }

  // 로그아웃
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('authToken');
    // 로그인 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FirstApp(),
      ),
    );
  }

  // 토큰 유효성 검사 함수
  Future<bool> _validateToken(String token) async {
    return true;
  }
}
