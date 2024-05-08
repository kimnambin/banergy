// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const allergyinformation());
}

class allergyinformation extends StatelessWidget {
  const allergyinformation({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String? authToken;
  final ImagePicker _imagePicker = ImagePicker();
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  String resultCode = '';
  String ocrResult = '';
  bool isOcrInProgress = false;
  final picker = ImagePicker();
  late String img64;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _uploadImage(XFile pickedFile) async {
    setState(() {
      isOcrInProgress = true; // 이미지 업로드 시작
    });

    final url = Uri.parse('http://192.168.121.174:3000/ocr');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $authToken';
    request.files
        .add(await http.MultipartFile.fromPath('image', pickedFile.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var decodedData = jsonDecode(responseData);
      setState(() {
        ocrResult = decodedData['text'].join('\n');
      });
    } else {
      setState(() {
        ocrResult = 'Failed to perform OCR: ${response.statusCode}';
      });
    }
  }

  Future<void> _checkLoginStatus() async {
    final token = await _loginUser();
    if (token != null) {
      final isValid = await _validateToken(token);
      setState(() {
        authToken = isValid ? token : null;
      });
    }
  }

  Future<String?> _loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.121.174:3000/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      ('Error validating token: $e');
      return false;
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "나의 알레르기",
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
      body: Stack(
        children: [
          Container(
              // 내용이 있는 부분은 여기에 배치
              ),
          if (isOcrInProgress) // 업로드 중일 때만 진행 바를 표시
            Container(
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.5),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text(
                    '서버에 이미지 업로드 중... \n 최대 2~3분이 소요됩니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              activeIcon: Icon(Icons.home, color: Colors.green)),
          BottomNavigationBarItem(
              icon: Icon(Icons.adjust),
              label: "Lens",
              activeIcon: Icon(Icons.adjust, color: Colors.green)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'My',
              activeIcon: Icon(Icons.person, color: Colors.grey)),
        ],
        onTap: (index) async {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainpageApp()),
            );
          } else if (index == 1) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                    child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          var cameraStatus = await Permission.camera.status;
                          if (!cameraStatus.isGranted) {
                            await Permission.camera.request();
                          }
                          final pickedFile = await _imagePicker.pickImage(
                            source: ImageSource.camera,
                          ) as XFile;

                          setState(() {
                            // 이미지 선택 후에 진행 바를 나타냅니다.
                            isOcrInProgress = true;
                          });

                          try {
                            await _uploadImage(pickedFile);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Ocrresult(
                                  imagePath: pickedFile.path,
                                  ocrResult: ocrResult,
                                ),
                              ),
                            );
                          } catch (e) {
                            ('OCR failed: $e');
                          } finally {
                            setState(() {
                              // OCR 작업 완료 후에 진행 바를 숨깁니다.
                              isOcrInProgress = false;
                            });
                          }
                        },
                        child: const Text('Camera'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final pickedFile = await _imagePicker.pickImage(
                              source: ImageSource.gallery) as XFile;
                          setState(() {
                            isOcrInProgress = true;
                          });
                          // ignore: duplicate_ignore
                          try {
                            // OCR 수행
                            await _uploadImage(pickedFile);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Ocrresult(
                                  imagePath: pickedFile.path,
                                  ocrResult: ocrResult,
                                ),
                              ),
                            );
                          } catch (e) {
                            ('OCR failed: $e');
                          }
                        },
                        child: const Text('Gallery'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            context: context,
                            onCode: (code) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CodeScreen(
                                    resultCode: code ?? "스캔된 정보 없음",
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('QR/Barcode'),
                      ),
                    ),
                  ],
                ));
              },
            );
          } else if (index == 2) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MypageApp()),
            );
          }
        },
      ),
    );
  }
}
