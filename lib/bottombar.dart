import 'dart:convert';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

//바텀 바 내용 구현
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final ImagePicker _imagePicker = ImagePicker();
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  String resultCode = '';
  String ocrResult = '';

  final picker = ImagePicker();
  late String img64;

  Future<void> _UploadImage(XFile pickedFile) async {
    // 이미지 업로드 및 OCR 수행

    final url = Uri.parse('http://192.168.1.174:7000/ocr');
    final request = http.MultipartRequest('POST', url);
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

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
                        // 추가: 카메라 권한 확인 및 요청
                        var cameraStatus = await Permission.camera.status;
                        if (!cameraStatus.isGranted) {
                          await Permission.camera.request();
                        }
                        final pickedFile = await _imagePicker.pickImage(
                          source: ImageSource.camera,
                        ) as XFile;

                        try {
                          // OCR 수행
                          await _UploadImage(pickedFile);

                          // OCR 결과를 화면으로 전달하여 화면 이동
                          // ignore: use_build_context_synchronously
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
                          print('OCR failed: $e');
                          // OCR이 실패하더라도 아무것도 하지 않음
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

                        try {
                          // OCR 수행
                          await _UploadImage(pickedFile);

                          // OCR 결과를 화면으로 전달하여 화면 이동
                          // ignore: use_build_context_synchronously
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
                          print('OCR failed: $e');
                          // OCR이 실패하더라도 아무것도 하지 않음
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
    );
  }
}
