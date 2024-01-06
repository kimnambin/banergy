import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/login/login_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //서버 연동을 위함
  runApp(
    MaterialApp(
      home: joinApp(),
    ),
  );
}

class joinApp extends StatelessWidget {
  joinApp({super.key});

  @override
  Widget build(BuildContext context) {
    theme:
    ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 29, 171, 102)),
      useMaterial3: true,
    );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              //컨테이너 안에 들어가게 구현
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green, // 테두리 색
                    width: 2.0, // 테두리 두께
                  ),
                  borderRadius: BorderRadius.circular(12.0), // 테두리 모서리를 둥글
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),

                    Image.asset(
                      'images/000.jpeg',
                      width: 100,
                      height: 100,
                    ),
                    Text('밴러지'),
                    SizedBox(height: 20),
                    Text(
                      '밴러지 회원가입하기',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    InputField(
                      label: '',
                      hintText: '아이디를 입력해주세요.',
                      icon: Icons.account_box,
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    SizedBox(height: 20), //간격 벌리기 용
                    InputField(
                      label: '',
                      hintText: '비밀번호를 입력해주세요.',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.person,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    SizedBox(height: 20),
                    InputField(
                      label: '',
                      hintText: '비밀번호 재확인',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.person,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    SizedBox(height: 20),
                    InputField(
                      label: '',
                      hintText: '이름',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.account_circle,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    SizedBox(height: 20),
                    InputField(
                      label: '',
                      hintText: '생년월일',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.person,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    SizedBox(height: 20),
                    InputField(
                      label: '',
                      hintText: '성별',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.person,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text('밴러지 회원가입완료!!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginApp(),
                                      ),
                                    );
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text('밴러지 회원가입하기'),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
