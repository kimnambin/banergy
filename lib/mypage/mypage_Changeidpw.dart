import 'package:flutter/material.dart';
import 'package:flutter_ex1/main.dart';
import '../mypage/mypage.dart';

void main() {
  runApp(MaterialApp(
    home: Changeidpw(),
  ));
}

class Changeidpw extends StatefulWidget {
  const Changeidpw({Key? key}) : super(key: key);

  @override
  _ChangeidpwState createState() => _ChangeidpwState();
}

class _ChangeidpwState extends State<Changeidpw>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(
        () => setState(() => _selectedIndex = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("비번 변경하기"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '비밀번호 변경하기',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  InputField(
                    title: '현재 비밀번호',
                    labels: ['', ''],
                    hintTexts: ['현재 비밀번호 입력', '현재 비밀번호 확인'],
                  ),
                  SizedBox(height: 20),
                  InputField(
                    title: '새 비밀번호',
                    labels: ['', ''],
                    hintTexts: ['새로운 비밀번호 입력', '새로운 비밀번호 확인'],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text('비밀번호가 성공적으로 변경되었습니다.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('비밀번호 변경'),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            tabs: [
              Tab(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainpageApp(),
                      ),
                    );
                  },
                  child: Icon(Icons.home),
                ),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.adjust),
                text: "Lens",
              ),
              Tab(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MypageApp(),
                      ),
                    );
                  },
                  child: Icon(Icons.person),
                ),
                text: "My",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String title;
  final List<String> labels;
  final List<String> hintTexts;

  InputField(
      {required this.title, required this.labels, required this.hintTexts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        for (int i = 0; i < labels.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Text(
                  labels[i],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: hintTexts[i],
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
