//찜한걸 보는 화면

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/search_widget.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/product/pd_choice.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_banergy/mainDB.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const MaterialApp(
      home: LPscreen(),
    ),
  );
}

//like + product 라는 뜻
class LPscreen extends StatelessWidget {
  final File? image;

  const LPscreen({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '식품 알레르기 관리 앱',
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

class _HomeScreenState extends State<HomeScreen> {
  //with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const SearchWidget(), // 검색 위젯
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => {
                  //pop으로 하면 오류가 떠서 홈스크린으로 대체
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainpageApp(),
                    ),
                  ),
                }),
      ),
      body: const Expanded(
        child: ProductGrid(),
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
  List<Product> likedProducts = [];
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String? authToken;
  bool isLiked = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    likeData(); // initState에서 데이터를 불러옵니다.
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
        final List<dynamic> likedProductsList =
            json.decode(response.body)['liked_products'];
        likedProducts =
            likedProductsList.map((json) => Product.fromJson(json)).toList();

        // 좋아요 누른 상품들 콘솔창에 보기
        for (var product in likedProducts) {
          if (kDebugMode) {
            print('좋아요 누른 상품들 -> ${product.name}');
          }
        }
        //_updateLiked(); // 좋아요 상태 업데이트
      });
    } else {
      throw Exception('Failed to load liked products');
    }
  }

  // 좋아요 삭제
  Future<void> deleteProduct(Product product) async {
    final url = Uri.parse('$baseUrl:8000/logindb/deletelike');
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
        likedProducts.remove(product);
      });
    } else {
      throw Exception('Failed to unlike product');
    }
  }

  void _toggleLikedStatus(Product product) {
    setState(() {
      if (likedProducts.contains(product)) {
        likedProducts.remove(product); // 이미 좋아요 상태이면 삭제
      } else {
        likedProducts.add(product); // 좋아요 상태가 아니면 추가
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFFFFF);

    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final product = likedProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            _handleProductClick(context, product);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15, // 이미지 높이 제한
                              ),
                              SizedBox(
                                height: 90, // 이미지 높이 제한
                                child: Center(
                                  child: Image.network(
                                    product.frontproduct,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  product.name,
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
                                  product.allergens,
                                  maxLines: 1, // 한줄만 보이게 하는 것
                                  overflow:
                                      TextOverflow.ellipsis, // 넘치는 부분은 ...으로 표시
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              product.isHearted
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              color:
                                  product.isHearted ? Colors.grey : Colors.red,
                            ),
                            onPressed: () {
                              _toggleLikedStatus(product);
                              deleteProduct(product);
                            },
                            iconSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: likedProducts.length,
            ),
          ),
        ],
      ),
    );
  }

// 상품 클릭 시 새로운창에서 상품 정보를 표시하는 함수
  void _handleProductClick(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pd_choice(product: product),
      ),
    );
  }
}
