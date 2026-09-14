// 상품 목록 화면입니다.

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/bottombar.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/mypage/mypage_filtering_allergies.dart';
import 'package:flutter_banergy/product/pd_choice.dart';
import 'package:flutter_banergy/product/product_detail.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  List<Product> products = <Product>[];
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final List<Product> likedProducts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final http.Response response = await http.get(
      Uri.parse('$_baseUrl:8000/'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    final List<dynamic> rawProducts =
        json.decode(response.body) as List<dynamic>;
    setState(() {
      products = rawProducts
          .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                  onPressed: () => _showLikedProducts(context),
                ),
              ],
            ),
          ),
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final Product product = products[index];
              return Card(
                child: InkWell(
                  onTap: () => _handleProductClick(context, product),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 110,
                        child: Center(
                          child: Image.network(
                            product.frontproduct,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PretendardRegular',
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(product.allergens),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: products.length,
          ),
        ),
      ],
    );
  }

  void _handleProductClick(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}

//좋아요 누른걸 보여주는 부분
class LikedProductsWidget extends StatelessWidget {
  final List<Product> likedProducts;

  const LikedProductsWidget({super.key, required this.likedProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottomNavigationBar: const BottomNavBar(),
        body: Container(
          color: Colors.white,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: likedProducts.length,
            itemBuilder: (context, index) {
              final product = likedProducts[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LikedProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Image.network(
                                product.frontproduct,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4.0),
                                Text(product.allergens),
                              ],
                            ),
                          ),
                        ],
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
                ),
              );
            },
          ),
        ));
  }
}
