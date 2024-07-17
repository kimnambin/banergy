import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MaterialApp(
    home: Changeidpw(),
  ));
}

class Changeidpw extends StatefulWidget {
  const Changeidpw({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

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

    if (kDebugMode) {
      print('현재 비밀번호: $password');
    }
    if (kDebugMode) {
      print('새로운 비밀번호: $newPassword');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:8000/logindb/changepw'),
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
                        builder: (context) => const MyHomePage(),
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
      if (kDebugMode) {
        print('Error sending request: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "비밀번호 변경하기",
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
        ),
        //bottomNavigationBar: const BottomNavBar(),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '기존 비밀번호',
                            style: TextStyle(
                                fontSize: 30, fontFamily: 'PretendardSemiBold'),
                          ),

                          InputField(
                            controller: _passwordController,
                            obscureText: true,
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
                            label: '',
                          ),

                          const SizedBox(height: 20),
                          //여기부터 새 비밀번호 입력
                          const Text(
                            '새 비밀번호',
                            style: TextStyle(
                                fontSize: 30, fontFamily: 'PretendardSemiBold'),
                          ),
                          InputField(
                            controller: newpasswordController,
                            obscureText: true,
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
                            label: '',
                          ),

                          const SizedBox(height: 95),
                          ElevatedButton(
                            onPressed: () => _changepw(context),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF03C95B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
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
        ));
  }
}

class InputField extends StatelessWidget {
  final bool isTextArea;
  final String label;
  final TextEditingController controller;
  final String? Function(dynamic value) validator;
  final bool obscureText;

  const InputField({
    this.isTextArea = false,
    required this.label,
    required this.controller,
    required this.validator,
    super.key,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}
