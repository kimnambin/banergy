import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/SearchWidget.dart';
import 'package:flutter_banergy/login/login_login.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/mypage/mypage_freeboard.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_banergy/mainDB.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_view/photo_view.dart';
//import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MainpageApp(),
    ),
  );
}

// 앱의 메인 페이지를 빌드하는 StatelessWidget입니다.
class MainpageApp extends StatelessWidget {
  final File? image;

  const MainpageApp({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

// 홈 화면을 관리하는 StatefulWidget입니다.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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
    _checkLoginStatus(); // 로그인 상태 확인
  }

  // 이미지 업로드 및 OCR 작업을 수행합니다.
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
        ocrResult = decodedData['text'].join('\n'); // OCR 결과 업데이트
      });
    } else {
      setState(() {
        ocrResult =
            'Failed to perform OCR: ${response.statusCode}'; // OCR 실패 메시지 업데이트
      });
    }
  }

  // 사용자의 로그인 상태를 확인하고 인증 토큰을 가져옵니다.
  Future<void> _checkLoginStatus() async {
    final token = await _loginUser();
    if (token != null) {
      final isValid = await _validateToken(token);
      setState(() {
        authToken = isValid ? token : null;
      });
    }
  }

  // 사용자가 이미 로그인했는지 확인합니다.
  Future<String?> _loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // 토큰의 유효성을 확인합니다.
  Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.121.174:3000/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error validating token: $e');
      return false;
    }
  }

  int _selectedIndex = 0; // 현재 선택된 바텀 네비게이션 바 아이템의 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Flexible(
            child: SearchWidget(), // 검색 위젯
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // 공간 추가
          const Expanded(
            child: ProductGrid(), // 상품 그리드
          ),
          if (isOcrInProgress) // OCR 작업이 진행 중인 경우에만 표시
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
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
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
            _selectedIndex = index; // 선택된 인덱스 업데이트
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainpageApp()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Freeboard()));
            // 커뮤니티 페이지로 이동
            // 커뮤니티 페이지로 이동하는 코드를 여기에 추가
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
      ),
    );
  }
}

// 상품 그리드를 표시하는 StatefulWidget입니다.
class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // 데이터 가져오기
  }

  // 상품 데이터를 가져오는 비동기 함수
  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://192.168.121.174:8000/'),
    );
    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> productList = json.decode(response.body);
        products = productList.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // 사용자의 로그인 상태를 확인하고 메인 페이지로 리디렉션하는 함수
  Future<void> checkLoginStatus(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) {
      // 로그인x
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginApp()),
      );
    } else {
      // 로그인 o -> 메인 페이지로 이동
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainpageApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: products.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              _handleProductClick(context, products[index]);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Image.network(
                      products[index].frontproduct,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  products[index].name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(products[index].allergens),
              ],
            ),
          ),
        );
      },
    );
  }

  // 상품 클릭 시 팝업 다이얼로그를 열고 상품 정보를 표시하는 함수
  void _handleProductClick(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('상품 정보'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('카테고리: ${product.kategorie}'),
                Text('이름: ${product.name}'),
                GestureDetector(
                  onTap: () {
                    // 확대 이미지
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              PhotoView(
                                imageProvider:
                                    NetworkImage(product.frontproduct),
                                minScale:
                                    PhotoViewComputedScale.contained * 1.0,
                                maxScale: PhotoViewComputedScale.covered * 2.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(); // 다이얼로그 닫기
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: const Icon(Icons.close),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    product.frontproduct,
                    fit: BoxFit.cover,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // 확대 이미지
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              PhotoView(
                                imageProvider:
                                    NetworkImage(product.backproduct),
                                minScale:
                                    PhotoViewComputedScale.contained * 1.0,
                                maxScale: PhotoViewComputedScale.covered * 2.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(); // 다이얼로그 닫기
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: const Icon(Icons.close),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    product.backproduct,
                    fit: BoxFit.cover,
                  ),
                ),
                Text('알레르기 식품: ${product.allergens}'),
              ],
            ),
          ),
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
}
