import 'package:drift/drift.dart';

// Schedules 테이블 생성
class Schedules extends Table {
  IntColumn get id => integer().autoIncrement()(); // PRIMARY KEY, 정수 열
  TextColumn get content => text()(); // 내용, 글자 열
  DateTimeColumn get date => dateTime()(); // 일정 날짜, 날짜 열
}
