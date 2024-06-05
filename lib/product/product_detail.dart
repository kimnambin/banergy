import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mainDB.dart';
//import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_view/photo_view.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const MaterialApp(
      home: pdScreen(
        product: null,
      ),
    ),
  );
}

//pd -> 프로덕트 디테일 줄임말
// ignore: camel_case_types
class pdScreen extends StatefulWidget {
  final Product? product;

  const pdScreen({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _pdScreenState createState() => _pdScreenState();
}

// ignore: camel_case_types
class _pdScreenState extends State<pdScreen> {
  late List<Product> products = [];
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String? authToken;
  bool hasMatchingAllergy = false; //알레르기 일치 여부
  double textScaleFactor = 1.0; // 텍스트 크기를 저장할 변수
  double maxTextScaleFactor = 2.0; // 텍스트 최대 크기
  double minTextScaleFactor = -2.0; // 텍스트 최소 크기
  List<int> likedProducts = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // 데이터 가져오기
    _checkLoginStatus();
  }

  // 사용자의 로그인 상태를 확인하고 인증 토큰
  Future<void> _checkLoginStatus() async {
    final token = await _loginuser();
    if (token != null) {
      final isValid = await _validateToken(token);
      if (isValid) {
        setState(() {
          authToken = token;
        });
        await _getUserAllergies(token); // 알레르기 정보 가져오기 추가
      } else {
        setState(() {
          authToken = null;
        });
      }
    }
  }

  //로그인한 사용자의 알레르기 가져오기
  Future<void> _getUserAllergies(String token) async {
    try {
      final url = Uri.parse('$baseUrl:3000/loginuser');
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // 알레르기 정보를 가져올 때 따옴표를 제거하여 일반적인 리스트로 변환
        List<String> userAllergies = List<String>.from(data['allergies']);

        if (kDebugMode) {
          print('사용자 알레르기 : $userAllergies');
        }

        // 알레르기 정보를 저장
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('allergies', userAllergies);

        // 상품 알레르기와 사용자 알레르기 일치 여부 확인
        checkAllergies(widget.product!.allergens, userAllergies);
      } else {
        if (kDebugMode) {
          print('Failed to fetch user allergies: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching user allergies: $e');
      }
    }
  }

  //상품과 알레르기가 일치하는 지 확인
  void checkAllergies(String productAllergens, List<String> userAllergies) {
    List<String> productAllergensList = productAllergens.split(' ');

    for (var i = 0; i < productAllergensList.length; i++) {
      var allergen = productAllergensList[i];

      if (userAllergies.contains(allergen)) {
        setState(() {
          hasMatchingAllergy = true;
        });
        if (kDebugMode) {
          print('일치하는 알레르기: $allergen');
        }
        return; // 일치하는 알레르기가 발견되면 더 이상 확인할 필요가 없으므로 반환합니다.
      }
    }
  }

  //로그인 유지하기
  Future<String?> _loginuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    return token;
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:3000/loginuser'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error validating token: $e');
      }
      return false;
    }
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

        // 각 상품의 알레르기 정보를 가져와서 공백을 기준으로 나누고 리스트로 변환
        for (var product in products) {
          List<String> allergiesWithSpaces = product.allergens.split(' ');
          List<String> productAllergens = [];
          for (var item in allergiesWithSpaces) {
            List<String> splitAllergies = item.split(' ');
            productAllergens.addAll(splitAllergies);
          }
          product.allergens;
          productAllergens.join(', '); // 공백 대신 쉼표로 구분하여 다시 합침
          if (kDebugMode) {
            print('상품 알레르기:${product.allergens}');
          }
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF1F2F7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const HomeScreen(
            //         //searchText: '',
            //         ),
            //),
            //);
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 32, top: 8),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                      if (isLiked) {
                        likedProducts.add(widget.product!.id);
                      } else {
                        likedProducts.remove(widget.product!.id);
                      }
                    });
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  iconSize: 28,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                child: SizedBox(
                  width: 250,
                  height: 200,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: _buildImage(
                          context,
                          widget.product!.frontproduct,
                          borderColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 32, bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.zoom_in,
                        color: textScaleFactor > minTextScaleFactor
                            ? const Color(0xFF7C7C7C)
                            : Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          textScaleFactor += 0.5;
                          if (textScaleFactor > maxTextScaleFactor) {
                            textScaleFactor = maxTextScaleFactor;
                          }
                        });
                      },
                      iconSize: 28,
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon:
                          const Icon(Icons.zoom_out, color: Color(0xFF7C7C7C)),
                      onPressed: () {
                        setState(() {
                          textScaleFactor -= 0.5;
                          if (textScaleFactor < minTextScaleFactor) {
                            textScaleFactor = minTextScaleFactor;
                          }
                        });
                      },
                      color: Colors.white,
                      iconSize: 28,
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFDDD7D7),
              thickness: 1.0,
              height: 5.0,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NOText({
                    widget.product!.kategorie,
                    widget.product!.name,
                  }),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 20),
            _buildText({
              '알레르기 식품:': widget.product!.allergens,
            }, textScaleFactor),
            const SizedBox(height: 20),
            hasMatchingAllergy
                ? const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      '사용자와 맞지 않은 상품입니다.',
                      style: TextStyle(
                        backgroundColor: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(height: 40),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

//하트 부분
  // void _toggleLikedStatus(int index) {
  //   setState(() {
  //     if (likedProducts.contains(index)) {
  //       likedProducts.remove(index);
  //     } else {
  //       likedProducts.add(index);
  //     }
  //   });
  // }

  Widget _buildText(Map<String, String> textMap, double textScaleFactor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: textMap.entries.map((entry) {
          return Text(
            '${entry.key} ${entry.value}',
            style: TextStyle(fontSize: 14 * textScaleFactor),
          );
        }).toList(),
      ),
    );
  }

  // 앞에 텍스트 없이 내용만 가져오는 부분
  // ignore: non_constant_identifier_names
  Widget _NOText(Set<String> texts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: texts.map((text) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImage(BuildContext context, String imageUrl,
      {required MaterialColor borderColor}) {
    return GestureDetector(
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
                    imageProvider: NetworkImage(imageUrl),
                    minScale: PhotoViewComputedScale.contained * 1.0,
                    maxScale: PhotoViewComputedScale.covered * 2.0,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Image.network(imageUrl),
    );
  }
}
