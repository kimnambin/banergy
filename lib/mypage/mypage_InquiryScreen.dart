// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    onGenerateRoute: (settings) {
      if (settings.name == '/inquiryDetail') {
        return MaterialPageRoute(
          builder: (context) => const InquiryDetailScreen(),
        );
      }
      return null;
    },
    // Theme 설정
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green, // 기본 색상 설정
      ).copyWith(),
    ),
  ));
}

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  bool isFAQVisible = false;
  final TextEditingController inquirytitleController = TextEditingController();
  final TextEditingController inquirycontentController =
      TextEditingController();
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 문의하기 함수
  Future<void> inquirysend(BuildContext context) async {
    final String inquirytitle = inquirytitleController.text;
    final String inquirycontent = inquirycontentController.text;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:6000/inquiry'),
        body: jsonEncode({
          'inquirytitle': inquirytitle,
          'inquirycontent': inquirycontent,
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
              content: const Text('문의가 완료되었습니다.'),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('다시 한번 확인해주세요.'),
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
        print('서버에서 오류가 발생했음: $e'); // 수정: 예외 정보 출력
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                    '문의하기',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField(
                          isTextArea: false,
                          controller: inquirytitleController,
                          hintText: "제목",
                        ),
                        const SizedBox(height: 20),
                        InputField(
                          isTextArea: true,
                          hintText: "내용을 입력하세요",
                          controller: inquirycontentController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      inquirysend(context);
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        setState(() {
                          isFAQVisible = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 54),
                      backgroundColor: const Color(0xFF03C95B),
                    ),
                    child:
                        const Text('완료', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 40),
                  if (isFAQVisible) const FAQList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final bool isTextArea;
  final String hintText;
  final TextEditingController controller;

  const InputField({
    super.key,
    this.isTextArea = false,
    this.hintText = "",
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTextArea) // isTextArea가 true일 때만 테두리 없애기
          TextFormField(
            maxLines: 8,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '필수 입력 항목입니다.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(227, 227, 227, 1.0)),
              ),
            ),
            controller: controller,
          ),
        if (!isTextArea)
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

class InquiryDetailScreen extends StatelessWidget {
  const InquiryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('문의 화면'),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '자주 묻는 내용',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FAQList(),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQList extends StatelessWidget {
  const FAQList({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
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
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width - 32;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              width: containerWidth,
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.question,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isExpanded)
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
