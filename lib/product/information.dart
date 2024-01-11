import 'package:flutter/material.dart';
import 'dart:io';

class Information extends StatelessWidget {
  final File image;
  final String parsedText;

  const Information({super.key, required this.image, required this.parsedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식품정보'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // OCR 결과 표시
          Text('식품정보: $parsedText'),
          SizedBox(width: 16.0),
          Container(
            width: 1.0,
            height: double.infinity,
            color: Colors.black,
          ),
          SizedBox(width: 16.0),
          // 이미지 표시
          SizedBox(
            width: 200,
            height: 200,
            child: Image.file(image),
          ),

          ElevatedButton(
            onPressed: () {
              // 수정된 OCR 결과를 반환
              String modifiedText = '식품 정보';
              Navigator.pop(context, modifiedText);
            },
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }
}
