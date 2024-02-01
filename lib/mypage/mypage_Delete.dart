// ignore: file_names
import 'package:flutter/material.dart';
import '../mypage/mypage.dart';

void main() {
  runApp(const MaterialApp(
    home: Delete(),
  ));
}

class Delete extends StatelessWidget {
  const Delete({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 50, 160, 107)),
      useMaterial3: true,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원 탈퇴하기"),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MypageApp()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '탈퇴하기',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                const InputField(label: '계정 비밀번호', hintText: '계정 비밀번호를 입력하세요'),
                const SizedBox(height: 20),
                const InputField(
                  label: '탈퇴 사유',
                  hintText: '간단한 탈퇴 사유를 적어주세요.',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // 다이얼로그를 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('회원 탈퇴 완료'),
                          content: const Text('회원 탈퇴가 성공적으로 처리되었습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그를 닫음
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
                  child:
                      const Text('회원탈퇴', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hintText;

  const InputField({super.key, required this.label, this.hintText = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
/*
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
}*/
