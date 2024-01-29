import 'package:flutter/material.dart';
import 'login_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const JoinApp(),
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
  const JoinApp({super.key});

  @override
  State<JoinApp> createState() => _JoinAppState();
}

class _JoinAppState extends State<JoinApp> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  late final GlobalKey<FormState> _formKey;

//회원가입 페이지만에 글로벌 키를 사용하기 위함
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  // 각 필드에 대한 유효성 검사 함수 정의
  bool isIdValid() {
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(idController.text) && idController.text.length >= 5;
  }

  bool isPasswordValid() {
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(passwordController.text) &&
        passwordController.text.length >= 5;
  }

  bool isConfirmPasswordValid() {
    return confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text == passwordController.text;
  }

  bool isNameValid() {
    return nameController.text.isNotEmpty;
  }

  // 모든 필드에 대한 유효성 검사를 수행하는 함수
  bool isFormValid() {
    return isIdValid() &&
        isPasswordValid() &&
        isConfirmPasswordValid() &&
        isNameValid();
  }

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
                    Image.asset(
                      'images/000.jpeg',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '회원가입',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                        hintText: '아이디를 입력해주세요.',
                        prefixIcon:
                            const Icon(Icons.account_box, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$';
                        RegExp regex = RegExp(pattern);

                        if (value == null || value.isEmpty) {
                          return '아이디를 입력하세요.';
                        } else if (!regex.hasMatch(value) || value.length < 5) {
                          return '아이디는 5글자 이상의 영어 + 숫자 조합이어야 합니다.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 15), // 간격 벌리기 용
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: '비밀번호를 입력해주세요.',
                        prefixIcon:
                            const Icon(Icons.lock_open, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        String pattern =
                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]+$';
                        RegExp regex = RegExp(pattern);

                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력하세요.';
                        } else if (!regex.hasMatch(value) || value.length < 5) {
                          return '비밀번호는 5글자 이상의 영어 + 숫자 + 특수문자 조합이어야 합니다.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 15),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: '비밀번호를 다시 입력해주세요.',
                        prefixIcon:
                            const Icon(Icons.lock_open, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호 재확인.';
                        } else if (value != passwordController.text) {
                          return '비밀번호가 일치하지 않습니다.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: '이름',
                        prefixIcon: const Icon(Icons.account_circle,
                            color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '다시 확인해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // 생년월일 달력
                    DatePickerButton(
                      label: '',
                      hintText: '생년월일',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.calendar_today,
                      borderRadius: BorderRadius.circular(12.0),
                    ),

                    const SizedBox(height: 15),
                    // 성별 부분
                    genderbox(
                      label: '',
                      hintText: '성별',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.wc,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // 모든 필드의 유효성 검사를 수행
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text('밴러지 회원가입완료!!'),
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
                                    child: const Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // 어떤 필드라도 유효하지 않은 경우 사용자에게 메시지 표시
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text('입력한 정보를 확인해주세요.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('확인'),
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

// 달력 위젯 http://rwdb.kr/datepicker/
class DatePickerButton extends StatefulWidget {
  const DatePickerButton({
    super.key,
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
  });

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
  // ignore: library_private_types_in_public_api
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

//달력 설정
class _DatePickerButtonState extends State<DatePickerButton> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
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
        backgroundColor: widget.backgroundColor,
        minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
          side: const BorderSide(
              //color: Colors.black,
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
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: _dateController,
              enabled: false,
              style: TextStyle(
                fontSize: widget.hintTextSize,
                //color: Colors.black,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 인풋 필드 선언
class InputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final IconData icon;
  final Color iconColor; // 아이콘 색상 추가
  final Color? hintTextColor; // 힌트 텍스트 색상 추가
  final BorderRadius borderRadius;

  const InputField({
    super.key,
    required this.label,
    this.hintText,
    required this.icon,
    required this.iconColor,
    this.hintTextColor,
    required this.borderRadius,
    required TextEditingController controller,
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
            hintStyle: TextStyle(color: hintTextColor),
            border: OutlineInputBorder(
              borderRadius: borderRadius,
            ),
            prefixIcon: Icon(icon, color: iconColor),
          ),
        ),
      ],
    );
  }
}

// 성별 부분 해보기
// ignore: camel_case_types
class genderbox extends StatefulWidget {
  const genderbox({
    super.key,
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
  });
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
  // ignore: library_private_types_in_public_api
  _genderboxState createState() => _genderboxState();
}

// ignore: camel_case_types
class _genderboxState extends State<genderbox> {
  String? _selectedGender;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _selectGender(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            minimumSize: Size(widget.buttonWidth, widget.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius,
              side: const BorderSide(
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
              const SizedBox(width: 8.0),
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
