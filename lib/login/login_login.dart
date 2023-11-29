import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_join.dart';
import 'package:flutter_banergy/main.dart';

void main() {
  runApp(
    MaterialApp(
      home: LoginApp(),
    ),
  );
}

//글로벌 키 -->> validator 사용하기 위함
class LoginApp extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 29, 171, 102)),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
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
                    SizedBox(height: 60),
                    Column(
                      children: [
                        InputField(
                          hintText: 'ID *',
                          label: '',
                        ),
                        SizedBox(height: 10),
                        InputField(
                          hintText: 'PW *',
                          label: '',
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('밴러지 로그인완료!!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainpageApp(),
                                        ),
                                      );
                                    },
                                    child: Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text('밴러지 로그인'),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    //텍스트 클릭 시 회원가입 창으로...
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => JoinApp()));
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '밴러지가 처음이신가요? ',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '회원가입',
                              style: TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
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

// 인풋 필드 선언
class InputField extends StatelessWidget {
  final String hintText;

  InputField({
    required this.hintText,
    required String label,
  });

//인풋 필드 내용
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 입력 항목입니다.';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
