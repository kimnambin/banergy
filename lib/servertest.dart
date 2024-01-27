//플러터 + 플라스크 연동해보기
// 임포트 -->> 서버 가져올 변수 지정 -->> 서버에 요청 -->> 결과 출력

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 1단계

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

//2단계 -->> 변수들 지정 (메시지 : 헬로우 월드 / 유저 : 남빈)
class _MyAppState extends State<MyApp> {
  String serverMessage = '';
  String serverUser = '';

  @override
  void initState() {
    super.initState();
    // 3단계 -> 앱이 처음 시작될 때 서버에 요청 보내기
    fetchServerData();
  }

  Future<void> fetchServerData() async {
    //플라스크 서버 주소
    const String serverUrl = 'http://127.0.0.1:5000/';

    try {
      // GET 요청
      final response = await http.get(Uri.parse(serverUrl));

      // 응답 처리
      if (response.statusCode == 200) {
        // JSON 데이터 가져오기
        Map<String, dynamic> data = json.decode(response.body);

        // 서버 응답을 변수에 저장
        setState(() {
          serverMessage = data['message']; //헬로우 월드
          serverUser = data['user']; //남빈
        });
      } else {
        // 오류 처리
        setState(() {
          serverMessage = '서버 응답 오류: ${response.statusCode}';
          serverUser = ''; // 오류 발생 시 user를 비우거나 다른 값으로 초기화
        });
      }
    } catch (e) {
      // 에러 처리
      setState(() {
        serverMessage = '에러: $e';
        serverUser = ''; // 에러 발생 시 user를 비우거나 다른 값으로 초기화
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('플러터 파이썬 연동해보기'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 서버에서 가져온 데이터
              Text(
                '메시지: $serverMessage',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              Text(
                '사용자: $serverUser',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
