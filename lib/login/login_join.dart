import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //서버 연동을 위함
  runApp(
    MaterialApp(
      home: joinApp(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 29, 171, 102)),
        useMaterial3: true,
      ),
    ),
  );
}

class joinApp extends StatefulWidget {
  joinApp({super.key});

  @override
  State<joinApp> createState() => _joinAppState();
}

class _joinAppState extends State<joinApp> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
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
                    '회원가입',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    icon: Icons.lock_open,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  SizedBox(height: 20),
                  InputField(
                    label: '',
                    hintText: '비밀번호 재확인',
                    iconColor: Colors.grey,
                    hintTextColor: Colors.grey,
                    icon: Icons.lock_open,
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
                  //생년월일 달력
                  DatePicker(
                    label: '',
                    hintText: '생년월일',
                    iconColor: Colors.grey,
                    hintTextColor: Colors.grey,
                    icon: Icons.calendar_today,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  SizedBox(height: 20),
                  InputField(
                    label: '',
                    hintText: '성별',
                    iconColor: Colors.grey,
                    hintTextColor: Colors.grey,
                    icon: Icons.wc,
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
                        child: Text('회원가입'),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 29, 171, 102),
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
    );
  }
}

//달력 위젯 http://rwdb.kr/datepicker/
class DatePicker extends StatefulWidget {
  const DatePicker({
    Key? key,
    this.label = '',
    this.hintText = '',
    this.icon,
    this.iconColor = Colors.grey,
    this.hintTextColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
  }) : super(key: key);

  final String label;
  final String hintText;
  final IconData? icon;
  final Color iconColor;
  final Color hintTextColor;
  final BorderRadius borderRadius;

  @override
  _DatepickerState createState() => _DatepickerState();
}

//달력 바? 를 위함
class _DatepickerState extends State<DatePicker> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _dateController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: TextField(
        controller: _dateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: widget.iconColor,
                )
              : null,
          hintStyle: TextStyle(color: widget.hintTextColor),
          border: OutlineInputBorder(
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }
}
