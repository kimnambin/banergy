import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({super.key});

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  List<String> selectedChoices = [];
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();

  List<String> choices = [
    '두드러기',
    '입술, 입 주변 부종',
    '오심',
    '복통',
    '오한',
    '콧물',
    '구토',
    '설사',
    '눈물',
    '눈 가려움',
    '목 가려움',
    '기타'
  ];

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // 앱 실행 시 저장된 데이터를 불러옴
  }

  // 데이터 로드
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    // 저장된 데이터 불러오기
    setState(() {
      selectedChoices = prefs.getStringList('selectedChoices') ?? [];
      _hospitalController.text = prefs.getString('hospital') ?? '';
      _diagnosisController.text = prefs.getString('diagnosis') ?? '';
    });
  }

  // 데이터 저장
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // 선택한 데이터 저장
    await prefs.setStringList('selectedChoices', selectedChoices);
    await prefs.setString('hospital', _hospitalController.text);
    await prefs.setString('diagnosis', _diagnosisController.text);

    if (kDebugMode) {
      print("Data saved successfully");
    }
  }

  // _onSubmitted 함수 추가
  Future<void> _onSubmitted() async {
    await _saveData(); // 입력된 데이터 저장

    if (kDebugMode) {
      print(selectedChoices);
      print(_hospitalController.text);
      print(_diagnosisController.text);
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
                  const Text('방문한 병원'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _hospitalController, // 병원 입력 컨트롤러 추가
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '입력하기',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('방문한 이유'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: choices.map((String choice) {
                      return FilterChip(
                        label: Text(choice),
                        selected: selectedChoices.contains(choice),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedChoices.add(choice);
                            } else {
                              selectedChoices.remove(choice);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  const Text('진료 내용'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _diagnosisController, // 진료 내용 입력 컨트롤러 추가
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '진료/검사/시술/',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '전체 진료 내역은 [리포트]에서 한눈에 확인할 수 있어요. 진료받을 때 참고하시면 편해요 :)',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 70, 138, 71),
                      ),
                      child: const Text(
                        '저장하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        await _onSubmitted(); // 데이터 저장
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
