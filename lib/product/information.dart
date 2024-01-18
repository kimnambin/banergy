//일단 사용안함

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_banergy/mypage/mypage.dart';

class Information extends StatelessWidget {
  final File image;
  final String parsedText;

  const Information({super.key, required this.image, required this.parsedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식품 정보'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MypageApp()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.file(image),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2.0,
              height: 5.0,
            ),
            const Center(
              child: Text(
                '식품 정보',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(' $parsedText'),
            ),
            ElevatedButton(
              onPressed: () {
                String modifiedText = '식품 정보';
                Navigator.pop(context, modifiedText);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 29, 171, 102),
              ),
              child: const Text('닫기', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
