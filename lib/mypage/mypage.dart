import 'package:flutter/material.dart';
import 'package:flutter_ex1/main.dart';
import 'package:flutter_ex1/mypage/mypage_ChangeNick.dart';
import 'package:flutter_ex1/mypage/mypage_Changeidpw.dart';
import 'package:flutter_ex1/mypage/mypage_Delete.dart';
import 'package:flutter_ex1/mypage/mypage_InquiryScreen.dart';
import 'package:flutter_ex1/mypage/mypage_addProductScreen.dart';
import '../mypage/mypage.dart';
import '../mypage/mypage_allergy_information.dart';
import '../mypage/mypage_record_allergy_reactions.dart';
import '../mypage/mypage_filtering_allergies.dart';
import '../mypage/mypage_addProductScreen.dart';
import '../mypage/mypage_freeboard.dart';

void main() {
  runApp(const MypageApp());
}

class MypageApp extends StatelessWidget {
  const MypageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 29, 171, 102)),
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

  void _navigateToPage(String pageName) {
    // 페이지 이름에 따라 다른 동작 수행
    switch (pageName) {
      case "알러지 정보":
        // 알러지 정보 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const allergyinformation()),
        );
        break;
      case "알러지 반응 기록":
        // 알러지 반응 기록 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const recordallergyreactions()),
        );
        break;
      case "알러지 필터링":
        // 알러지 필터링 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FilteringAllergies()),
        );
        break;
      case "닉네임 변경":
        // 닉네임 변경 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangeNick()),
        );
        break;
      case "비밀번호 변경":
        // 비밀번호 변경 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Changeidpw()),
        );
        break;
      case "탈퇴하기":
        // 탈퇴하기 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Delete()),
        );
        break;

      case "문의하기":
        // 문의하기 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InquiryScreen()),
        );

        break;
      case "상품추가":
        // 상품추가 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProductScreen()),
        );
        break;

      case "자유게시판":
        // 자유게시판 페이지으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Freeboard()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("마이페이지"),
      ),
      body: SingleChildScrollView(
        child: _buildlist(),
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

  Widget _buildlist() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 나의 알러지
          _buildSectionTitle("나의 알러지", Icons.accessibility),
          _buildButton("알러지 정보"),
          _buildButton("알러지 반응 기록"),
          _buildButton("알러지 필터링"),
          // 설정
          _buildSectionTitle("설정", Icons.settings),
          _buildButton("닉네임 변경"),
          _buildButton("비밀번호 변경"),
          _buildButton("탈퇴하기"),
          // 추가 지원
          _buildSectionTitle("추가 지원", Icons.support),
          _buildButton("문의하기"),
          _buildButton("상품추가"),
          _buildButton("자유게시판"),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String buttonText) => Container(
        width: double.infinity, // Set a fixed width, you can adjust this value
        child: ElevatedButton(
          onPressed: () {
            _navigateToPage(buttonText);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          child: Text(buttonText),
        ),
      );
}
