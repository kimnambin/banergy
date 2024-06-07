import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/search_widget.dart';
import 'package:flutter_banergy/product/product_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_banergy/mainDB.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const MaterialApp(
      home: MainpageApp2(),
    ),
  );
}

class MainpageApp2 extends StatelessWidget {
  final File? image;

  const MainpageApp2({super.key, this.image});

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
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Flexible(
            child: SearchWidget(), // Flexible 추가
          ),
        ],
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
  late List<Product> products = [];
  List<Product> likedProducts = [];
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  void initState() {
    super.initState();
    fetchData(); // initState에서 데이터를 불러옵니다.
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('$baseUrl:8000/'),
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

  void _toggleLikedStatus(Product product) {
    setState(() {
      if (likedProducts.contains(product)) {
        likedProducts.remove(product);
      } else {
        likedProducts.add(product);
      }
    });
  }

  bool isLiked = true;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  _handleProductClick(context, products[index]);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 110, // 이미지 높이 제한
                      child: Center(
                        child: Container(
                          color: Colors.white, // 하얀색 배경
                          child: Image.network(
                            products[index].frontproduct,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        products[index].name,
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
                        products[index].allergens,
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
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    // 좋아요 취소 기능을 추가할 수 있음
                  },
                ),
              ),
            ],
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
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('카테고리: ${product.kategorie}'),
                Text('이름: ${product.name}'),
                Image.network(
                  product.frontproduct,
                  fit: BoxFit.cover,
                ),
                Image.network(
                  product.backproduct,
                  fit: BoxFit.cover,
                ),
                Text('알레르기 식품: ${product.allergens}'),
              ],
            ),
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

// 상품 클릭 시 새로운창에서 상품 정보를 표시하는 함수
void _handleProductClick(BuildContext context, Product product) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => pdScreen(product: product),
    ),
  );
}
