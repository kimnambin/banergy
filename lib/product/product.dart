// camerainformation.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

// camerainformation.dart
// ignore: camel_case_types
class camerainformation extends StatefulWidget {
  final String imagePath;

  // 생성자 수정이 필요한 부분
  const camerainformation({super.key, required this.imagePath});

  @override
  // ignore: library_private_types_in_public_api
  _camerainformationState createState() => _camerainformationState();
}

// ignore: camel_case_types
class _camerainformationState extends State<camerainformation> {
  String parsedText = '';
  bool isOcrInProgress = true;

  @override
  void initState() {
    super.initState();
    _performOCR();
  }

  void _performOCR() async {
    try {
      var ocrText = await FlutterTesseractOcr.extractText(
        widget.imagePath,
        language: 'kor',
      );

      setState(() {
        parsedText = ocrText;
      });
    } finally {
      setState(() {
        isOcrInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 정보'),
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
                child: Image.file(File(widget.imagePath)),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2.0,
              height: 5.0,
            ),
            const Center(
              child: Text(
                'OCR 결과',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isOcrInProgress)
              const CircularProgressIndicator()
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(parsedText.isNotEmpty
                    ? ' $parsedText'
                    : 'No text detected'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 현재 화면 닫기
              },
              child: const Text('닫기'),
            ),
          ],
        ),
      ),
    );
  }
}
