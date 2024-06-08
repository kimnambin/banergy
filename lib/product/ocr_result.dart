import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Ocrresult extends StatefulWidget {
  final String imagePath;
  final String ocrResult;

  const Ocrresult({
    super.key,
    required this.imagePath,
    required this.ocrResult,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OcrresultState createState() => _OcrresultState();
}

class _OcrresultState extends State<Ocrresult> {
  late String _ocrResult;
  late String _hirightingResult;
  bool isOcrInProgress = true;
  String? authToken;
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  void initState() {
    super.initState();
    _ocrResult = widget.ocrResult;
    _hirightingResult = widget.ocrResult;
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _loginuser();
    if (token != null) {
      final isValid = await _validateToken(token);
      if (isValid) {
        setState(() {
          authToken = token;
        });
        await _getOCRResult(token);
        await _getUserAllergies(token); // 알레르기 정보 가져오기 추가
      } else {
        setState(() {
          authToken = null;
        });
      }
    }
  }

  Future<void> _getUserAllergies(String token) async {
    try {
      final url = Uri.parse('$baseUrl:3000/loginuser');
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<String> allergies = data['allergies'].cast<String>();
        print('사용자 알레르기 : $allergies');

        // 알레르기 정보를 저장
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('allergies', allergies);
      } else {
        print('Failed to fetch user allergies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching user allergies: $e');
    }
  }

  Future<String?> _loginuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    return token;
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:3000/loginuser'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }

  //  OCR 결과
  Future<void> _getOCRResult(String token) async {
    try {
      final url = Uri.parse('$baseUrl:3000/result');
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

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
        backgroundColor: const Color(0xFFF1F2F7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
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
              color: Color(0xFFDDD7D7),
              thickness: 1.0,
              height: 5.0,
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
                        child: Column(
                          children: [
                            // const Text(
                            //   '사용자와 맞지 않은 상품입니다.',
                            //   style: TextStyle(
                            //     fontSize: 20.0,
                            //   ),
                            // ),
                            const SizedBox(height: 10),
                            Text(
                              _hirightingResult,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
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
    );
  }
}
