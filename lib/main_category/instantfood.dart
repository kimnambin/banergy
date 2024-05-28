import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/product/productGrid.dart';
import 'package:flutter_banergy/product/product_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/main_category/bigsnacks.dart';
import 'package:flutter_banergy/main_category/gimbap.dart';
import 'package:flutter_banergy/main_category/snacks.dart';
import 'package:flutter_banergy/main_category/drink.dart';
import 'package:flutter_banergy/main_category/ramen.dart';
import 'package:flutter_banergy/main_category/lunchbox.dart';
import 'package:flutter_banergy/main_category/Sandwich.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InstantfoodScreen extends StatefulWidget {
  const InstantfoodScreen({super.key});

  @override
  State<InstantfoodScreen> createState() => _InstantfoodScreenState();
}

class _InstantfoodScreenState extends State<InstantfoodScreen> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
  List<Product> likedProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch); // 검색어가 변경될 때마다 검색
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch); // 검색어 변경시 끝
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    // 검색 실행
    _performSearch();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          searchText: _searchController.text,
        ),
      ),
    );
  }

  void _toggleLikedStatus(Product product) {
    setState(() {
      if (likedProducts.contains(product)) {
        likedProducts.remove(product);
      } else {
        likedProducts.add(product);
      }
    });
  }

  void _showLikedProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LikedProductsWidget(likedProducts: likedProducts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 200.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontFamily: 'PretendardBold',
                    ),
                    decoration: InputDecoration(
                      hintText: '궁금했던 상품 정보를 검색해보세요',
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 15, bottom: 13),
                      suffixIcon: IconButton(
                        onPressed: _onSearchPressed,
                        icon: const Icon(
                          Icons.search,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(
                height: 120,
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20), // 위아래 여백을 조절
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
                        _navigateToScreen(
                          context,
                          category["name"]!,
                        );
                      },
                      child: SizedBox(
                        width: 100,
                        child: Container(
                          margin: const EdgeInsets.all(20), // 상하 여백 삭제
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/${category["image"]}',
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                category["name"]!,
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
          ),
          const SliverFoodGrid(), // SliverGrid로 변경
        ],
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

//여기가 검색 결과
  void _performSearch() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _products.clear();
      });
      return;
    }

    setState(() {});

    final response = await http.get(Uri.parse('$baseUrl:8000/?query=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _products = data
            .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
            .toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }
}

// SliverFoodGrid 클래스
class SliverFoodGrid extends StatefulWidget {
  const SliverFoodGrid({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SliverFoodGridState createState() => _SliverFoodGridState();
}

class _SliverFoodGridState extends State<SliverFoodGrid> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // initState에서 데이터를 불러옵니다.
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:8000/?query=패스트푸드'),
      );
      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> productList = json.decode(response.body);
          products = productList.map((item) => Product.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load data: $error'),
        ),
      );
    }
  }

  // 상품 그리드
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
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
        childCount: products.length,
      ),
    );
  }

// 상품 클릭 시 새로운 창에서 상품 정보를 표시하는 함수
  void _handleProductClick(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pdScreen(product: product),
      ),
    );
  }
}

// 검색 결과 화면
// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final String searchText;

  SearchScreen({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색결과 "$searchText"'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _fetchSearchResults(searchText),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 2개의 열을 표시
                crossAxisSpacing: 10.0, // 열 사이의 간격
                mainAxisSpacing: 10.0, // 행 사이의 간격
                childAspectRatio: 0.75, // 아이템의 가로 세로 비율
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              pdScreen(product: products[index]),
                        ),
                      );
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
                            fontFamily: 'PretendardRegular',
                          ),
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
        },
      ),
    );
  }

  Future<List<Product>> _fetchSearchResults(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl:8000/?query=$query'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Product>((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
