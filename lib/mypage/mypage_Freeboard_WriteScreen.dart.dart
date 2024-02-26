import 'package:flutter/material.dart';

class Freeboard_WriteScreen extends StatelessWidget {
  const Freeboard_WriteScreen({Key? key}) : super(key: key);

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
                const InputField(label: '제목 *'),
                const SizedBox(height: 20),
                const InputField(
                  label: '내용 *',
                  isTextArea: true,
                  hintText: "자유롭게 글을 작성해주세요.",
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // TODO: 글 작성 완료 후 처리
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text('작성이 완료되었습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                                Navigator.pop(context); // 글 쓰기 화면 닫기
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
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
      // TODO: BottomNavBar를 사용할지 여부에 따라 수정
      //bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final bool isTextArea;
  final String hintText;

  const InputField({
    required this.label,
    this.isTextArea = false,
    this.hintText = "",
    Key? key,
  }) : super(key: key);

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
          )
        else
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
      ],
    );
  }
}
