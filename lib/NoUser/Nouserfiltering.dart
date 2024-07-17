// 비회원 필터링 테스트

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_banergy/NoUser/NouserMain.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Nouserfiltering());
}

class Nouserfiltering extends StatelessWidget {
  const Nouserfiltering({super.key});

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
  List<String?> checkListValue2 = [];
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

  String searchText = ''; //검색 부분 초기화

  Future<void> _userFiltering(
      BuildContext context, List<String?> checkListValue2) async {
    final String allergies = jsonEncode(checkListValue2);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl:8000/nouser/ftr'),
        body: jsonEncode({'allergies': allergies}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
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
                          builder: (context) => const NoUserMainpageApp(),
                        ));
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
      print('Error sending request: $e');
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
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FirstApp(),
                ),
              );
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
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
              const Text(
                "해당하는 알레르기를 체크해주세요",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PretendardSemiBold',
                ),
              ),
              //여기가 검색부분
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: const TextStyle(
                    fontFamily: 'PretendardBold',
                  ),
                  decoration: const InputDecoration(
                    hintText: '알레르기를 검색해보세요!!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    contentPadding: EdgeInsets.only(left: 30, bottom: 13),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.white,
                  child: buildFilterList(checkList2),
                ),
              ),
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
                    print("저장된 값: $checkListValue2")
                  },
                  child: const Text(
                    '적용',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'PretendardSemiBold'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildFilterList(List<String> filterList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: (filterList.length + 1) ~/ 2,
      itemBuilder: (context, index) {
        int start = index * 2;
        int end =
            (start + 2) < filterList.length ? start + 2 : filterList.length;
        List<String> rowFilters = filterList.sublist(start, end);

        return Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              for (String filter in rowFilters)
                if (searchText.isEmpty ||
                    filter.toLowerCase().contains(searchText.toLowerCase()))
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
