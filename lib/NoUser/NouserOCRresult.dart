// ignore: file_names
// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Ocrresult2 extends StatefulWidget {
  final String imagePath;
  final String ocrResult;

  const Ocrresult2({
    super.key,
    required this.imagePath,
    required this.ocrResult,
  });

  @override
  _OcrresultState createState() => _OcrresultState();
}

class _OcrresultState extends State<Ocrresult2> {
  late String _ocrResult;
  late String _hirightingResult;
  bool isOcrInProgress = true;
  List<String> userAllergies = []; // 사용자 알레르기 정보를 저장할 리스트
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  void initState() {
    super.initState();
    _ocrResult = widget.ocrResult;
    _hirightingResult = widget.ocrResult;
    _getAllergies();
    _getOCRResult();
  }

  Future<void> _getAllergies() async {
    try {
      final url = Uri.parse('$baseUrl:8000/nouser/ftr');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        userAllergies = (data['allergies'] as List).cast<String>();
        print('사용자 알레르기 : $userAllergies');
      } else {
        print('Failed to fetch user allergies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching user allergies: $e');
    }
  }

  Future<void> _getOCRResult() async {
    try {
      final url = Uri.parse('$baseUrl:8000/nouser/result');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<String> ocrResult = (data['text'] as List).cast<String>();

        // // 사용자의 알레르기 정보
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // final userAllergies = prefs.getStringList('allergies') ?? [];

// 정규 표현식을 사용하여 사용자의 알레르기 정보와 일치하는 부분 추출
        RegExp regex = RegExp(r'『(.*?)』');
        List<String> highlightingTexts = [];
        for (String line in ocrResult) {
          highlightingTexts.addAll(regex
                  .allMatches(line)
                  .map((match) => match.group(1) ?? '') // null일 경우 빈 문자열 반환
              //       //.where((highlightedWord) => userAllergies
              //           .contains(highlightedWord)) // 사용자 알레르기 정보와 일치하는 것만 필터링
              //       .toList(),
              );
        }

        String highlightingResult = highlightingTexts.join(', ');

        String plainText = ocrResult.join(' ');

        setState(() {
          _hirightingResult = highlightingResult.trim();
          _ocrResult = plainText.trim();
        });
      } else {
        setState(() {
          _hirightingResult = '';
        });
      }
    } catch (e) {
      setState(() {
        _hirightingResult = 'Error occurred: $e';
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
          title: const Text(
            "OCR 결과",
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
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
                  color: Color(0xFFDDD7D7),
                  thickness: 1.0,
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
                    child: Column(
                      children: [
                        if (_hirightingResult.isNotEmpty)
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                            ),
                            child: const Text(
                              //_hirightingResult,

                              '사용자와 맞지 않은 상품입니다.',

                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black, // 텍스트 색상 지정
                              ),
                            ),
                          ),
                        if (_ocrResult.isNotEmpty)
                          Text(
                            _ocrResult,
                          ),
                        if (_hirightingResult.isEmpty && _ocrResult.isEmpty)
                          const Text('No text detected'),
                      ],
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF03C95B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const SizedBox(
                    width: 50,
                    height: 30,
                    child: Center(
                      child: Text(
                        '닫기',
                        style: TextStyle(
                            fontFamily: 'PretendardSemiBold', fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
