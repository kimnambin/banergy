import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mypage/mypage_ChangeNick.dart';
import 'package:flutter_banergy/mypage/mypage_Delete.dart';
import 'package:flutter_banergy/mypage/mypage_InquiryScreen.dart';
import 'package:flutter_banergy/mypage/mypage_addproductScreen.dart';
import 'package:flutter_banergy/mypage/mypage_allergy_information.dart';
import 'package:flutter_banergy/mypage/mypage_changeidpw.dart';
import 'package:flutter_banergy/mypage/mypage_filtering_allergies.dart';
import 'package:flutter_banergy/mypage/mypage_record_allergy_reactions.dart';

import '../../mypage/mypage_freeboard.dart';

// void main() {
//   runApp(const MypageApp());
// }

class MypageApp extends StatelessWidget {
  const MypageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 29, 171, 102)),
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

  set code(String? code) {}

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
              builder: (context) => const Recordallergyreactions()),
        );
        break;
      case "알러지 필터링":
        // 알러지 필터링 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FilteringAllergies()),
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
          MaterialPageRoute(builder: (context) => Delete()),
        );
        break;

      case "문의하기":
        // 문의하기 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InquiryScreen()),
        );

        break;
      case "상품추가":
        // 상품추가 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProductScreen()),
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
    // final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
    // String? code;
    return Scaffold(
      appBar: AppBar(
        title: const Text("마이페이지"),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainpageApp()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: _buildlist(),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildlist() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0), // 내부 여백 추가

        /*decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green, // 테두리 색상 설정
            width: 2.0, // 테두리 두께 설정
          ),
          borderRadius: BorderRadius.circular(12.0), // 테두리 모서리를 둥글게 만듦
        ),*/
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 나의 알러지
            _buildSectionTitle("나의 알러지", Icons.accessibility),

            _buildButton(
              "알러지 정보",
            ),
            const SizedBox(height: 20),
            _buildButton(
              "알러지 반응 기록",
            ),
            const SizedBox(height: 20),
            _buildButton("알러지 필터링"),
            const SizedBox(height: 20),
            Divider(
              color: Colors.grey[200],
              thickness: 2.0,
              //height: 0.05,
            ),
            // 설정
            _buildSectionTitle("설정", Icons.settings),
            _buildButton("닉네임 변경"),
            const SizedBox(height: 20),
            _buildButton("비밀번호 변경"),
            const SizedBox(height: 20),
            _buildButton("탈퇴하기"),
            const SizedBox(height: 20),
            Divider(
              color: Colors.grey[200],
              thickness: 2.0,
              //height: 10.0,
            ),
            // 추가 지원
            _buildSectionTitle("추가 지원", Icons.support),
            _buildButton("문의하기"),
            const SizedBox(height: 20),
            _buildButton("상품추가"),
            const SizedBox(height: 20),
            _buildButton("자유게시판"),
          ],
        ),
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
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String buttonText) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _navigateToPage(buttonText);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.infinity, 45),
            backgroundColor:
                const Color.fromARGB(255, 29, 171, 102), // 직접 지정한 색상 코드
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFEBEBEB)), // 테두리 색상
              borderRadius: BorderRadius.circular(30.0), // 테두리 둥글기
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              //color: Color.fromARGB(255, 29, 171, 102),
              color: Colors.white,
            ),
          ),
        ),
      );
}
