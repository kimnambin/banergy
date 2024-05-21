import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import '../mypage/mypage.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    home: Delete(),
  ));
}

// ignore: must_be_immutable
class Delete extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resonController = TextEditingController();
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  Delete({super.key});

  // 탈퇴하기
  Future<void> _delete(
      BuildContext context, MaterialPageRoute materialPageRoute) async {
    final String reason = _resonController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:3000/delete'),
        body: jsonEncode({
          'reason': reason,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        //  성공 시
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('탈퇴안료'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    //Navigator.push(
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstApp(),
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
        // 실패 시
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('비밀번호가 일치하지 않습니다.'),
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
    }
    // ignore: empty_catches
    catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "회원 탈퇴하기",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF1F2F7),
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
      bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/000.jpeg',
                  width: 80,
                  height: 80,
                ),
                const Text(
                  '탈퇴하기',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: '비밀번호를 입력해주세요.',
                        prefixIcon:
                            const Icon(Icons.lock_open, color: Colors.grey),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      controller: _passwordController,
                      obscureText: true, // 비밀번호를 숨기는 옵션
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      decoration: InputDecoration(
                        labelText: '간단한 탈퇴 사유를 적어주세요',
                        prefixIcon:
                            const Icon(Icons.help_outline, color: Colors.grey),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      controller: _resonController,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => _delete(
                    context,
                    MaterialPageRoute(builder: (context) => FirstApp()),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text('탈퇴하기'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
