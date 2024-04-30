import 'dart:convert';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';

void main() {
  runApp(const MaterialApp(
    home: Changeidpw(),
  ));
}

class Changeidpw extends StatefulWidget {
  const Changeidpw({super.key});

  @override
  _ChangeidpwState createState() => _ChangeidpwState();
}

class _ChangeidpwState extends State<Changeidpw> {
  final _formKey = GlobalKey<FormState>(); // 폼 키 초기화

  final _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final newpasswordController = TextEditingController();
  final TextEditingController newconfirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    newpasswordController.dispose();
    newconfirmPasswordController.dispose();
    super.dispose();
  }

  bool isPasswordValid() {
    // 비밀번호 유효성 검사
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(_passwordController.text) &&
        _passwordController.text.length >= 5 &&
        newpasswordController.text.length >= 5;
  }

  bool isConfirmPasswordValid() {
    // 비밀번호 확인 유효성 검사
    return _confirmPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text == _passwordController.text &&
        newconfirmPasswordController.text == newpasswordController.text;
  }

  bool isFormValid() {
    // 모든 필드에 대한 유효성 검사
    return isPasswordValid() && isConfirmPasswordValid();
  }

  Future<void> _changepw(BuildContext context) async {
    // 비밀번호 변경 요청 보내기
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String password = _passwordController.text;
    final String newPassword = newpasswordController.text;

    print('현재 비밀번호: $password');
    print('새로운 비밀번호: $newPassword');

    try {
      final response = await http.post(
        Uri.parse('http://192.168.31.174:3000/changepw'),
        body: jsonEncode({
          'password': password,
          'new_password': newPassword,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // 비밀번호 변경 성공 시
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('비밀번호가 성공적으로 변경되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MypageApp(),
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
        // 비밀번호 변경 실패 시
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('비밀번호를 다시 한번 확인해주세요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("비번 변경하기"),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/000.jpeg',
                    width: 80,
                    height: 80,
                  ),
                  const Text(
                    '비밀번호 변경하기',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '현재 비밀번호',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '비밀번호를 입력해주세요.',
                          prefixIcon:
                              const Icon(Icons.lock_open, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          String pattern =
                              r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]+$';
                          RegExp regex = RegExp(pattern);

                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력하세요.';
                          } else if (!regex.hasMatch(value) ||
                              value.length < 5) {
                            return '비밀번호는 5글자 이상의 영어 + 숫자 + 특수문자 조합이어야 합니다.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '비밀번호를 다시 입력해주세요.',
                          prefixIcon:
                              const Icon(Icons.lock_open, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호 재확인.';
                          } else if (value != _passwordController.text) {
                            return '비밀번호가 일치하지 않습니다.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      //여기부터 새 비밀번호 입력
                      const Text(
                        '새로운 비밀번호',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: newpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '새로운 비밀번호를 입력해주세요.',
                          prefixIcon:
                              const Icon(Icons.lock_open, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          String pattern =
                              r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]+$';
                          RegExp regex = RegExp(pattern);

                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력하세요.';
                          } else if (!regex.hasMatch(value) ||
                              value.length < 5) {
                            return '비밀번호는 5글자 이상의 영어 + 숫자 + 특수문자 조합이어야 합니다.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: newconfirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '새로운 비밀번호를 다시 입력해주세요.',
                          prefixIcon:
                              const Icon(Icons.lock_open, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호 재확인.';
                          } else if (value != newpasswordController.text) {
                            return '비밀번호가 일치하지 않습니다.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _changepw(context),
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
                            child: Text('변경하기'),
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
    );
  }
}
