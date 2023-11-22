import 'package:flutter/material.dart';
import 'package:flutter_ex1/main.dart';
import '../mypage/mypage.dart';

void main() {
  runApp(MaterialApp(
    home: Delete(),
  ));
}

class Delete extends StatelessWidget {
  const Delete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원 탈퇴하기"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '탈퇴하기',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                InputField(label: '계정 비밀번호', hintText: '계정 비밀번호를 입력하세요'),
                SizedBox(height: 20),
                InputField(
                  label: '탈퇴 사유',
                  hintText: '간단한 탈퇴 사유를 적어주세요.',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // 다이얼로그를 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('회원 탈퇴 완료'),
                          content: Text('회원 탈퇴가 성공적으로 처리되었습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그를 닫음
                              },
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('회원탈퇴'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hintText;

  InputField({required this.label, this.hintText = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.adjust),
          label: 'Lens',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'My',
        ),
      ],
      onTap: (index) {
        // Handle navigation based on the tapped item index
        if (index == 0) {
          // Home icon is tapped, navigate to the main page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainpageApp()),
          );
        } else if (index == 2) {
          // My icon is tapped, navigate to the MypageApp
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MypageApp()),
          );
        }
      },
    );
  }
}
