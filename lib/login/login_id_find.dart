import 'package:flutter/material.dart';
//import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:flutter_banergy/login/widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 서버 연동을 위함
  runApp(
    const MaterialApp(
      home: IDFindApp(),
    ),
  );
}

class IDFindApp extends StatelessWidget {
  const IDFindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 29, 171, 102)),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/000.jpeg',
                        width: 80,
                        height: 80,
                      ),
                      const Text(
                        '아이디 찾기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '계정 이름',
                          style: TextStyle(
                            fontSize: 16, // 원하는 폰트 크기 설정
                            fontWeight: FontWeight.bold, // 글자를 볼드로 설정
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          BanergyInputField(
                            label: '',
                            hintText: '이름',
                            iconColor: Colors.grey,
                            hintTextColor: Colors.grey,
                            icon: Icons.account_circle,
                            borderRadius: BorderRadius.circular(12.0),
                            controller: TextEditingController(),
                          ),
                          const SizedBox(height: 35),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '계정 비밀번호',
                              style: TextStyle(
                                fontSize: 16, // 원하는 폰트 크기 설정
                                fontWeight: FontWeight.bold, // 글자를 볼드로 설정
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          BanergyInputField(
                            label: '',
                            hintText: '비밀번호를 입력해주세요.',
                            iconColor: Colors.grey,
                            hintTextColor: Colors.grey,
                            icon: Icons.lock_open,
                            borderRadius: BorderRadius.circular(12.0),
                            controller: TextEditingController(),
                          ),
                          const SizedBox(height: 35),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '생년월일',
                              style: TextStyle(
                                fontSize: 16, // 원하는 폰트 크기 설정
                                fontWeight: FontWeight.bold, // 글자를 볼드로 설정
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DatePickerButton(
                            label: '',
                            hintText: '생년월일',
                            iconColor: Colors.grey,
                            hintTextColor: Colors.grey,
                            icon: Icons.calendar_today,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content:
                                        const Text('회원님의 아이디는 _______입니다.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // 다이얼로그 닫기

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginApp(),
                                            ),
                                          );
                                        },
                                        child: const Text('확인'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 29, 171, 102),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: Text('완료'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
