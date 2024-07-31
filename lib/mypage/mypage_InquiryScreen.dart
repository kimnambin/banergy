import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
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
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final TextEditingController inquirytitleController = TextEditingController();
  final TextEditingController inquirycontentController =
      TextEditingController();
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> inquirysend(BuildContext context) async {
    final String inquirytitle = inquirytitleController.text;
    final String inquirycontent = inquirycontentController.text;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:8000/mypage/inquiry'),
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
      if (kDebugMode) {
        print('서버에서 오류가 발생했음: $e');
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('서버와의 통신 중 오류가 발생했습니다. 다시 시도해 주세요.'),
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
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )),
              const SizedBox(height: 20),
              const FAQList(), // FAQList를 포함한 위젯
              const SizedBox(height: 40),
              // ElevatedButton(
              //   onPressed: () {
              //     // 스크롤을 아래로 이동시키는 작업
              //     _scrollToBottom(context);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: const Size(double.infinity, 54),
              //     backgroundColor: const Color(0xFF03C95B),
              //   ),
              //   child: const Text(
              //     '아래로 스크롤',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontFamily: 'PretendardSemiBold',
              //       fontSize: 22,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 40),
              const Center(
                  child: Text(
                '문의하기',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )),
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          inquirysend(context);
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

  void _scrollToBottom(BuildContext context) {
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
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
        TextFormField(
          maxLines: isTextArea ? 8 : 1,
          validator: (value) {
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
          controller: controller,
        ),
      ],
    );
  }
}

class FAQList extends StatelessWidget {
  const FAQList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
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
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

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
