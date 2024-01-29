import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';

void main() {
  runApp(const FilteringAllergies());
}

class FilteringAllergies extends StatelessWidget {
  const FilteringAllergies({super.key});

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
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? checkListValue1;
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
    // 왼쪽 필터 리스트와 오른쪽 필터 리스트를 나누기
    int halfLength = checkList2.length ~/ 2;
    List<String> leftFilterList = checkList2.sublist(0, halfLength);
    List<String> rightFilterList = checkList2.sublist(halfLength);

    return Scaffold(
      appBar: AppBar(
        title: const Text("알러지 필터링"),
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
            icon: const Icon(Icons.save),
            onPressed: () {
              print("저장된 값: $checkListValue1, $checkListValue2");
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                // 왼쪽 필터
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: buildFilterList(leftFilterList),
                  ),
                ),
                // 오른쪽 필터
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: buildFilterList(rightFilterList),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                if (checkListValue2.indexOf(filter) > -1) {
                  checkListValue2.remove(filter);
                  return;
                }
                checkListValue2.add(filter);
              });
            },
            title: Text(filter),
            value: checkListValue2.indexOf(filter) > -1 ? true : false,
          ),
        );
      },
    );
  }
}
