// 로그인 관련 화면들이 함께 쓰는 "라벨 + 밑줄 입력창" 위젯입니다.
// (라벨 글자가 입력창 위에 따로 표시되고, 입력창 아래에 옅은 회색 밑줄이 있는 스타일)

import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.labelStyle = const TextStyle(
      fontFamily: 'PretendardBold',
      fontSize: 30,
    ),
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(227, 227, 227, 1.0)),
            ),
          ),
        ),
      ],
    );
  }
}
