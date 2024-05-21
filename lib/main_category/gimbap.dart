import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main_category/ramen.dart';
import 'package:flutter_banergy/product/product_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/main_category/bigsnacks.dart';
import 'package:flutter_banergy/main_category/snacks.dart';
import 'package:flutter_banergy/main_category/Drink.dart';
import 'package:flutter_banergy/main_category/instantfood.dart';
import 'package:flutter_banergy/main_category/lunchbox.dart';
import 'package:flutter_banergy/main_category/Sandwich.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GimbapScreen extends StatelessWidget {
  const GimbapScreen({super.key});

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
                    style: const TextStyle(
                      fontFamily: 'PretendardBold',
                    ),
                    decoration: InputDecoration(
                      hintText: '궁금했던 상품 정보를 검색해보세요',
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 15, bottom: 13),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // 검색 버튼 클릭 시 동작
                        },
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
          const DessertGrid(), // SliverGrid로 변경
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
}

class DessertGrid extends StatefulWidget {
  const DessertGrid({super.key});

  @override
  _DessertGridState createState() => _DessertGridState();
}

class _DessertGridState extends State<DessertGrid> {
  late List<Product> products = [];
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  void initState() {
    super.initState();
    fetchData(); // initState에서 데이터를 불러옵니다.
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('$baseUrl:8000/?query=김밥'),
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
