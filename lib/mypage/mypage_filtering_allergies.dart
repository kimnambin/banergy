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
                // 적용 버튼을 눌렀을 때 수행할 동작
                print("저장된 값: $checkListValue2");
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
