import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mypage/allergy.dart';
import 'package:flutter_banergy/mypage/mypage_Delete.dart';
import 'package:flutter_banergy/mypage/mypage_InquiryScreen.dart';
import 'package:flutter_banergy/mypage/mypage_addproductScreen.dart';
import 'package:flutter_banergy/mypage/mypage_allergy_information.dart';
import 'package:flutter_banergy/mypage/mypage_changeidpw.dart';
import 'package:flutter_banergy/mypage/mypage_filtering_allergies.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../mypage/mypage_freeboard.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MypageApp extends StatelessWidget {
  const MypageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
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
  String? authToken;
  String? loginName;
  set code(String? code) {}
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _checkLoginStatus() async {
    final token = await _loginUser();
    if (token != null) {
      final isValid = await _validateToken(token);
      if (isValid) {
        final userName = await _fetchUserName(token);
        setState(() {
          if (kDebugMode) {
            print('로그인한 유저네임 : $loginName');
          }
          authToken = token;
          loginName = userName;
        });
      } else {
        setState(() {
          authToken = null;
        });
      }
    }
  }

  Future<String?> _fetchUserName(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final username = responseData['name'];
        if (username != null) {
          return username;
        } else {
          debugPrint('Username is null in response');
          return null;
        }
      } else {
        debugPrint('Failed to fetch user name: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
      return null;
    }
  }

  Future<String?> _loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    return token;
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error validating token: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToPage(String pageName) {
    // 페이지 이름에 따라 다른 동작 수행
    switch (pageName) {
      case "알러지 필터링":
        // 알러지 필터링 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FilteringAllergies()),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "마이페이지",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF1F2F7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainpageApp()),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFF1F2F7),

      body: SingleChildScrollView(
        child: _buildList(),
      ),
      //bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildList() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFEFFFE),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: _buildSectionTitle(
                '$loginName',

                //"이예원",
                Icons.account_circle,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFFFEFFFE),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '몸 상태와 반응등 증상을 꼭 얘기해주세요.',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: -0.5,
                      height: 4.5,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton2(Icons.add),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const allergyinformation(),
                              ),
                            );
                          },
                          child: const Text(
                            '병원진료',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        _buildButton3(Icons.add),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Recordallergyreactions(),
                              ),
                            );
                          },
                          child: const Text(
                            '알레르기 반응',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildButton("알러지 필터링", Icons.arrow_forward_ios),
            const SizedBox(height: 10),
            _buildSectionTitle2("설정"),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFEFFFE),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                children: [
                  // _buildButton("닉네임 변경", Icons.arrow_forward_ios),
                  _buildButton("비밀번호 변경", Icons.arrow_forward_ios),
                  _buildButton("탈퇴하기", Icons.arrow_forward_ios),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle2("추가 지원"),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFEFFFE),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                children: [
                  _buildButton("문의하기", Icons.arrow_forward_ios),
                  _buildButton("상품추가", Icons.arrow_forward_ios),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//타이틀과 아이콘 부분들 스타일
  Widget _buildSectionTitle(String title, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 45),
            Icon(
              iconData,
              color: const Color(0xFF777777),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //타이틀 (아이콘 없는 버전)
  Widget _buildSectionTitle2(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 45),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

//버튼 스타일
  Widget _buildButton(String buttonText, IconData iconData) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _navigateToPage(buttonText);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFEFFFE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            fixedSize: const Size(double.infinity, 60),
            elevation: 0, // 그림자 제거
            padding: EdgeInsets.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  iconData,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      );

//알레르기 반응 버튼
  Widget _buildButton3(IconData iconData) => SizedBox(
        width: 30, // 버튼의 너비 설정
        height: 30, // 버튼의 높이 설정
        child: ElevatedButton(
          onPressed: () async {
            await initializeDateFormatting('ko_KR', null);
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Recordallergyreactions()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: const Color(0xFF03C95B),
            padding: EdgeInsets.zero,
          ),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      );
  //병원 진료 버튼
  Widget _buildButton2(IconData iconData) => SizedBox(
        width: 30, // 버튼의 너비 설정
        height: 30, // 버튼의 높이 설정
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const allergyinformation()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: const Color(0xFF03C95B),
            padding: EdgeInsets.zero,
          ),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      );
}
