import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<String> selectedChoices1 = [];
  List<String> selectedChoices2 = [];

  List<String> choices1 = [
    '계란',
    '새우',
    '밀',
    '메밀',
    '대두',
    '땅콩',
    '고등어',
    '돼지고기',
    '복숭아',
    '토마토',
    '호두',
    '잣',
    '닭고기',
    '소고기',
    '오징어',
    '조개류',
    '홍합',
    '전복',
    '굴',
    '아황산',
    '우유',
    '게',
    '아몬드',
    '약물 등 기타'
  ];
  List<String> choices2 = [
    '먹고난 직후 ~ 수 분',
    '수 시간 후',
    '하루~이틀',
    '몇 주',
  ];

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _situationController = TextEditingController();

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    // 저장된 데이터 불러오기
    setState(() {
      selectedChoices1 = prefs.getStringList('selectedChoices1') ?? [];
      selectedChoices2 = prefs.getStringList('selectedChoices2') ?? [];
      _locationController.text = prefs.getString('location') ?? '';
      _situationController.text = prefs.getString('situation') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // 선택한 데이터 저장
    await prefs.setStringList('selectedChoices1', selectedChoices1);
    await prefs.setStringList('selectedChoices2', selectedChoices2);
    await prefs.setString('location', _locationController.text);
    await prefs.setString('situation', _situationController.text);

    if (kDebugMode) {
      print("Data saved successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeDateFormatting('ko_KR', null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const Text('당시 먹은 음식 성분'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: choices1.map((String choice) {
                      return FilterChip(
                        label: Text(choice),
                        selected: selectedChoices1.contains(choice),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedChoices1.add(choice);
                            } else {
                              selectedChoices1.remove(choice);
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide.none,
                        ),
                        backgroundColor: Colors.grey.shade300,
                        checkmarkColor: const Color.fromARGB(255, 13, 212, 63),
                        selectedColor: Colors.grey.shade300,
                        showCheckmark: true,
                        labelStyle: const TextStyle(color: Colors.black),
                      );
                    }).toList(),
                  ),
                  const Text('방문한 장소'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: '입력하기',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('나타난 시기'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: choices2.map((String choice) {
                      return FilterChip(
                        label: Text(choice),
                        selected: selectedChoices2.contains(choice),
                        onSelected: (bool selected) {
                          setState(() {
                            selectedChoices2.clear();
                            if (selected) {
                              selectedChoices2.add(choice);
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide.none,
                        ),
                        backgroundColor: Colors.grey.shade300,
                        checkmarkColor: const Color.fromARGB(255, 13, 212, 63),
                        selectedColor: Colors.grey.shade300,
                        showCheckmark: true,
                        labelStyle: const TextStyle(color: Colors.black),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  const Text('당시 상황'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _situationController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: '입력하기',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '전체 내역은 [리포트]에서 한눈에 확인할 수 있어요. 진료받을 때 참고하시면 편해요 :)',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 38, 159, 115),
                      ),
                      child: const Text(
                        '저장하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        await _saveData(); // 데이터 저장
                        if (kDebugMode) {
                          print(selectedChoices1);
                          print(selectedChoices2);
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void onDaySelected(DateTime selectDate, DateTime focusedDate) {
    setState(() {
      selectedDate = selectDate;
    });
  }
}
