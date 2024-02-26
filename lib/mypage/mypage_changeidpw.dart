import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/mypage/mypage.dart';

void main() {
  runApp(const MaterialApp(
    home: Changeidpw(),
  ));
}

class Changeidpw extends StatefulWidget {
  const Changeidpw({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangeidpwState createState() => _ChangeidpwState();
}

class _ChangeidpwState extends State<Changeidpw>
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
    ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 29, 171, 102)),
      useMaterial3: false,
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("비번 변경하기"),
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
        bottomNavigationBar: const BottomNavBar(),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '비밀번호 변경하기',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const InputField(
                    title: '현재 비밀번호',
                    labels: ['', ''],
                    hintTexts: ['현재 비밀번호 입력', '현재 비밀번호 확인'],
                  ),
                  const SizedBox(height: 10),
                  const InputField(
                    title: '새 비밀번호',
                    labels: ['', ''],
                    hintTexts: ['새로운 비밀번호 입력', '새로운 비밀번호 확인'],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text('비밀번호가 성공적으로 변경되었습니다.'),
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
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                    ),
                    child: const Text('비밀번호 변경',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
        /* bottomNavigationBar: SizedBox(
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
        ),*/
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String title;
  final List<String> labels;
  final List<String> hintTexts;

  const InputField(
      {super.key,
      required this.title,
      required this.labels,
      required this.hintTexts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        for (int i = 0; i < labels.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labels[i],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: hintTexts[i],
                  border: const OutlineInputBorder(),
                  //contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
