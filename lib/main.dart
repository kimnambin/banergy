import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/information.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import '../appbar/menu.dart';
import 'appbar/search.dart';
import '../mypage/mypage.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MainpageApp());
}

class MainpageApp extends StatelessWidget {
  final File? image;
  const MainpageApp({super.key, this.image});

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
        actions: [
          InkWell(
            onTap: () {
              // 검색 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
          ),
          InkWell(
            onTap: () {
              // 메뉴 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.menu),
            ),
          ),
        ],
      ),
      body: const ProductGrid(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        // 상품 아이콘을 가져오거나 사용하는 코드 작성
        return Card(
          child: InkWell(
              onTap: () {
                //아이콘 클릭 시 실행할 동작 추가
                _handleProductClick(context, index);
              },
              child: Column(
                children: [
                  const Icon(Icons.fastfood, size: 48), // 아이콘 예시 (음식 아이콘)
                  Text('Product $index'),
                  Text('Description of Product $index'),
                ],
              )),
        );
      },
    );
  }
}

void _handleProductClick(BuildContext context, int index) {
  // 아이콘 클릭 시 실행할 동작을 여기에 추가
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('상품 정보'),
        content: Text('Product $index의 상세 정보를 표시합니다.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('닫기'),
          ),
        ],
      );
    },
  );
}

//바텀 바 내용 구현
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
  // getImage 함수 안에서 사용될 변수들을 함수 밖으로 이동
  late XFile? pickedFile;
  late String img64;

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
      onTap: (index) {
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
                  child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 카메라 부분
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          final pickedFile = await _imagePicker.pickImage(
                            source: ImageSource.camera,
                          );

                          if (pickedFile != null) {
                            // OCR 수행
                            var ocrText = await FlutterTesseractOcr.extractText(
                              pickedFile.path,
                              language: 'kor',
                            );

                            // Information 화면으로 이동하여 OCR 결과값 전달
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Information(
                                  image: File(pickedFile.path),
                                  parsedText: ocrText,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Camera'),
                      ),
                    ),
                    // 갤러리 부분
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final pickedFile = await _imagePicker.pickImage(
                              source: ImageSource.gallery);

                          if (pickedFile != null) {
                            // OCR 수행
                            var ocrText = await FlutterTesseractOcr.extractText(
                              pickedFile.path,
                              language: 'kor',
                            );

                            // Information 화면으로 이동하여 OCR 결과값 전달
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Information(
                                  image: File(pickedFile.path),
                                  parsedText: ocrText,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Gallery'),
                      ),
                    ),

                    //qr+barcode 코드 부분
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            context: context,
                            onCode: (code) {
                              // 화면 이동만 처리
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CodeScreen(
                                      resultCode: code ?? "스캔된 정보 없음"),
                                ),
                              );
                            },
                          );
                        },
                        child: Text('QR/Barcode'),
                      ),
                    ),
                  ],
                ),
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
