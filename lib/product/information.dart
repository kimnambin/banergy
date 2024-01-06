import 'package:flutter/material.dart';
import 'dart:io';

class Information extends StatelessWidget {
  final File image;
  final String parsedText;

  const Information({required this.image, required this.parsedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR 결과'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // OCR 결과 표시
          Text('OCR 결과: $parsedText'),

          // 이미지 표시
          SizedBox(
            width: 200,
            height: 200,
            child: Image.file(image),
          ),
        ],
      ),
    );
  }
}
