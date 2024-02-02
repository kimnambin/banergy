import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mypage/mypage_ChangeNick.dart';
import 'package:flutter_banergy/mypage/mypage_Changeidpw.dart';
import 'package:flutter_banergy/mypage/mypage_Delete.dart';
import 'package:flutter_banergy/mypage/mypage_InquiryScreen.dart';
import 'package:flutter_banergy/mypage/mypage_addProductScreen.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import '../mypage/mypage_allergy_information.dart';
import '../mypage/mypage_record_allergy_reactions.dart';
import '../mypage/mypage_filtering_allergies.dart';
import '../mypage/mypage_freeboard.dart';
//import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

void main() {
  runApp(const MypageApp());
}

class MypageApp extends StatelessWidget {
  const MypageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  set code(String? code) {}

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToPage(String pageName) {
    // 페이지 이름에 따라 다른 동작 수행
    switch (pageName) {
      case "알러지 정보":
        // 알러지 정보 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const allergyinformation()),
        );
        break;
      case "알러지 반응 기록":
        // 알러지 반응 기록 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const recordallergyreactions()),
        );
        break;
      case "알러지 필터링":
        // 알러지 필터링 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FilteringAllergies()),
        );
        break;
      case "닉네임 변경":
        // 닉네임 변경 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangeNick()),
        );
        break;
      case "비밀번호 변경":
        // 비밀번호 변경 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Changeidpw()),
        );
        break;
      case "탈퇴하기":
        // 탈퇴하기 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Delete()),
        );
        break;

      case "문의하기":
        // 문의하기 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InquiryScreen()),
        );

        break;
      case "상품추가":
        // 상품추가 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProductScreen()),
        );
        break;

      case "자유게시판":
        // 자유게시판 페이지으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Freeboard()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
    // String? code;
    return Scaffold(
      appBar: AppBar(
        title: const Text("마이페이지"),
        backgroundColor: const Color.fromARGB(255, 29, 171, 102),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainpageApp()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: _buildlist(),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildlist() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0), // 내부 여백 추가

        /*decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green, // 테두리 색상 설정
            width: 2.0, // 테두리 두께 설정
          ),
          borderRadius: BorderRadius.circular(12.0), // 테두리 모서리를 둥글게 만듦
        ),*/
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 나의 알러지
            _buildSectionTitle("나의 알러지", Icons.accessibility),

            _buildButton(
              "알러지 정보",
            ),
            const SizedBox(height: 20),
            _buildButton(
              "알러지 반응 기록",
            ),
            const SizedBox(height: 20),
            _buildButton("알러지 필터링"),
            const SizedBox(height: 20),
            Divider(
              color: Colors.grey[200],
              thickness: 2.0,
              //height: 0.05,
            ),
            // 설정
            _buildSectionTitle("설정", Icons.settings),
            _buildButton("닉네임 변경"),
            const SizedBox(height: 20),
            _buildButton("비밀번호 변경"),
            const SizedBox(height: 20),
            _buildButton("탈퇴하기"),
            const SizedBox(height: 20),
            Divider(
              color: Colors.grey[200],
              thickness: 2.0,
              //height: 10.0,
            ),
            // 추가 지원
            _buildSectionTitle("추가 지원", Icons.support),
            _buildButton("문의하기"),
            const SizedBox(height: 20),
            _buildButton("상품추가"),
            const SizedBox(height: 20),
            _buildButton("자유게시판"),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String buttonText) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _navigateToPage(buttonText);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.infinity, 45),
            backgroundColor:
                const Color.fromARGB(255, 255, 255, 255), // 직접 지정한 색상 코드
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFEBEBEB)), // 테두리 색상
              borderRadius: BorderRadius.circular(8.0), // 테두리 둥글기
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              //color: Color.fromARGB(255, 29, 171, 102),
              color: Color.fromARGB(0xFF, 38, 159, 115),
            ),
          ),
        ),
      );
}

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
