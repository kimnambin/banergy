// 마이페이지의 일정 달력 화면입니다.

import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/main_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double screenWidth = MediaQuery.of(context).size.width;
                final double paddingValue =
                    (screenWidth * 0.05).clamp(27.0, 10.0 + screenWidth);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '일',
                        style: TextStyle(fontSize: 13, color: Colors.red),
                      ),
                      Text('월', style: TextStyle(fontSize: 13)),
                      Text('화', style: TextStyle(fontSize: 13)),
                      Text('수', style: TextStyle(fontSize: 13)),
                      Text('목', style: TextStyle(fontSize: 13)),
                      Text('금', style: TextStyle(fontSize: 13)),
                      Text('토', style: TextStyle(fontSize: 13)),
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
}
