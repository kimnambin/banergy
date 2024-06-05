import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class MainCalendar extends StatefulWidget {
  const MainCalendar({super.key});
  // final OnDaySelected onDaySelected;
  // final DateTime selectedDate;

  // MainCalendar({
  //   required this.onDaySelected,
  //   required this.selectedDate,
  // });

  @override
  State<MainCalendar> createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  DateTime selectDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      //한국어
      locale: 'ko_KR',
      onDaySelected: (DateTime selectDay, DateTime focusedDay) {
        setState(() {
          this.selectDay = selectDay;
          this.focusedDay = focusedDay;
          String dayOfWeek = DateFormat.E('ko_KR').format(selectDay);
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: Colors.white,
            enableDrag: true, //sheet를 드래그 작용을 enable함.
            isScrollControlled: true, // sheet 내에서 스크롤을 가능하게함.
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ), //sheet의 외각을 정의할 수 있음. 여기에서는 위쪽의 양옆음 둥글게 함.
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.only(),
                height: 390,
                color: Colors.transparent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft, // 우측 정렬
                        child: Text(
                          '   ${selectDay.month}월 ${selectDay.day}일 (${dayOfWeek})',
                          style: TextStyle(
                            fontSize: 18, // 텍스트 크기를 키움
                            fontWeight: FontWeight.bold, // 텍스트 굵게
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 56),
                      Align(
                        alignment: Alignment.centerLeft, // 우측 정렬
                        child: ListTile(
                          leading: Icon(
                            Icons.circle,
                            color: Colors.grey,
                            size: 15,
                          ),
                          title: Text('메모'),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft, // 우측 정렬
                        child: ListTile(
                          leading: Icon(
                            Icons.circle,
                            color: Colors.grey,
                            size: 15,
                          ),
                          title: Text('병원진료'),
                        ),
                      ),
                      SizedBox(height: 100),
                      SizedBox(
                        width: MediaQuery.of(context).size.width -
                            32, // 버튼의 가로 길이를 화면 전체로 설정
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 70, 138, 71),
                          ),
                          child: const Text(
                            '기록 수정하러 가기',
                            style: TextStyle(
                              color: Colors.white, // 텍스트 색상을 하얀색으로 변경
                              fontWeight: FontWeight.bold, // 텍스트 굵게
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
      },
      selectedDayPredicate: (DateTime day) {
        // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
        return isSameDay(selectDay, day);
      },
/*      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day, */
      firstDay: DateTime(2024, 1, 1),
      lastDay: DateTime(2025, 12, 31),
      focusedDay: focusedDay,
      headerStyle: HeaderStyle(
          titleCentered: false,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          )),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 0), // 요일 텍스트 크기를 0으로 설정
        weekendStyle: TextStyle(fontSize: 0), // 주말 텍스트 크기를 0으로 설정
      ),
      headerVisible: true,
      // 날짜 형식 지정
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        selectedDecoration:
            BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        outsideDaysVisible: false,
      ),
    );
  }
}
