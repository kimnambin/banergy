// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_banergy/login/login_FirstApp.dart';

import 'package:flutter_banergy/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MaterialApp(
      home: LoginApp(),
    ),
  );
}

// ignore: must_be_immutable
class LoginApp extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  InputField(
                    label: '아이디',
                    controller: _usernameController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    label: '비밀번호',
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 80),
                  ElevatedButton(
                      onPressed: () => _login(context),
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
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 로그인 함수
  Future<void> _login(BuildContext context) async {
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

class InputField extends StatelessWidget {
  final bool isTextArea;
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  const InputField({
    this.isTextArea = false,
    required this.label,
    required this.controller,
    required this.obscureText,
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
