//앱바에서 검색한 후 보여지는 부분

import 'package:flutter/material.dart';

import 'package:flutter_banergy/appbar/search_widget.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/product/productGrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_banergy/main_category/Drink.dart';
import 'package:flutter_banergy/main_category/Sandwich.dart';
import 'package:flutter_banergy/main_category/bigsnacks.dart';
import 'package:flutter_banergy/main_category/gimbap.dart';
import 'package:flutter_banergy/main_category/instantfood.dart';
import 'package:flutter_banergy/main_category/lunchbox.dart';
import 'package:flutter_banergy/main_category/ramen.dart';
import 'package:flutter_banergy/main_category/snacks.dart';

class SearchScreen extends StatefulWidget {
  final String searchText;

  const SearchScreen({super.key, required this.searchText});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String searchText;
  late List<Product> products = [];
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  void initState() {
    super.initState();
    searchText = widget.searchText;
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainpageApp()),
              );
            },
          ),
          actions: const [
            Flexible(
              child: SearchWidget(),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 220,
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
          ],
        ));
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
