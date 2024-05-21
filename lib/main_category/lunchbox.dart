import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/search_widget.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/main_category/IconSlider.dart';
import 'package:flutter_banergy/product/product_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_banergy/mainDB.dart';

class LunchboxScreen extends StatelessWidget {
  const LunchboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Flexible(
            child: SearchWidget(), // Flexible 추가
          ),
        ],
      ),
      body: const Column(
        children: [
          // 여기에 아이콘 슬라이드를 넣어줍니다.
          IconSlider(),
          SizedBox(height: 16),
          Expanded(
            child: DessertGrid(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class DessertGrid extends StatefulWidget {
  const DessertGrid({super.key});

  @override
  _DessertGridState createState() => _DessertGridState();
}

class _DessertGridState extends State<DessertGrid> {
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // initState에서 데이터를 불러옵니다.
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://192.168.112.174:8000/?query=밀키트'),
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
