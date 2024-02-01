import 'package:flutter/material.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/product.dart';
import '../appbar/menu.dart';
import 'appbar/search.dart';
import '../mypage/mypage.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:flutter_banergy/intro/intro_main.dart';

//메인화면
void main() {
  runApp(
    const MaterialApp(home: MainpageApp()),
  );
}

class MainpageApp extends StatelessWidget {
  final File? image;
  const MainpageApp({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '식품 알레르기 관리 앱',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 50, 160, 107)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식품 알레르기 관리 앱'),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        actions: [
          InkWell(
            onTap: () {
              // 검색 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
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
            child: const Padding(
              padding: EdgeInsets.all(8.0),
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
  const ProductGrid({super.key});

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
  const BottomNavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

  // _saveImageToGallery 사진 찍은 후 갤러리에 저장
  Future<void> _saveImageToGallery(
      XFile pickedFile, BuildContext context) async {
    final File imageFile = File(pickedFile.path);

    try {
      // OCR 수행
      final String imagePath = await _performOCR(imageFile);

      // 다음 화면으로 이동
      if (mounted) {
        final NavigatorState navigator = Navigator.of(context);
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => camerainformation(
              imagePath: imagePath,
            ),
          ),
        );
      }
    } catch (e) {
      print('OCR failed: $e');
      // OCR 오류 시
    }
  }

//카메라 찍은 거 이미지
  Future<String> _performOCR(File imageFile) async {
    try {
      return imageFile.path;
    } catch (e) {
      //오류 떴을때 확인
      print('OCR failed: $e');
      rethrow;
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
                        final pickedFile = await _imagePicker.pickImage(
                          source: ImageSource.camera,
                        );

                        if (pickedFile != null) {
                          try {
                            // OCR 수행
                            print('Before Navigator.push');
                            // ignore: use_build_context_synchronously
                            _saveImageToGallery(pickedFile, context);
                            print('After Navigator.push');
                          } catch (e) {
                            print('OCR failed: $e');
                            print('Exception caught in catch block');
                          }
                        }
                      },
                      child: const Text('Camera'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final pickedFile = await _imagePicker.pickImage(
                            source: ImageSource.gallery);

                        if (pickedFile != null) {
                          // ignore: use_build_context_synchronously
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
                                builder: (context) =>
                                    CodeScreen(resultCode: code ?? "스캔된 정보 없음"),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MypageApp()),
          );
        }
      },
    );
  }
}
