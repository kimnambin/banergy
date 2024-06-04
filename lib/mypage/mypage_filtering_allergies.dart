// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(FilteringAllergies());
}

// ignore: must_be_immutable
class FilteringAllergies extends StatelessWidget {
  FilteringAllergies({super.key});
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FilteringPage(),
    );
  }
}

class FilteringPage extends StatefulWidget {
  const FilteringPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilteringPageState createState() => _FilteringPageState();
}

class _FilteringPageState extends State<FilteringPage> {
  List<String?> checkListValue2 = []; //이게 사용자가 실시간으로 선택하는 거
  List<String> userAllergies = []; //이게 저장된 거 불러오는 것
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  List<String> checkList2 = [
    "계란",
    "밀",
    "대두",
    "우유",
    "게",
    "새우",
    "돼지고기",
    "닭고기",
    "소고기",
    "고등어",
    "복숭아",
    "토마토",
    "호두",
    "잣",
    "땅콩",
    "아몬드",
    "조개류",
    "기타"
  ];

  String? authToken;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _loginuser();
    if (token != null) {
      // 저장된 토큰이 있는 경우, 유효한지 확인
      final isValid = await _validateToken(token);
      if (isValid) {
        // 토큰이 유효한 경우, 로그인 상태로 설정
        setState(() {
          authToken = token;
        });
      } else {
        // 토큰이 유효하지 않은 경우, 로그인 상태 해제
        setState(() {
          authToken = null;
        });
      }
    }
  }

//로그인한 유저 가져오기
  Future<String?> _loginuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    return token;
  }

  Future<bool> _validateToken(token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:3000/loginuser'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      //저장된 알레르기 정보 가져오기
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          userAllergies = List<String>.from(data['allergies'] ?? []);
        });
        return true;
      } else {
        throw Exception('Failed to fetch user allergies');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user allergies: $e');
      }
      return false;
    }
  }

  Future<void> _userFiltering(
      BuildContext context, List<String?> checkListValue2) async {
    final String allergies = jsonEncode(checkListValue2);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:3000/allergies'),
        body: jsonEncode({'allergies': allergies}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('적용완료!!'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MypageApp(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('다시 확인해주세요.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('확인'),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending request: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "알러지 필터링",
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
      body: Column(
        children: [
          // Image 추가
          Container(
            color: Colors.white,
            child: Image.asset(
              'images/000.jpeg',
              width: 80,
              height: 80,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            userAllergies.isNotEmpty
                ? userAllergies.join(", ")
                : "해당하는 알레르기를 체크해주세요",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          // 중앙에 정렬된 필터 영역
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.white,
              child: Row(
                children: [
                  // 왼쪽 필터
                  Expanded(
                    child: buildFilterList(checkList2),
                  ),
                ],
              ),
            ),
          ),
          // 적용 버튼 추가
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF03C95B),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () => {
                _userFiltering(context, checkListValue2),
                // ignore: avoid_print
                print("저장된 값: $checkListValue2")
              },
              child: const Text(
                '적용',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 체크박스 리스트를 생성하는 함수
  Widget buildFilterList(List<String> filterList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: filterList.length,
      itemBuilder: (context, index) {
        String filter = filterList[index];
        return Container(
          margin: const EdgeInsets.all(10.0),
          child: CheckboxListTile(
            onChanged: (bool? check) {
              setState(() {
                if (checkListValue2.contains(filter)) {
                  checkListValue2.remove(filter);
                  return;
                }
                checkListValue2.add(filter);
              });
            },
            title: Text(filter),
            value: checkListValue2.contains(filter) ? true : false,
          ),
        );
      },
    );
  }
}
