import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => InquiryScreen(),
      '/inquiryDetail': (context) => InquiryDetailScreen(),
    },
  ));
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class InquiryScreen extends StatefulWidget {
  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  @override
  Widget build(BuildContext context) {
    theme:
    ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 50, 160, 107)),
      useMaterial3: true,
    );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("문의하기"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '문의하기',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField(
                          label: '제목 *',
                        ),
                        SizedBox(height: 20),
                        InputField(
                          label: '내용 *',
                          isTextArea: true,
                          hintText: "수정 요청, 유의 사항 등등 문의",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text('문의가 성공적으로 접수되었습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    Navigator.pushNamed(
                                      context,
                                      '/inquiryDetail',
                                    );
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('문의하기'),
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

class InputField extends StatelessWidget {
  final String label;
  final bool isTextArea;
  final String hintText;

  InputField({
    required this.label,
    this.isTextArea = false,
    this.hintText = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (isTextArea)
          TextFormField(
            maxLines: 10,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '필수 입력 항목입니다.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(),
            ),
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
              border: OutlineInputBorder(),
            ),
          ),
      ],
    );
  }
}

class InquiryDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문의 화면'),
      ),
      body: SingleChildScrollView(
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FAQItem(
              question: '자주 묻는 내용1',
              answer:
                  '회원가입 시 선택한 학교/캠퍼스는 가입 이후 변경할 수 없습니다. 다른 학교/캠퍼스로 변경을 원하실 경우, 현재 사용하시는 계정을 탈퇴하신 후 새로운 학교/캠퍼스로 다시 회원가입을 해주시기 바랍니다.',
            ),
            FAQItem(
              question: '자주 묻는 내용2',
              answer:
                  '에브리타임은 대한민국 대학교 재학생 및 졸업생을 위한 서비스입니다. 대한민국 대학교의 재학생 및 졸업생이 아닐 경우, 이용이 불가능합니다.',
            ),
            FAQItem(
              question: '자주 묻는 내용3',
              answer: '',
            ),
            FAQItem(
              question: '자주 묻는 내용4',
              answer: '',
            ),
            FAQItem(
              question: '자주 묻는 내용5',
              answer: '',
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

  FAQItem({
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
      margin: EdgeInsets.only(bottom: 15),
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
              padding: EdgeInsets.all(10),
              child: Text(
                widget.question,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isExpanded)
            Container(
              width: containerWidth,
              padding: EdgeInsets.all(20),
              child: Text(widget.answer),
            ),
        ],
      ),
    );
  }
}
