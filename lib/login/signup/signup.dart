import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:flutter_banergy/login/signup/joinwidget.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: JoinApp(),
    ),
  );
}

class JoinApp extends StatefulWidget {
  const JoinApp({super.key});

  @override
  State<JoinApp> createState() => _JoinAppState();
}

class _JoinAppState extends State<JoinApp> {
  //유효성 검사 부분
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _dateController;
  String? _selectedGender;

  // 회원가입 함수
  Future<void> _signup(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String date = _dateController.text;
    final String? gender = _selectedGender;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.121.174:3000/sign'),
        body: jsonEncode({
          'username': username,
          'password': password,
          'name': name,
          'date': date,
          'gender': gender,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        // 회원가입 성공 시
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('밴러지 회원가입완료!!'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginApp(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        // 실패 시
        // ignore: use_build_context_synchronously
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
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 29, 171, 102),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('확인'),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

//회원가입 페이지만에 글로벌 키를 사용하기 위함
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _dateController = TextEditingController();
  }

  // 각 필드에 대한 유효성 검사 함수 정의
  bool isIdValid() {
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$'; //영어 + 숫자 조합을 위함
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(_usernameController.text) &&
        _usernameController.text.length >= 5; //5글자 이상
  }

  bool isPasswordValid() {
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]+$'; //영어+숫자+특수기호 조합을 위함
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(_passwordController.text) &&
        _passwordController.text.length >= 5;
  }

  bool isConfirmPasswordValid() {
    return _confirmPasswordController
            .text.isNotEmpty && //비었는지 + 위에 입력한 비밀번호와 동일한지 확인
        _confirmPasswordController.text == _passwordController.text;
  }

  bool isNameValid() {
    return _nameController.text.isNotEmpty;
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirstApp()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/000.jpeg',
                      width: 100,
                      height: 100,
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
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
                      controller: _passwordController,
                      obscureText: true,
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
                      controller: _confirmPasswordController,
                      obscureText: true,
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
                        } else if (value != _passwordController.text) {
                          return '비밀번호가 일치하지 않습니다.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _nameController,
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
                      controller: _dateController,
                      onChanged: (selectedDate) {
                        setState(() {
                          _dateController.text = selectedDate.toString();
                        });
                      },
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
                      selectedGender: _selectedGender,
                      onChanged: (selectedGender) {
                        setState(() {
                          _selectedGender = selectedGender;
                        });
                      },
                      label: '',
                      hintText: '성별',
                      iconColor: Colors.grey,
                      hintTextColor: Colors.grey,
                      icon: Icons.wc,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _signup(context),
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
