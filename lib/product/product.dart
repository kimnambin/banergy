// camerainformation.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

// camerainformation.dart
class camerainformation extends StatefulWidget {
  final String imagePath;

  // 생성자 수정이 필요한 부분
  const camerainformation({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _camerainformationState createState() => _camerainformationState();
}

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
    } catch (e) {
      print('OCR failed: $e');
      // OCR 실패 처리
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
        title: Text('상품 정보'),
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
              CircularProgressIndicator()
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
              child: Text('닫기'),
            ),
          ],
        ),
      ),
    );
  }
}
