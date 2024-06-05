// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/main_calendar.dart';

//임시 이름
class byeongseung_HomeScreen extends StatefulWidget {
  const byeongseung_HomeScreen({super.key});

  @override
  State<byeongseung_HomeScreen> createState() => _byeongseung_HomeScreenState();
}

class _byeongseung_HomeScreenState extends State<byeongseung_HomeScreen> {
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
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double screenWidth = MediaQuery.of(context).size.width;
                double paddingValue =
                    screenWidth * 0.05; // 화면 너비의 x%를 패딩 값으로 설정
                double maxPadding = 10.0 + screenWidth; // 최대 패딩 값
                double minPadding = 27.0; // 최소 패딩 값
                // 패딩 값을 최대값과 최소값 사이로 보정
                paddingValue = paddingValue.clamp(minPadding, maxPadding);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("일",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                              color: Colors.red)),
                      Text("월",
                          style: TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 13)),
                      Text("화",
                          style: TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 13)),
                      Text("수",
                          style: TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 13)),
                      Text("목",
                          style: TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 13)),
                      Text("금",
                          style: TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 13)),
                      Text("토",
                          style: TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 13)),
                    ],
                  ),
                );
              },
            ),
            const MainCalendar(),
            const SizedBox(height: 8),
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
