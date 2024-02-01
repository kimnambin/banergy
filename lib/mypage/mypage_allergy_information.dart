import 'package:flutter/material.dart';
import '../mypage/mypage.dart';

void main() {
  runApp(const allergyinformation());
}

class allergyinformation extends StatelessWidget {
  const allergyinformation({super.key});

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
        title: const Text("나의 알레르기"),
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
      // body: _selectedIndex == 0
      body: Container(),
    );
  }
}

/*
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
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.adjust),
          label: "Lens",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'My',
        ),
      ],
      onTap: (index) {
        // Handle navigation based on the tapped item index
        if (index == 0) {
          // Home icon is tapped, restart the current page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainpageApp()),
          );
        } else if (index == 2) {
          // My icon is tapped, navigate to MypageApp
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MypageApp()),
          );
        }
      },
    );
  }
} */
