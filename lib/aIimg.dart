// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MaterialApp(
    home: AI_imgScreen(),
  ));
}

class AI_imgScreen extends StatefulWidget {
  const AI_imgScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AI_imgScreenState createState() => _AI_imgScreenState();
}

class _AI_imgScreenState extends State<AI_imgScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String aiResult = '';

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _addProduct(BuildContext context) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl:8000/AI/img'),
      );

      // 이미지 파일 추가
      if (_image != null) {
        var imageStream = http.ByteStream(_image!.openRead());
        var length = await _image!.length();
        var multipartFile = http.MultipartFile(
          'image',
          imageStream,
          length,
          filename: _image!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonData = json.decode(responseData.body); // JSON 파싱
        setState(() {
          aiResult = jsonData['AI 분석결과']; // AI 분석 결과 저장
        });
        _showResultDialog(context); // 결과 표시
      } else {
        _showErrorDialog(context, '다시 한번 확인해주세요');
      }
    } catch (e) {
      print('서버에서 오류가 발생했음: $e');
      _showErrorDialog(context, '서버에서 오류가 발생했습니다.');
    }
  }

  void _showResultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('AI 분석결과: $aiResult'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ),
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
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
        //bottomNavigationBar: const BottomNavBar(),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'AI 이미지',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildPhotoArea(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _getImage(ImageSource.camera);
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Color(0xFFA7A6A6),
                          ),
                          label: const Text("카메라",
                              style: TextStyle(
                                color: Color(0xFFA7A6A6),
                              )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Color(0xFFEBEBEB)),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30), // 간격 조절
                        ElevatedButton.icon(
                          onPressed: () {
                            _getImage(ImageSource.gallery);
                          },
                          icon: const Icon(
                            Icons.perm_media,
                            color: Color(0xFFA7A6A6),
                          ),
                          label: const Text(
                            "갤러리",
                            style: TextStyle(
                              color: Color(0xFFA7A6A6),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromRGBO(227, 227, 227, 1.0)),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildPhotoArea() {
    if (_image != null) {
      return Column(
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: Image.file(_image!),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              if (_image != null) {
                _addProduct(context);
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("물어보기", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(double.infinity, 45),
              backgroundColor: const Color.fromARGB(255, 29, 171, 102),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFFEBEBEB)),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        width: 250,
        height: 250,
        color: Colors.white,
      );
    }
  }
}
