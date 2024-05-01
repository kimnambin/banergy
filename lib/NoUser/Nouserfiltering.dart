// 비회원 필터링 테스트

import 'package:flutter/material.dart';
import 'package:flutter_banergy/NoUser/NouserMain.dart';
// import 'package:flutter_banergy/bottombar.dart';
// import 'package:flutter_banergy/mypage/mypage.dart';

void main() {
  runApp(const Nouserfiltering());
}

class Nouserfiltering extends StatelessWidget {
  const Nouserfiltering({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String?> checkListValue2 = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("알러지 필터링"),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const MypageApp()),
        //     );
        //   },
        // ),
      ),
      //bottomNavigationBar: const BottomNavBar(),
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
          const Text(
            "해당하는 알레르기를 체크해주세요",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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
                primary: const Color.fromARGB(255, 29, 171, 102),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                print("저장된 값: $checkListValue2");
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('필터링이 적용되었습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NoUserMainpageApp(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 29, 171, 102),
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
