// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/mypage/mypage_freeboard.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Freeboard_WriteScreen extends StatelessWidget {
  Freeboard_WriteScreen({super.key});
  final TextEditingController freetitleController = TextEditingController();
  final TextEditingController freecontentController = TextEditingController();

  // 글 작성 함수
  Future<void> free(BuildContext context) async {
    final String freetitle = freetitleController.text;
    final String freecontent = freecontentController.text;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.31.174:6000/free'),
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
        print('서버에서 오류가 발생했음: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("글 쓰기"),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
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
                InputField(label: '제목 *', controller: freetitleController),
                const SizedBox(height: 20),
                InputField(
                  label: '내용 *',
                  isTextArea: true,
                  hintText: "자유롭게 글을 작성해주세요.",
                  controller: freecontentController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    free(context); // 수정: free 함수 호출
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                  ),
                  child: const Text('글 올리기',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final bool isTextArea;
  final String hintText;
  final TextEditingController controller;

  const InputField({
    required this.label,
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
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (isTextArea)
          TextFormField(
            maxLines: 10,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            controller: controller,
          )
        else
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            controller: controller,
          ),
      ],
    );
  }
}
