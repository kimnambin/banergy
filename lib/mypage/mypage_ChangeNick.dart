// ignore: file_names
import 'package:flutter/material.dart';
import '../mypage/mypage.dart';

void main() {
  runApp(const MaterialApp(
    home: ChangeNick(),
  ));
}

class ChangeNick extends StatefulWidget {
  const ChangeNick({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangeNickState createState() => _ChangeNickState();
}

class _ChangeNickState extends State<ChangeNick>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "닉네임 변경하기",
          textAlign: TextAlign.center,
        ),
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
      //bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const InputField(
                  label: '기존 아이디',
                  //controller: _usernameController,
                ),
                const SizedBox(height: 20),
                const InputField(
                  label: '새 아이디',
                  //controller: _passwordController,
                ),
                const SizedBox(height: 95),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text('닉네임이 성공적으로 변경되었습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF03C95B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text('완료'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      //bottomNavigationBar: BottomNavBar(),
    );
  }
}

class InputField extends StatelessWidget {
  //final TextEditingController controller;
  final String label;

  const InputField({
    required this.label,
    //required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        TextFormField(
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(227, 227, 227, 1.0)),
            ),
          ),
          //controller: controller,
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
