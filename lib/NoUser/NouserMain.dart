// 비회원 메인 페이지

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/NoUser/NouserOCRresult.dart';
import 'package:flutter_banergy/appbar/search_widget.dart';
import 'package:flutter_banergy/main_category/Drink.dart';
import 'package:flutter_banergy/main_category/Sandwich.dart';
import 'package:flutter_banergy/main_category/bigsnacks.dart';
import 'package:flutter_banergy/main_category/gimbap.dart';
import 'package:flutter_banergy/main_category/instantfood.dart';
import 'package:flutter_banergy/main_category/lunchbox.dart';
import 'package:flutter_banergy/main_category/ramen.dart';
import 'package:flutter_banergy/main_category/snacks.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/product_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_banergy/mainDB.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:photo_view/photo_view.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(
    const MaterialApp(
      home: NoUserMainpageApp(),
    ),
  );
}

class NoUserMainpageApp extends StatelessWidget {
  final File? image;

  const NoUserMainpageApp({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
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

  Future<void> _uploadImage(XFile pickedFile) async {
    setState(() {
      isOcrInProgress = true; // 이미지 업로드 시작
    });

    final url = Uri.parse('http://192.168.112.174:7000/ocr');
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
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<String> imageList = [
    'assets/images/ad.png',
  ];

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
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                sliderWidget(),
                sliderIndicator(),
              ],
            ),
          ),
          // 공간추가, 카테고리 리스트
          SizedBox(
            height: 120, // 라벨을 포함하기에 충분한 높이 설정
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8, // 카테고리 개수
              itemBuilder: (BuildContext context, int index) {
                // 카테고리 정보 (이름과 이미지 파일 이름)
                List<Map<String, String>> categories = [
                  {"name": "라면", "image": "001.png"},
                  {"name": "패스트푸드", "image": "002.png"},
                  {"name": "김밥", "image": "003.png"},
                  {"name": "도시락", "image": "004.png"},
                  {"name": "샌드위치", "image": "005.png"},
                  {"name": "음료", "image": "006.png"},
                  {"name": "간식", "image": "007.png"},
                  {"name": "과자", "image": "008.png"},
                ];

                // 현재 카테고리
                var category = categories[index];

                return GestureDetector(
                  onTap: () {
                    _navigateToScreen(context, category["name"]!);
                  },
                  child: SizedBox(
                    width: 100,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.asset(
                              'assets/images/${category["image"]}',
                              width: 60, // 이미지의 너비
                              height: 60, // 이미지의 높이
                            ),
                          ),
                          Text('${category["name"]}', // 카테고리 이름 라벨
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
              MaterialPageRoute(
                  builder: (context) => const NoUserMainpageApp()),
            );
          } else if (index == 1) {
            setState(() {
              _selectedIndex = index;
            });
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('비회원 이용불가'),
                    content: const Text('비회원은 이용하실 수 없습니다.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 29, 171, 102),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('확인'),
                      ),
                    ],
                  );
                });
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
                                  builder: (BuildContext context) => Ocrresult2(
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
                                  builder: (BuildContext context) => Ocrresult2(
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
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('비회원 이용불가'),
                    content: const Text('비회원은 이용하실 수 없습니다.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 29, 171, 102),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('확인'),
                      ),
                    ],
                  );
                });
          }
        },
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String categoryName) {
    Widget? screen;
    switch (categoryName) {
      case '라면':
        screen = const RamenScreen();
        break;
      case '패스트푸드':
        screen = const InstantfoodScreen();
        break;
      case '김밥':
        screen = const GimbapScreen();
        break;
      case '도시락':
        screen = const LunchboxScreen();
        break;
      case '샌드위치':
        screen = const SandwichScreen();
        break;
      case '음료':
        screen = const DrinkScreen();
        break;
      case '간식':
        screen = const snacksScreen();
        break;
      case '과자':
        screen = const BigsnacksScreen();
        break;
    }
    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen!),
      );
    }
  }

// 캐러셀 관련 코드
  Widget sliderWidget() {
    return CarouselSlider(
      carouselController: _controller,
      items: imageList.map(
        (imgLink) {
          return Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  imgLink,
                  fit: BoxFit.fill,
                ),
              );
            },
          );
        },
      ).toList(),
      options: CarouselOptions(
        height: 220,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
    );
  }

  Widget sliderIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imageList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12,
              height: 12,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

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
    fetchData(); // initState에서 데이터를 불러옵니다.
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://192.168.112.174:8000/'),
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PretendardRegular'), // 텍스트 크기와 별도로 다시 수정
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

  void _handleProductClick(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pdScreen(product: product),
      ),
    );
  }
}
