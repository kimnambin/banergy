import 'package:flutter/material.dart';
import 'package:flutter_banergy/product/code.dart';

//import 'package:flutter_banergy/product/information.dart';
import 'package:flutter_banergy/product/product.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../mypage/mypage.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(
    const MaterialApp(home: MainpageApp()),
  );
}

class MainpageApp extends StatelessWidget {
  final File? image;
  const MainpageApp({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '식품 알레르기 관리 앱',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 50, 160, 107)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식품 알레르기 관리 앱'),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final ImagePicker _imagePicker = ImagePicker();
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  String parsedText = '';

  late File? pickedImage;
  late XFile? pickedFile;
  late String img64;

  // _saveImageToGallery 함수 수정
  Future<void> _saveImageToGallery(
      XFile pickedFile, BuildContext context) async {
    final File imageFile = File(pickedFile.path);
    final savedFile = await ImageGallerySaver.saveFile(imageFile.path);
    print('Image saved to gallery: $savedFile');

    // NavigatorState를 얻어오기 전에 현재 상태를 확인
    if (mounted) {
      final NavigatorState? navigator = Navigator.of(context);
      if (navigator != null) {
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => camerainformation(
              imagePath: savedFile, // imagePath를 savedFile로 수정
            ),
          ),
        );
      } else {
        // Navigator가 null인 경우에는 기본적인 Navigator.push를 사용
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => camerainformation(
              imagePath: savedFile, // imagePath를 savedFile로 수정
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.adjust),
          label: "Lens",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'My',
        ),
      ],
      onTap: (index) async {
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
                        Navigator.pop(context);

                        final pickedFile = await _imagePicker.pickImage(
                          source: ImageSource.camera,
                        );

                        if (pickedFile != null) {
                          try {
                            // OCR 수행

                            print('Before Navigator.push');
                            _saveImageToGallery(pickedFile, context);
                            print('After Navigator.push');
                          } catch (e) {
                            print('OCR failed: $e');
                            print('Exception caught in catch block');
                          }
                        }
                      },
                      child: Text('Camera'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final pickedFile = await _imagePicker.pickImage(
                            source: ImageSource.gallery);

                        if (pickedFile != null) {
                          var ocrText = await FlutterTesseractOcr.extractText(
                            pickedFile.path,
                            language: 'kor',
                          );

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  camerainformation(
                                imagePath: pickedFile.path,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('Gallery'),
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
                                builder: (context) =>
                                    CodeScreen(resultCode: code ?? "스캔된 정보 없음"),
                              ),
                            );
                          },
                        );
                      },
                      child: Text('QR/Barcode'),
                    ),
                  ),
                ],
              ));
            },
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MypageApp()),
          );
        }
      },
    );
  }
}
