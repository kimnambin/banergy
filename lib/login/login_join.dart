import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 서버 연동을 위함
  runApp(
    MaterialApp(
      home: JoinApp(),
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 29, 171, 102)),
        useMaterial3: true,
      ),
    ),
  );
}

class JoinApp extends StatefulWidget {
  const JoinApp({Key? key}) : super(key: key);

  @override
  _JoinAppState createState() => _JoinAppState();
}

class _JoinAppState extends State<JoinApp> {
  String selectedGender = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                    color: Colors.green, // 테두리 색
                    width: 2.0, // 테두리 두께
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  child: Center(
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
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                              label: '계정 아이디',
                              hintText: '사용할 아이디를 입력하세요',
                            ),
                            SizedBox(height: 5),
                            InputField(
                              label: '계정 비밀번호',
                              hintText: '사용할 비밀번호를 입력해주세요.',
                            ),
                            SizedBox(height: 5),
                            InputField(
                              label: '비밀번호 재확인',
                              hintText: '사용할 비밀번호를 다시 입력해주세요.',
                            ),
                            SizedBox(height: 5),
                            InputField(
                              label: '이름',
                              hintText: '이름을 입력해주세요.',
                            ),
                            SizedBox(height: 5),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: InputField(
                                    label: '년(year)',
                                    hintText: 'YYYY',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: InputField(
                                    label: '월(month)',
                                    hintText: 'MM',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: InputField(
                                    label: '일(day)',
                                    hintText: 'DD',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  '성별:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Radio(
                                  value: '남자',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value.toString();
                                    });
                                  },
                                ),
                                Text('남자'),
                                SizedBox(width: 10),
                                Radio(
                                  value: '여자',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value.toString();
                                    });
                                  },
                                ),
                                Text('여자'),
                              ],
                            ),
                            SizedBox(height: 5),
                            InputField(
                              label: '전화번호',
                              hintText: '전화번호를 입력해주세요.',
                            ),
                          ],
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
                                        Navigator.of(context).pop();
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
        ),
      ),
    );
  }

//라디오 버튼 부분
  void _handleRadioValueChanged(String value) {
    setState(() {
      selectedGender = value;
    });
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String hintText;

  InputField({required this.label, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
