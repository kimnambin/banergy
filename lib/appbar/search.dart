//앱바에서 검색한 후 보여지는 부분

import 'package:flutter/material.dart';
//import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/appbar/search_widget.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/mypage/mypage_filtering_allergies.dart';
import 'package:flutter_banergy/product/like_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_banergy/product/product_detail.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_banergy/main_category/Drink.dart';
//import 'package:flutter_banergy/main_category/Sandwich.dart';
import 'package:flutter_banergy/main_category/bigsnacks.dart';
//import 'package:flutter_banergy/main_category/gimbap.dart';
import 'package:flutter_banergy/main_category/instantfood.dart';
//import 'package:flutter_banergy/main_category/lunchbox.dart';
import 'package:flutter_banergy/main_category/ramen.dart';
import 'package:flutter_banergy/main_category/snacks.dart';

class SearchScreen extends StatefulWidget {
  final String searchText;

  const SearchScreen({super.key, required this.searchText});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _SearchScreenState createState() => _SearchScreenState(searchText);
}

class _SearchScreenState extends State<SearchScreen> {
  late String searchText;
  late List<Product> products = [];
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  _SearchScreenState(this.searchText); // 생성자 수정

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('$baseUrl:8000/?query=$searchText'),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const SearchWidget(), // 검색 위젯
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                builder: (context) => const FilteringPage(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: () => LPscreen,
          ),
        ],
      ),
      body: Column(
        children: [
          // 공간추가, 카테고리 리스트
          SizedBox(
            height: 120, // 라벨을 포함하기에 충분한 높이 설정
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
          Expanded(
            child: SerachGrid(products: products), // 상품 그리드
          ),
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
      // case '김밥':
      //   screen = const GimbapScreen();
      //   break;
      // case '도시락':
      //   screen = const LunchboxScreen();
      //   break;
      // case '샌드위치':
      //   screen = const SandwichScreen();
      //   break;
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
}

class SerachGrid extends StatefulWidget {
  final List<Product> products;

  const SerachGrid({super.key, required this.products});

  @override
  State<SerachGrid> createState() => _SerachGridState();
}

class _SerachGridState extends State<SerachGrid> {
  List<int> likedProducts = []; //하트 담을 리스트
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFFFFF);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
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
            child: InkWell(
              onTap: () {
                _handleProductClick(context, product);
              },
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
                          height: 90,
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
                      icon: likedProducts.contains(index)
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                      onPressed: () {
                        _toggleLikedStatus(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleLikedStatus(int index) {
    setState(() {
      if (likedProducts.contains(index)) {
        likedProducts.remove(index);
      } else {
        likedProducts.add(index);
      }
    });
  }

  // 상품 클릭 시 pdScreen에서 보여줌
  void _handleProductClick(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pdScreen(product: product),
      ),
    );
  }
}
