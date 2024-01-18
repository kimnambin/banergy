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
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                    ),
                    Column(
                      children: checkList2
                          .map<Widget>((String v) => Container(
                                margin: const EdgeInsets.all(20.0),
                                child: CheckboxListTile(
                                  onChanged: (bool? check) {
                                    setState(() {
                                      if (checkListValue2.contains(v)) {
                                        checkListValue2.remove(v);
                                        return;
                                      }
                                      checkListValue2.add(v);
                                    });
                                  },
                                  title: Text(v),
                                  value: checkListValue2.contains(v)
                                      ? true
                                      : false,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}
