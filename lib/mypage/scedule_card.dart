import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
//  final int memodate;
  final String content;

  const ScheduleCard({
//    required this.memodate,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          // 높이를 내부 위젯들의 최대 높이로 설정
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 시간 위젯
              //    _Time(
              //      memodate : memodate,
              //    ),
              const SizedBox(width: 16.0),

              // 일정 내용 위젯
              _Content(
                content: content,
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////
// 자식 위젯들 생성

// 시간을 표시할 위젯 생성
class _Time extends StatelessWidget {
  final int memodate; // 시작 시간

  const _Time({
    required this.memodate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
    );

    return Column(
      // 일정을 세로로 배치
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // 숫자가 한 자리면 0으로 채워기
          '${memodate.toString().padLeft(2, '0')}:00',
          style: textStyle,
        ),
      ],
    );
  }
}

// 내용을 표시할 위젯
class _Content extends StatelessWidget {
  final String content; // 내용

  const _Content({
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      // 최대한 넓게 늘리기
      child: Text(
        content,
      ),
    );
  }
}

class MemoCard extends StatelessWidget {
  final String content;

  const MemoCard({
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          // 높이를 내부 위젯들의 최대 높이로 설정
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(width: 16.0),

              // 일정 내용 위젯
              _Content(
                content: content,
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
