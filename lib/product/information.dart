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
        title: Text('식품 정보'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //이미지
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.file(image),
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 2.0,
              height: 5.0,
            ),
            Center(
              child: Text(
                '식품 정보',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // OCR 결과 표시
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(' $parsedText'),
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
      ),
    );
  }
}
