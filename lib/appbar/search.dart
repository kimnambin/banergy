//앱바에서 검색한 후 보여지는 부분

import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/appbar/search_widget.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_banergy/product/product_detail.dart';

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
      Uri.parse('http://192.168.112.174:8000/?query=$searchText'),
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
            child: SearchWidget(),
          ),
        ],
      ),
      body: SerachGrid(products: products),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class SerachGrid extends StatefulWidget {
  final List<Product> products;

  const SerachGrid({super.key, required this.products});

  @override
  State<SerachGrid> createState() => _SerachGridState();
}

class _SerachGridState extends State<SerachGrid> {
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
                  child: Center(
                    child: Image.network(
                      widget.products[index].frontproduct,
                      fit: BoxFit.cover,
                    ),
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
