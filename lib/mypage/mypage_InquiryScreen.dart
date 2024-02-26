// import 'package:flutter/material.dart';
// import 'package:flutter_banergy/bottombar.dart';

// void main() {
//   runApp(const InquiryScreen());
// }

// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// class InquiryScreen extends StatefulWidget {
//   const InquiryScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _InquiryScreenState createState() => _InquiryScreenState();
// }

// class _InquiryScreenState extends State<InquiryScreen> {
//   bool isFAQVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     ThemeData(
//       colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromARGB(255, 50, 160, 107)),
//       useMaterial3: true,
//     );
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("문의하기"),
//           backgroundColor: const Color.fromARGB(255, 29, 171, 102),
//         ),
//         // bottomNavigationBar: const BottomNavBar(), // 주석 처리
//         body: SingleChildScrollView(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(40.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Text(
//                     '문의하기',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   Form(
//                     key: _formKey,
//                     child: const Column(
//                       children: [
//                         InputField(
//                           label: '제목 *',
//                         ),
//                         SizedBox(height: 20),
//                         InputField(
//                           label: '내용 *',
//                           isTextArea: true,
//                           hintText: "수정 요청, 유의 사항 등등 문의",
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState != null &&
//                           _formKey.currentState!.validate()) {
//                         setState(() {
//                           isFAQVisible = true;
//                         });
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 29, 171, 102),
//                     ),
//                     child: const Text('문의하기',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                   const SizedBox(height: 40),
//                   if (isFAQVisible) const FAQList(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: const BottomNavBar(),
//       ),
//     );
//   }
// }

// class InputField extends StatelessWidget {
//   final String label;
//   final bool isTextArea;
//   final String hintText;

//   const InputField({
//     super.key,
//     required this.label,
//     this.isTextArea = false,
//     this.hintText = "",
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         if (isTextArea)
//           TextFormField(
//             maxLines: 4,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return '필수 입력 항목입니다.';
//               }
//               return null;
//             },
//             decoration: InputDecoration(
//               hintText: hintText,
//               border: const OutlineInputBorder(),
//             ),
//           )
//         else
//           TextFormField(
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return '필수 입력 항목입니다.';
//               }
//               return null;
//             },
//             decoration: InputDecoration(
//               hintText: hintText,
//               border: const OutlineInputBorder(),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class FAQList extends StatelessWidget {
//   const FAQList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 3.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FAQItem(
//               question: '자주 묻는 내용1',
//               answer:
//                   '회원가입 시 선택한 학교/캠퍼스는 가입 이후 변경할 수 없습니다. 다른 학교/캠퍼스로 변경을 원하실 경우, 현재 사용하시는 계정을 탈퇴하신 후 새로운 학교/캠퍼스로 다시 회원가입을 해주시기 바랍니다.',
//             ),
//             FAQItem(
//               question: '자주 묻는 내용2',
//               answer:
//                   '에브리타임은 대한민국 대학교 재학생 및 졸업생을 위한 서비스입니다. 대한민국 대학교의 재학생 및 졸업생이 아닐 경우, 이용이 불가능합니다.',
//             ),
//             FAQItem(
//               question: '자주 묻는 내용3',
//               answer: '',
//             ),
//             FAQItem(
//               question: '자주 묻는 내용4',
//               answer: '',
//             ),
//             FAQItem(
//               question: '자주 묻는 내용5',
//               answer: '',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FAQItem extends StatefulWidget {
//   final String question;
//   final String answer;

//   const FAQItem({
//     super.key,
//     required this.question,
//     required this.answer,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _FAQItemState createState() => _FAQItemState();
// }

// class _FAQItemState extends State<FAQItem> {
//   bool isExpanded = true;

//   @override
//   Widget build(BuildContext context) {
//     double containerWidth = MediaQuery.of(context).size.width - 32;
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.grey,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       margin: const EdgeInsets.only(bottom: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           InkWell(
//             onTap: () {
//               setState(() {
//                 isExpanded = !isExpanded;
//               });
//             },
//             child: Container(
//               width: containerWidth,
//               padding: const EdgeInsets.all(10),
//               child: Text(
//                 widget.question,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           if (isExpanded)
//             Container(
//               width: containerWidth,
//               padding: const EdgeInsets.all(20),
//               child: Text(widget.answer),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/main.dart';

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

  @override
  Widget build(BuildContext context) {
    ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 50, 160, 107)),
      useMaterial3: true,
    );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("문의하기"),
          backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        ),
        // bottomNavigationBar: const BottomNavBar(),
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
                    child: const Column(
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
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
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final bool isTextArea;
  final String hintText;

  const InputField({
    super.key,
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
