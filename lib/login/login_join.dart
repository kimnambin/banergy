import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: JoinApp(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 29, 171, 102),
        ),
        useMaterial3: true,
      ),
    ),
  );
}

class JoinApp extends StatefulWidget {
  JoinApp({super.key});

  @override
  State<JoinApp> createState() => _JoinAppState();
}

class _JoinAppState extends State<JoinApp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'images/000.jpeg',
                      width: 100,
                      height: 100,
                    ),
                    const Text('밴러지'),
                    const SizedBox(height: 20),
                    const Text(
                      '회원가입',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    InputField(
                      label: '',
                      hintText: '아이디를 입력해주세요.',
                      icon: Icons.account_box,
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      label: '',
                      hintText: '비밀번호를 입력해주세요.',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.lock_open,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      label: '',
                      hintText: '비밀번호 재확인',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.lock_open,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      label: '',
                      hintText: '이름',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.account_circle,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    const SizedBox(height: 10),
                    //생년월일 달력
                    DatePickerButton(
                      label: '',
                      hintText: '생년월일',
                      iconColor: Colors.grey,
                      hintTextColor: Color.fromARGB(255, 205, 199, 199),
                      icon: Icons.calendar_today,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    const SizedBox(height: 10),
                    // 성별 부분
                    genderbox(
                      label: '',
                      hintText: '성별',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.wc,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 99, 255, 180), // 배경색 추가
                                content: Text('회원가입 완료!!',
                                    style: TextStyle(
                                        color: Colors.black)), // 글자 색상 추가
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
                        }
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
                          child: Text('회원가입'),
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

class DatePickerButton extends StatefulWidget {
  const DatePickerButton({
    Key? key,
    this.label = '',
    this.hintText = '',
    this.icon,
    this.iconColor = Colors.grey,
    this.hintTextColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.buttonWidth = double.infinity,
    this.buttonHeight = 60.0,
    this.iconSize = 24.0,
    this.hintTextSize = 16.0,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final String label;
  final String hintText;
  final IconData? icon;
  final Color iconColor;
  final Color hintTextColor;
  final BorderRadius borderRadius;
  final double buttonWidth;
  final double buttonHeight;
  final double iconSize;
  final double hintTextSize;
  final Color backgroundColor;

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
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
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.hintText;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDate(context),
      style: ElevatedButton.styleFrom(
        primary: widget.backgroundColor,
        minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            widget.icon,
            color: widget.iconColor,
            size: widget.iconSize,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: _dateController,
              enabled: false,
              style: TextStyle(
                //color: Colors.black,
                fontSize: widget.hintTextSize,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 성별 부분 해보기
class genderbox extends StatefulWidget {
  const genderbox({
    Key? key,
    this.label = '',
    this.hintText = '',
    this.icon,
    this.iconColor = Colors.grey,
    this.hintTextColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.buttonWidth = double.infinity,
    this.buttonHeight = 60.0,
    this.iconSize = 24.0,
    this.hintTextSize = 16.0,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final String label;
  final String hintText;
  final IconData? icon;
  final Color iconColor;
  final Color hintTextColor;
  final BorderRadius borderRadius;
  final double buttonWidth;
  final double buttonHeight;
  final double iconSize;
  final double hintTextSize;
  final Color backgroundColor;

  @override
  _genderboxState createState() => _genderboxState();
}

class _genderboxState extends State<genderbox> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _selectGender(context),
          style: ElevatedButton.styleFrom(
            primary: widget.backgroundColor,
            minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius,
              side: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                color: widget.iconColor,
                size: widget.iconSize,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedGender == null)
                      Text(
                        widget.hintText,
                        style: TextStyle(
                          color: widget.hintTextColor,
                          fontSize: widget.hintTextSize,
                        ),
                      ),
                    if (_selectedGender != null)
                      Text(
                        _selectedGender!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: widget.hintTextSize,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectGender(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('성별'),
              ListTile(
                title: const Text('남자'),
                leading: Radio(
                  value: '남자',
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
              ),
              ListTile(
                title: const Text('여자'),
                leading: Radio(
                  value: '여자',
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
