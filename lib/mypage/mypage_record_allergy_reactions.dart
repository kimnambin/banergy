import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import '../mypage/mypage.dart';

void main() {
  runApp(const recordallergyreactions());
}

// ignore: camel_case_types
class recordallergyreactions extends StatelessWidget {
  const recordallergyreactions({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 50, 160, 107)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
      ),
      body: Container(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
/*
      bottomNavigationBar: SizedBox(
        height: 80,
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          tabs: [
            Tab(
              icon: GestureDetector(
                onTap: () {
                  // home 아이콘이 눌렸을 때 main.dart 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainpageApp()),
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
                  // home 아이콘이 눌렸을 때 main.dart 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MypageApp()),
                  );
                },
                child: Icon(Icons.person),
              ),
              text: "My",
            ),
          ],
        ),
      ),
    );
  }
}*/
