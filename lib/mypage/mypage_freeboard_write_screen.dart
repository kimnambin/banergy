// 자유게시판에 새 글을 작성하는 화면입니다.

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/common/hint_text_field.dart';
import 'package:flutter_banergy/mypage/mypage_freeboard.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(MaterialApp(home: FreeboardWriteScreen()));
}

// ignore: must_be_immutable
class FreeboardWriteScreen extends StatelessWidget {
  FreeboardWriteScreen({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  // 글 작성 함수
  Future<void> _submitPost(BuildContext context) async {
    final String title = _titleController.text;
    final String content = _contentController.text;

    try {
      final http.Response response = await http.post(
        Uri.parse('$_baseUrl:8000/mypage/free'),
        body: jsonEncode({'freetitle': title, 'freecontent': content}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        _showResultDialog(
          context,
          message: '업로드가 완료되었습니다.',
          backgroundColor: const Color.fromARGB(255, 29, 171, 102),
          foregroundColor: Colors.white,
          onConfirm: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Freeboard()),
            );
          },
        );
      } else {
        _showResultDialog(
          context,
          message: '다시 한번 확인해주세요.',
          backgroundColor: const Color(0xFFF1F2F7),
        );
      }
    } catch (error) {
      debugPrint('서버에서 오류가 발생했음: $error');
    }
  }

  void _showResultDialog(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    Color? foregroundColor,
    VoidCallback? onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              style: TextButton.styleFrom(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Freeboard()),
            );
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
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
                  HintTextField(hintText: '제목', controller: _titleController),
                  const SizedBox(height: 20),
                  HintTextField(
                    isTextArea: true,
                    textAreaMaxLines: 10,
                    hintText: '내용을 입력하세요.',
                    controller: _contentController,
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () => _submitPost(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 54),
                      backgroundColor: const Color(0xFF03C95B),
                    ),
                    child: const Text(
                      '완료',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PretendardSemiBold',
                        fontSize: 22,
                      ),
                    ),
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
