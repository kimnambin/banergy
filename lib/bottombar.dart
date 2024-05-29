import 'dart:convert';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/mypage/mypage_freeboard.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:photo_view/photo_view.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

//바텀 바 내용 구현
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String? authToken; // 사용자의 인증 토큰
  final ImagePicker _imagePicker = ImagePicker(); // 이미지 피커 인스턴스
  final _qrBarCodeScannerDialogPlugin =
      QrBarCodeScannerDialog(); // QR/바코드 스캐너 플러그인 인스턴스
  String? code; // 바코드
  String resultCode = ''; // 스캔된 바코드 결과
  String ocrResult = ''; // OCR 결과
  bool isOcrInProgress = false; // OCR 작업 진행 여부
  final picker = ImagePicker(); // 이미지 피커 인스턴스
  late String img64; // 이미지를 Base64로 인코딩한 결과

  @override
  void initState() {
    super.initState();
  }

  // 이미지 업로드 및 OCR 작업을 수행합니다.
  Future<void> _uploadImage(XFile pickedFile) async {
    setState(() {
      isOcrInProgress = true; // 이미지 업로드 시작
    });

    final url = Uri.parse('$baseUrl:7000/ocr');
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
      //type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green, // 선택된 아이템의 색상
      unselectedItemColor: Colors.black, // 선택되지 않은 아이템의 색상
      selectedLabelStyle:
          const TextStyle(color: Colors.green), // 선택된 아이템의 라벨 색상

      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/images/home.png'),
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/images/bubble-chat.png'),
          ),
          label: '커뮤니티',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/images/lens.png'),
          ),
          label: '렌즈',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/images/heart.png'),
          ),
          label: '찜',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/images/person.png'),
          ),
          label: '마이 페이지',
        ),
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
          setState(() {
            _selectedIndex = index;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Freeboard()));
        } else if (index == 2) {
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
                            debugPrint('OCR failed: $e');
                          } finally {
                            setState(() {
                              // OCR 작업 완료 후에 진행 바를 숨깁니다.
                              isOcrInProgress = false;
                            });
                          }
                        },
                        child: const Text(
                          '카메라',
                          style: TextStyle(fontFamily: 'PretendardMedium'),
                        ),
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
                            debugPrint('OCR failed: $e');
                          }
                        },
                        child: const Text(
                          '갤러리',
                          style: TextStyle(fontFamily: 'PretendardMedium'),
                        ),
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
                        child: const Text(
                          'QR/바코드',
                          style: TextStyle(fontFamily: 'PretendardMedium'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (index == 4) {
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
