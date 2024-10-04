import 'package:flutter_banergy/mypage/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// private값까지 불러올 수 있음
part 'drift_database.g.dart'; // part 파일 지정

// 사용할 테이블 등록
@DriftDatabase(
  tables: [
    Schedules,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // 17.2.3 쿼리 구현하기
  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date)))
          .watch(); // 데이터를 조회하고 변화를 감지

  // insert문
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  // delete문
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // 데이터베이스 파일 저장할 폴더
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
