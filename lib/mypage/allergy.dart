import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/clinic.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const Recordallergyreactions());
}

class Recordallergyreactions extends StatelessWidget {
  const Recordallergyreactions({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClinicScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const WeekCalendar(),
            const Text('안녕하세요? OO님'),
            const SizedBox(height: 8),
            const Text('알레르기 반응이 있었나요?'),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('몸 상태의 반응 등 기록을 꼭 추가해주세요'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClinicScreen()),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClinicScreen()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 183, 183, 183)),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ClinicScreen()),
                        );
                      },
                      iconSize: 32, // 아이콘 크기 지정
                    ),
                  ),
                  const SizedBox(width: 8), // 간격 추가
                  const Text(
                    '기록 추가하기',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '메모를 자유롭게 남겨보세요!',
              ),
            ),
            const SizedBox(height: 8),
            const Text('병원진료'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClinicScreen()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 183, 183, 183)),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ClinicScreen()),
                        );
                      },
                      iconSize: 32, // 아이콘 크기 지정
                    ),
                  ),
                  const SizedBox(width: 8), // 간격 추가
                  const Text(
                    '기록 추가하기',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekCalendar extends StatefulWidget {
  const WeekCalendar({Key? key}) : super(key: key);

  @override
  _WeekCalendarState createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              DateFormat('dd', 'ko_KR').format(day),
              style: const TextStyle(),
            ),
          );
        },
      ),
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2025, 1, 1),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      headerStyle: const HeaderStyle(
        titleCentered: false,
        formatButtonVisible: false,
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
