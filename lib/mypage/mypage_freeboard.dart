import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/mypage/mypage_Freeboard_WriteScreen.dart.dart';

void main() {
  runApp(const Freeboard());
}

class Freeboard extends StatelessWidget {
  const Freeboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("자유게시판 목록"),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '자유게시판 글 목록',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // 여기에 실제 글 목록을 보여주는 위젯을 추가할 수 있습니다.
                // 예를 들어, ListView.builder 등을 사용하여 글 목록을 동적으로 생성할 수 있습니다.
                // 글 목록을 터치하면 해당 글의 상세 내용을 보여주는 화면으로 이동하도록 할 예정입니다.
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Freeboard_WriteScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
      ),
    );
  }
}
