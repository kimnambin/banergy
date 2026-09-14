// 카테고리 화면에서 검색했을 때 보여주는 검색 결과 화면입니다.

import 'package:flutter/material.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/product/product_detail.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'product_query_service.dart';

class CategorySearchScreen extends StatelessWidget {
  CategorySearchScreen({super.key, required this.searchText});

  final String searchText;
  final ProductQueryService _service = ProductQueryService(
    baseUrl: dotenv.env['BASE_URL'] ?? 'http://localhost',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색결과 "$searchText"'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _service.fetchProducts(searchText),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Product>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<Product> products = snapshot.data ?? const <Product>[];
          if (products.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final Product product = products[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Column(
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
                      const SizedBox(height: 8.0),
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
              );
            },
          );
        },
      ),
    );
  }
}
