// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:http/http.dart' as http;

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

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  // 문의하기 함수
  Future<void> inquirysend(BuildContext context) async {
    final String inquirytitle = inquirytitleController.text;
    final String inquirycontent = inquirycontentController.text;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.31.174:6000/inquiry'),
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
          title: const Text("문의하기"),
          backgroundColor: const Color.fromARGB(255, 29, 171, 102),
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
                    '문의하기',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField(
                          label: '제목 *',
                          controller: inquirytitleController,
                        ),
                        const SizedBox(height: 20),
                        InputField(
                          label: '내용 *',
                          isTextArea: true,
                          hintText: "수정 요청, 유의 사항 등등 문의",
                          controller: inquirycontentController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                      backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                    ),
                    child: const Text('문의하기',
                        style: TextStyle(color: Colors.white)),
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
  final String label;
  final bool isTextArea;
  final String hintText;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.label,
    this.isTextArea = false,
    this.hintText = "",
    required this.controller,
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
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '필수 입력 항목입니다.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
            controller: controller,
          )
        else
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '필수 입력 항목입니다.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
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
