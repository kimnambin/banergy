import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // 앱이 시작될 때 데이터를 불러옵니다.
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/')); // Flask 앱의 루트 URL로 GET 요청을 보냅니다.
    if (response.statusCode == 200) {
      setState(() {
        // JSON 데이터를 Product 객체로 변환하여 리스트에 추가합니다.
        final List<dynamic> productList = json.decode(response.body);
        products = productList.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(products[index].name),
              subtitle: Text(products[index].barcode),
              leading: products[index].image1.isNotEmpty
                  ? Image.network(products[index].image1)
                  : Container(), // 이미지가 없는 경우 빈 컨테이너를 표시합니다.
            );
          },
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String barcode;
  final String name;
  final String category;
  final String image1;
  final String image2;
  final String allergens;

  Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.category,
    required this.image1,
    required this.image2,
    required this.allergens,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      barcode: json['barcode'],
      name: json['name'],
      category: json['category'],
      image1: json['image1'],
      image2: json['image2'],
      allergens: json['allergens'],
    );
  }
}
