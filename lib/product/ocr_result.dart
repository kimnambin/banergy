import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  late String _hirightingResult;
  bool isOcrInProgress = true;
  String? authToken;

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
      final url = Uri.parse('http://192.168.143.174:3000/loginuser');
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
        Uri.parse('http://192.168.143.174:3000/loginuser'),
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

  Future<void> _getOCRResult(String token) async {
    try {
      final url = Uri.parse('http://192.168.143.174:3000/result');
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<String> ocrResult = (data['text'] as List).cast<String>();

        // 사용자의 알레르기 정보 가져오기
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final userAllergies = prefs.getStringList('allergies') ?? [];

        //여기가 하이라이팅 부분
        String hirightingtext = '';
        for (String line in ocrResult) {
          List<String> words = line.split(' ');
          for (String word in words) {
            if (userAllergies.contains(word)) {
              hirightingtext += ' 『$word』 ';
            }
          }
          // 한 줄이 끝날 때마다 줄 바꿈 문자 '\n' 추가
          //hirightingtext += '\n';
        }

        setState(() {
          _hirightingResult = hirightingtext;
        });
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
                child: Column(
                  children: [
                    if (_hirightingResult.isNotEmpty)
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                        ),
                        child: Text(
                          _hirightingResult,
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    if (_ocrResult.isNotEmpty) Text(_ocrResult),
                    if (_hirightingResult.isEmpty && _ocrResult.isEmpty)
                      const Text('No text detected'),
                  ],
                ),
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
