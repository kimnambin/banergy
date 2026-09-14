// 자주 묻는 질문(FAQ)과 1:1 문의하기 화면입니다.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InquiryScreen(),
    ),
  );
}

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _sendInquiry(BuildContext context) async {
    final String title = _titleController.text;
    final String content = _contentController.text;

    try {
      final http.Response response = await http.post(
        Uri.parse('$_baseUrl:8000/mypage/inquiry'),
        body: jsonEncode({
          'inquirytitle': title,
          'inquirycontent': content,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        _showResultDialog(context, message: '문의가 완료되었습니다.');
      } else {
        // ignore: use_build_context_synchronously
        _showResultDialog(context, message: '다시 한번 확인해주세요.');
      }
    } catch (error) {
      debugPrint('서버에서 오류가 발생했음: $error');
      // ignore: use_build_context_synchronously
      _showResultDialog(context, message: '서버와의 통신 중 오류가 발생했습니다. 다시 시도해 주세요.');
    }
  }

  void _showResultDialog(BuildContext context, {required String message}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  '자주 묻는 내용',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const FAQList(),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  '문의하기',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _RequiredInputField(
                      controller: _titleController,
                      hintText: '제목',
                    ),
                    const SizedBox(height: 20),
                    _RequiredInputField(
                      isTextArea: true,
                      hintText: '내용을 입력하세요',
                      controller: _contentController,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _sendInquiry(context);
                        }
                      },
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
            ],
          ),
        ),
      ),
    );
  }
}

/// 빈 값을 허용하지 않는 문의 폼 전용 입력창.
/// (일반 힌트 입력창과 달리 항상 필수 입력 검사를 하고, 여러 줄 모드에서도
/// 아래쪽 밑줄을 계속 보여준다는 점이 달라서 별도로 둔다.)
class _RequiredInputField extends StatelessWidget {
  const _RequiredInputField({
    this.isTextArea = false,
    this.hintText = '',
    required this.controller,
  });

  final bool isTextArea;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: isTextArea ? 8 : 1,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return '필수 입력 항목입니다.';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        border: isTextArea ? InputBorder.none : null,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(227, 227, 227, 1.0)),
        ),
      ),
    );
  }
}

class FAQList extends StatelessWidget {
  const FAQList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FAQItem(
            question: '밴러지는 무슨 뜻인가요??',
            answer: '밴러지는 알레르기를 밴한다는 의미입니다',
          ),
          FAQItem(
            question: '누가 만들었나요??',
            answer: '임산성 , 한지욱 , 김남빈 , 이예원 , 양병승이 개발해 참여했습니다.',
          ),
          FAQItem(
            question: '밴러지의 무슨 앱인가요????',
            answer: '알러지로 마음대로 먹지도\n못하는 당신을 위한 맞춤형\n관리 앱',
          ),
          FAQItem(
            question: '밴러지의 장점은??',
            answer: '필터링 서비스로 개인이\n원하는 정보만 빠르게 확인!',
          ),
          FAQItem(
            question: '밴러지의 기능은??',
            answer: 'OCR, 바코드 기술로 간편하게\n찾아보는 음식 성분들!',
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width - 32;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              width: containerWidth,
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.question,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              width: containerWidth,
              padding: const EdgeInsets.all(20),
              child: Text(widget.answer),
            ),
        ],
      ),
    );
  }
}
