//앱바에서 검색한 후 보여지는 부분

import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/SearchWidget.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/mypage/mypage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  final String searchText;

  const SearchScreen({super.key, required this.searchText});

  @override
  _SearchScreenState createState() => _SearchScreenState(searchText);
}

class _SearchScreenState extends State<SearchScreen> {
  late String searchText;
  late List<Product> products = [];

  _SearchScreenState(this.searchText); // 생성자 수정

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://10.55.4.107:8000/?query=$searchText'),
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
        actions: const [
          Flexible(
            child: SearchWidget(), // Flexible 추가
          ),
        ],
      ),
      body: serachGrid(products: products),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class serachGrid extends StatefulWidget {
  final List<Product> products;

  const serachGrid({super.key, required this.products});

  @override
  State<serachGrid> createState() => _serachGridState();
}

class _serachGridState extends State<serachGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              _handleProductClick(context, widget.products[index]);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    widget.products[index].frontproduct,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.products[index].name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(widget.products[index].allergens),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleProductClick(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('상품 정보'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('카테고리: ${product.kategorie}'),
              Text('이름: ${product.name}'),
              Text('정면 이미지: ${product.frontproduct}'),
              Text('후면 이미지: ${product.backproduct}'),
              Text('알레르기 식품: ${product.allergens}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
