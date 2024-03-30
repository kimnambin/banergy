import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;

class Ocrresult extends StatefulWidget {
  final String imagePath;
  final String ocrResult;

  const Ocrresult({
    Key? key,
    required this.imagePath,
    required this.ocrResult,
  }) : super(key: key);

  @override
  _OcrresultState createState() => _OcrresultState();
}

class _OcrresultState extends State<Ocrresult> {
  late String _ocrResult;
  bool isOcrInProgress = true;

  @override
  void initState() {
    super.initState();
    _ocrResult = widget.ocrResult;
    _getOCRResult();
  }

  Future<void> _getOCRResult() async {
    try {
      final url = Uri.parse('http://192.168.1.174:7000/result');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<String> ocrResult = (data['text'] as List).cast<String>();

        List<String> highlightWords = [
          "계란",
          "밀",
          "대두",
          "우유",
          "게",
          "새우",
          "돼지고기",
          "닭고기",
          "소고기",
          "고등어",
          "복숭아",
          "토마토",
          "호두",
          "잣",
          "땅콩",
          "아몬드",
          "조개류",
          "기타"
        ];

        List<TextSpan> highlightedSpans = [];
        for (String line in ocrResult) {
          for (String word in highlightWords) {
            if (line.contains(word)) {
              int startIndex = line.indexOf(word);
              int endIndex = startIndex + word.length;
              String beforeHighlight = line.substring(0, startIndex);
              String highlightedWord = line.substring(startIndex, endIndex);
              String afterHighlight = line.substring(endIndex);
              highlightedSpans.add(TextSpan(
                text: beforeHighlight,
                style: const TextStyle(color: Colors.black),
              ));
              highlightedSpans.add(TextSpan(
                text: highlightedWord,
                style: const TextStyle(
                  backgroundColor: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ));
              line = afterHighlight;
            }
          }
          highlightedSpans.add(TextSpan(
            text: line,
            style: const TextStyle(color: Colors.black),
          ));
        }

        setState(() {
          _ocrResult = '';
        });
        for (TextSpan span in highlightedSpans) {
          setState(() {
            _ocrResult += span.text!;
          });
        }
      } else {
        setState(() {
          _ocrResult = 'Failed to fetch OCR result: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _ocrResult = 'Error occurred: $e';
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
            const SizedBox(height: 16),
            if (isOcrInProgress)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text(
                      'OCR 결과를 가져오는 중...',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_ocrResult.isNotEmpty
                    ? ' $_ocrResult'
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
