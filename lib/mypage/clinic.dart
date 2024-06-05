import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({super.key});

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  List<String> selectedChoices = [];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),

        // 아이콘과 텍스트 사이의 간격 조절을 위한 SizedBox 추가
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Text('방문한 병원'),
            const SizedBox(height: 8),
            const TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '입력하기',
            )),
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
            const TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '진료/검사/시술/',
            )),
            const SizedBox(height: 8),
            const Text('전체 진료 내역은 [리포트]에서 한눈에 확인할 수 있어요. 진료받을 때 참고하시면 편해요 :)'),
            SizedBox(
              width: MediaQuery.of(context).size.width -
                  32, // 버튼의 가로 길이를 화면 전체로 설정
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 70, 138, 71),
                  ),
                  child: const Text(
                    '저장하기',
                    style: TextStyle(
                      color: Colors.white, // 텍스트 색상을 하얀색으로 변경
                      fontWeight: FontWeight.bold, // 텍스트 굵게
                    ),
                  ),
                  onPressed: () {
                    if (kDebugMode) {
                      print(selectedChoices);
                    }
                    Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectDate, DateTime focusedDate) {
    setState(() {
      selectedDate = selectDate;
    });
  }
}
