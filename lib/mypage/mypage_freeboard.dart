import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';

void main() {
  runApp(const Freeboard());
}

class Freeboard extends StatelessWidget {
  const Freeboard({super.key});

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
          title: const Text("자유게시판"),
          backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '자유게시판',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Column(
                    children: [
                      InputField(
                        label: '제목 *',
                      ),
                      SizedBox(height: 20),
                      InputField(
                        label: '내용 *',
                        isTextArea: true,
                        hintText: "자유롭게 글을 작성해주세요.",
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text('작성이 완료되었습니다.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 다이얼로그 닫기
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
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
            maxLines: 10,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          )
        else
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
      ],
    );
  }
}
