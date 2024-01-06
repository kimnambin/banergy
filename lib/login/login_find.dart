import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/login/login_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 서버 연동을 위함
  runApp(
    MaterialApp(
      home: FindApp(),
    ),
  );
}

class FindApp extends StatelessWidget {
  FindApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 29, 171, 102)),
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
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
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
                        '밴러지 회원찾기',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 여기에 추가하기
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
