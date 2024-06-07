// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/mypage/mypage_freeboard.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    home: Freeboard_WriteScreen(),
  ));
}

// ignore: camel_case_types, must_be_immutable
class Freeboard_WriteScreen extends StatelessWidget {
  Freeboard_WriteScreen({super.key});
  final TextEditingController freetitleController = TextEditingController();
  final TextEditingController freecontentController = TextEditingController();
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  // 글 작성 함수
  Future<void> free(BuildContext context) async {
    final String freetitle = freetitleController.text;
    final String freecontent = freecontentController.text;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:6000/free'),
        body: jsonEncode({
          'freetitle': freetitle,
          'freecontent': freecontent,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('업로드가 완료되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Freeboard(),
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('다시 한번 확인해주세요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F2F7),
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
        print('서버에서 오류가 발생했음: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '글 쓰기',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                InputField(hintText: "제목", controller: freetitleController),
                const SizedBox(height: 20),
                InputField(
                  isTextArea: true,
                  hintText: "내용을 입력하세요.",
                  controller: freecontentController,
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {
                    free(context); // 수정: free 함수 호출
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    backgroundColor: const Color(0xFF03C95B),
                  ),
                  child: const Text('완료',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PretendardSemiBold',
                          fontSize: 22)),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class InputField extends StatelessWidget {
  final bool isTextArea;
  final String hintText;
  final TextEditingController controller;

  const InputField({
    this.isTextArea = false,
    this.hintText = "",
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTextArea)
          TextFormField(
            maxLines: 10,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            controller: controller,
          )
        else
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(227, 227, 227, 1.0)),
              ),
            ),
            controller: controller,
          ),
      ],
    );
  }
}
