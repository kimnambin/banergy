// 찜(좋아요)한 상품을 보는 화면입니다.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/product_search_bar.dart';
import 'package:flutter_banergy/common/auth_service.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/product/pd_choice.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_banergy/mainDB.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    const MaterialApp(
      home: LPscreen(),
    ),
  );
}

/// LPscreen: like + product(좋아요한 상품)라는 뜻.
class LPscreen extends StatelessWidget {
  const LPscreen({super.key});

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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const ProductSearchBar(), // 검색 위젯
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
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  late final AuthService _authService = AuthService(baseUrl: _baseUrl);

  List<Product> likedProducts = [];
  String? authToken;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 사용자의 로그인 상태를 확인하고, 로그인되어 있으면 좋아요한 상품 목록을 가져옵니다.
  Future<void> _checkLoginStatus() async {
    final String? token = await _authService.loadValidAuthToken();
    if (!mounted) return;
    setState(() => authToken = token);
    if (token != null) {
      likeData();
    }
  }

  // 좋아요 누른 상품들
  Future<void> likeData() async {
    if (authToken == null) return;

    final response = await http.get(
      Uri.parse('$_baseUrl:8000/logindb/getlike'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawLikedProducts =
          (body['liked_products'] as List<dynamic>?) ?? const <dynamic>[];
      if (!mounted) return;
      setState(() {
        likedProducts = rawLikedProducts
            .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      });
    } else {
      throw Exception('Failed to load liked products');
    }
  }

  // 좋아요 삭제
  Future<void> deleteProduct(Product product) async {
    final url = Uri.parse('$_baseUrl:8000/logindb/deletelike');
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
        builder: (context) => LikedProductDetailScreen(product: product),
      ),
    );
  }
}
