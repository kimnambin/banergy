// 힌트 문구가 입력창 안에 옅게 보이는 스타일의 입력창 위젯입니다.
// isTextArea가 true면 여러 줄 입력창(테두리 없음), false면 한 줄 입력창
// (아래쪽에 옅은 회색 밑줄)으로 보여줍니다.

import 'package:flutter/material.dart';

class HintTextField extends StatelessWidget {
  const HintTextField({
    super.key,
    this.hintText = '',
    this.controller,
    this.isTextArea = false,
    this.textAreaMaxLines = 2,
  });

  final String hintText;
  final TextEditingController? controller;
  final bool isTextArea;
  final int textAreaMaxLines;

  @override
  Widget build(BuildContext context) {
    if (isTextArea) {
      return TextFormField(
        controller: controller,
        maxLines: textAreaMaxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      );
    }

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(227, 227, 227, 1.0)),
        ),
      ),
    );
  }
}
