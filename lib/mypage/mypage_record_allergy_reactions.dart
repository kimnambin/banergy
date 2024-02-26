import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import '../mypage/mypage.dart';

void main() {
  runApp(const Recordallergyreactions());
}

class Recordallergyreactions extends StatelessWidget {
  const Recordallergyreactions({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 50, 160, 107),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
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
        title: const Text("알러지 반응 기록"),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // 달력 아이콘을 눌렀을 때의 동작 추가
              // 예를 들어 달력 팝업을 표시하거나 원하는 기능을 수행
            },
          ),
        ],
      ),
      // body: _selectedIndex == 0
      body: Container(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
