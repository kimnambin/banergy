import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/main_category/bigsnacks.dart';
import 'package:flutter_banergy/main_category/drink.dart';
import 'package:flutter_banergy/main_category/gimbap.dart';
import 'package:flutter_banergy/main_category/instantfood.dart';
import 'package:flutter_banergy/main_category/lunchbox.dart';
import 'package:flutter_banergy/main_category/ramen.dart';
import 'package:flutter_banergy/mypage/mypage_filtering_allergies.dart';
import 'package:flutter_banergy/product/product_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_banergy/mainDB.dart';
import 'package:flutter_banergy/main_category/snacks.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_banergy/product/pd_choice.dart';

class SandwichScreen extends StatefulWidget {
  const SandwichScreen({super.key});

  @override
  State<SandwichScreen> createState() => _SandwichScreenState();
}

class _SandwichScreenState extends State<SandwichScreen> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> likedProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch);
    fetchData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    _performSearch();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          searchText: _searchController.text,
        ),
      ),
    );
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

  void _showLikedProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LikedProductsWidget(likedProducts: likedProducts),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl:8000/?query=샌드위치'));
      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> productList = json.decode(response.body);
          _products =
              productList.map((item) => Product.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load data: $error'),
        ),
      );
    }
  }

  void _performSearch() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _products.clear();
      });
      return;
    }

    final response = await http.get(Uri.parse('$baseUrl:8000/?query=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _products =
            data.map<Product>((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
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
        screen = const SnacksScreen();
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
                    controller: _searchController,
                    style: const TextStyle(
                      fontFamily: 'PretendardBold',
                    ),
                    decoration: InputDecoration(
                      hintText: '궁금했던 상품 정보를 검색해보세요',
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 15, bottom: 13),
                      suffixIcon: IconButton(
                        onPressed: _onSearchPressed,
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
            actions: [
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
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(
                height: 120,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
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
          SliverFoodGrid(
            products: _products,
            likedProducts: likedProducts,
            toggleLikedStatus: _toggleLikedStatus,
            showLikedProducts: _showLikedProducts,
          ),
        ],
      ),
    );
  }
}

class SliverFoodGrid extends StatelessWidget {
  final List<Product> products;
  final List<Product> likedProducts;
  final Function(Product) toggleLikedStatus;
  final Function(BuildContext) showLikedProducts;

  const SliverFoodGrid({
    super.key,
    required this.products,
    required this.likedProducts,
    required this.toggleLikedStatus,
    required this.showLikedProducts,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            child: InkWell(
              onTap: () {
                _handleProductClick(context, products[index]);
              },
              child: Stack(
                children: [
                  Column(
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index].name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4.0),
                            Text(products[index].allergens),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: likedProducts.contains(products[index])
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                      onPressed: () {
                        toggleLikedStatus(products[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: products.length,
      ),
    );
  }

  void _handleProductClick(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pdScreen(product: product),
      ),
    );
  }
}

class LikedProductsWidget extends StatelessWidget {
  final List<Product> likedProducts;

  const LikedProductsWidget({super.key, required this.likedProducts});

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
      ),
      body: GridView.builder(
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
                    builder: (context) => pd_choice(product: product),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  final String searchText;

  const SearchScreen({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색결과 "$searchText"'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _fetchSearchResults(searchText),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              pdScreen(product: products[index]),
                        ),
                      );
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(products[index].allergens),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Product>> _fetchSearchResults(String query) async {
    String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final response = await http.get(
      Uri.parse('$baseUrl:8000/?query=$query'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Product>((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
