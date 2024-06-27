// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, duplicate_ignore, collection_methods_unrelated_type, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/home_search_widget.dart';
//import 'package:flutter_banergy/login/login_login.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:flutter_banergy/mypage/mypage_freeboard.dart';
import 'package:flutter_banergy/product/like_product.dart';
import 'package:flutter_banergy/product/code.dart';
import 'package:flutter_banergy/product/ocr_result.dart';
import 'package:flutter_banergy/product/product_detail.dart';
import 'package:flutter_banergy/main_filtering_allergies.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_banergy/mainDB.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:photo_view/photo_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_banergy/main_category/bigsnacks.dart';
//import 'package:flutter_banergy/main_category/gimbap.dart';
import 'package:flutter_banergy/main_category/snacks.dart';
import 'package:flutter_banergy/main_category/Drink.dart';
import 'package:flutter_banergy/main_category/instantfood.dart';
import 'package:flutter_banergy/main_category/ramen.dart';
//import 'package:flutter_banergy/main_category/lunchbox.dart';
//import 'package:flutter_banergy/main_category/Sandwich.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
    _checkLoginStatus(); // 로그인 상태 확인
  }

  // 이미지 업로드 및 OCR 작업을 수행합니다.
  Future<void> _uploadImage(XFile pickedFile) async {
    setState(() {
      isOcrInProgress = true; // 이미지 업로드 시작
    });

    final url = Uri.parse('$baseUrl:8000/logindb/ocr');
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
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error validating token: $e');
      return false;
    }
  }

  int _selectedIndex = 0; // 현재 선택된 바텀 네비게이션 바 아이템의 인덱스
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<String> imageList = [
    'assets/images/ad.png',
  ];
  List<Product> likedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Home_SearchWidget(), // 검색 위젯
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/filter.png',
              width: 24.0,
              height: 24.0,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FilteringAllergies(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LPscreen(),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: Stack(
                children: [
                  sliderWidget(),
                  sliderIndicator(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // 카테고리 개수
                itemBuilder: (BuildContext context, int index) {
                  // 카테고리 정보 (이름과 이미지 파일 이름)
                  List<Map<String, String>> categories = [
                    {"name": "라면", "image": "001.png"},
                    {"name": "패스트푸드", "image": "002.png"},
                    // {"name": "김밥", "image": "003.png"},
                    // {"name": "도시락", "image": "004.png"},
                    // {"name": "샌드위치", "image": "005.png"},
                    {"name": "음료", "image": "006.png"},
                    {"name": "간식", "image": "007.png"},
                    {"name": "과자", "image": "008.png"},
                  ];

                  // 현재 카테고리
                  var category = categories[index];

                  return GestureDetector(
                    onTap: () {
                      _navigateToScreen(
                        context,
                        category["name"]!,
                      );
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
                            Text(
                              '${category["name"]}', // 카테고리 이름 라벨
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'PretendardBold',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const ProductGrid(), // 상품 그리드

          if (isOcrInProgress) // OCR 작업이 진행 중인 경우에만 표시
            SliverToBoxAdapter(
              child: Container(
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
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.fixed,
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
                            );

                            if (pickedFile != null) {
                              setState(() {
                                // 이미지 선택 후에 진행 바를 나타냅니다.
                                isOcrInProgress = true;
                              });

                              try {
                                CroppedFile? croppedFile =
                                    await ImageCropper().cropImage(
                                  sourcePath: pickedFile.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // 크롭된 이미지를 파일로 변환
                                  File croppedImageFile =
                                      File(croppedFile.path);

                                  // OCR 작업 수행 (여기서 _uploadImage를 호출)
                                  await _uploadImage(
                                      XFile(croppedImageFile.path));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Ocrresult(
                                        imagePath: croppedImageFile.path,
                                        ocrResult: ocrResult,
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint('OCR failed: $e');
                              } finally {
                                setState(() {
                                  isOcrInProgress = false;
                                });
                              }
                            }
                          },
                          child: const Text('카메라'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await _imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );

                            if (pickedFile != null) {
                              setState(() {
                                isOcrInProgress = true;
                              });

                              try {
                                CroppedFile? croppedFile =
                                    await ImageCropper().cropImage(
                                  sourcePath: pickedFile.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // 크롭된 이미지를 파일로 변환
                                  File croppedImageFile =
                                      File(croppedFile.path);

                                  // OCR 작업 수행 (여기서 _uploadImage를 호출)
                                  await _uploadImage(
                                    XFile(croppedImageFile.path),
                                  );

                                  // 결과를 화면에 표시
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Ocrresult(
                                        imagePath: croppedImageFile.path,
                                        ocrResult: ocrResult,
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint('OCR failed: $e');
                              } finally {
                                setState(() {
                                  isOcrInProgress = false;
                                });
                              }
                            }
                          },
                          child: const Text('갤러리'),
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
          } else if (index == 3) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LPscreen()),
            );
          } else if (index == 4) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
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
      // case '김밥':
      //   screen = const GimbapScreen();
      //   break;
      // case '도시락':
      //   screen = const LunchboxScreen();
      //   break;
      // case '샌드위치':
      //   screen = const SandwichScreen();
      //break;
      case '음료':
        screen = const DrinkScreen();
        break;
      case '간식':
        screen = const SnacksScreen();
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

// 상품 그리드를 표시하는 StatefulWidget입니다.
class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  late List<Product> products = [];
  List<Product> likedProducts = [];
  String? authToken;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    fetchData(); // 데이터 가져오기
    //likeData();
  }

  // 상품 데이터를 가져오는 비동기 함수
  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('$baseUrl:8000/'),
    );
    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> productList = json.decode(response.body);
        products = productList.map((item) => Product.fromJson(item)).toList();
      });
      //await likeData(); // Like data 가져오기
      //_updateLiked(); // 좋아요 상태 업데이트
    } else {
      throw Exception('Failed to load data');
    }
  }

  // 사용자의 로그인 상태를 확인하고 인증 토큰을 가져옵니다.
  Future<void> _checkLoginStatus() async {
    final token = await _loginUser();
    if (token != null) {
      final isValid = await _validateToken(token);
      setState(() {
        authToken = isValid ? token : null;
        if (isValid) {
          likeData(); // 좋아요 누른 상품들 데이터 가져오기
        }
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
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error validating token: $e');
      return false;
    }
  }

  // 좋아요 누른 상품들
  Future<void> likeData() async {
    if (authToken == null) return;

    final response = await http.get(
      Uri.parse('$baseUrl:8000/logindb/getlike'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);
        likedProducts = (data['liked_products'] as List)
            .map((item) => Product.fromJson(item))
            .toList();

        // 좋아요 누른 상품들 콘솔창에 보기
        for (var product in likedProducts) {
          if (kDebugMode) {
            print('좋아요 누른 상품들 -> ${product.name}');
          }
        }
      });
    } else {
      throw Exception('Failed to load liked products');
    }
  }

  //이게 좋아요 업데이트 해주는 거
  // void _updateLiked() {
  //   setState(() {
  //     for (var product in products) {
  //       product.isHearted = likedProducts.contains(product.id);
  //     }
  //   });
  // }

  Future<void> Likeproduct(Product product) async {
    final url = Uri.parse('$baseUrl:8000/logindb/like');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: json.encode({'product_id': product.id}),
    );

    if (response.statusCode == 200) {
      setState(() {
        product.isHearted = !product.isHearted;
        _toggleLikedStatus(product); // 하트 상태 업데이트
      });
    } else {
      throw Exception('Failed to toggle like');
    }
  }

  void _toggleLikedStatus(Product product) {
    setState(() {
      if (likedProducts.contains(product)) {
        likedProducts.remove(product); // 좋아요 상태 삭제
      } else {
        likedProducts.add(product); // 좋아요 상태 추가
      }
    });
  }

  // void _showLikedProducts(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => LikedProductsWidget(likedProducts: likedProducts),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFFFFF);
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final product = products[index];
          //  return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: backgroundColor,
          //             borderRadius: BorderRadius.circular(10),
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.grey.withOpacity(0.5),
          //                 spreadRadius: 2,
          //                 blurRadius: 5,
          //                 offset: const Offset(0, 3),
          //               ),
          //             ],
          //           ),
          return Card(
            color: backgroundColor,
            //여기 위까지 없애면 됨
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    _handleProductClick(context, products[index]);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 110, // 이미지 높이 제한
                        child: Center(
                          child: Image.network(
                            products[index].frontproduct,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          products[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          products[index].allergens,
                          maxLines: 1, //한줄만 보이게 하는 것
                          overflow: TextOverflow.ellipsis, //넘치는 부분은 ...으로 표시
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: likedProducts.contains(product.id)
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_border),
                    onPressed: () {
                      Likeproduct(product);
                      _toggleLikedStatus(products[index]);
                    },
                  ),
                ),
              ],
            ),
            //)
          );
        },
        childCount: products.length,
      ),
    );
  }

  // 상품 클릭 시 새로운창에서 상품 정보를 표시하는 함수
  void _handleProductClick(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pdScreen(product: product),
      ),
    );
  }
}
