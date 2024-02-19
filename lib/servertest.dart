import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/mainDB.dart';
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
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 그리드의 열 수를 설정합니다.
            mainAxisSpacing: 8.0, // 주 축(수직) 간격을 설정합니다.
            crossAxisSpacing: 8.0, // 교차 축(수평) 간격을 설정합니다.
            childAspectRatio: 0.75, // 그리드 아이템의 가로:세로 비율을 설정합니다.
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4, // 그림자 효과를 추가합니다.
              child: Padding(
                padding: EdgeInsets.all(8.0), // 아이템 주위에 간격을 추가합니다.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        products[index].frontproduct,
                        fit: BoxFit.cover, // 이미지를 늘리거나 채우도록 설정합니다.
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(products[index].name),
                    const SizedBox(height: 4.0),
                    Text(products[index].allergens),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
