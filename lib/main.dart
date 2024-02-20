import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/BottomNavBar.dart';
import 'package:flutter_banergy/appbar/SearchWidget.dart';
import 'package:flutter_banergy/main_category/Cake.dart';
import 'package:flutter_banergy/main_category/Dessert.dart';
import 'package:flutter_banergy/main_category/Drink.dart';
import 'package:flutter_banergy/main_category/Fastfood.dart';
import 'package:flutter_banergy/main_category/Food.dart';
import 'package:flutter_banergy/main_category/Mealkit.dart';
import 'package:flutter_banergy/main_category/Sandwich.dart';
import 'package:http/http.dart' as http;
import '../mypage/mypage.dart';
import 'dart:io';
import 'package:flutter_banergy/mainDB.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MainpageApp(),
    ),
  );
}

class MainpageApp extends StatelessWidget {
  final File? image;

  const MainpageApp({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '식품 알레르기 관리 앱',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 50, 160, 107),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            child: ProductGrid(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class IconSlider extends StatelessWidget {
  const IconSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          IconItem(icon: Icons.fastfood, label: 'Fast Food'),
          IconItem(icon: Icons.cookie, label: 'Dessert'),
          IconItem(icon: Icons.bakery_dining, label: 'Sandwich'),
          IconItem(icon: Icons.lunch_dining, label: 'Food'),
          IconItem(icon: Icons.cake, label: 'Cake'),
          IconItem(icon: Icons.local_cafe, label: 'Drink'),
          IconItem(icon: Icons.food_bank, label: 'MealKit'),
        ],
      ),
    );
  }
}

class IconItem extends StatefulWidget {
  final IconData icon;
  final String label;

  const IconItem({super.key, required this.icon, required this.label});

  @override
  _IconItemState createState() => _IconItemState();
}

class _IconItemState extends State<IconItem> {
  bool isHovered = false; // 아이콘 위에 마우스 커서가 올려졌는지 여부를 관리하는 변수

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true; // 아이콘이 마우스 커서 위에 있을 때 상태를 변경합니다.
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false; // 아이콘이 마우스 커서 밖으로 나갈 때 상태를 변경합니다.
        });
      },
      child: GestureDetector(
        onTap: () {
          // 아이콘을 탭했을 때의 동작
          _handleIconTap(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 36,
                color: isHovered
                    ? Colors.grey
                    : Colors.black, // 마우스 커서 상태에 따라 색상을 변경합니다.
              ),
              const SizedBox(height: 4),
              Text(widget.label),
            ],
          ),
        ),
      ),
    );
  }

  void _handleIconTap(BuildContext context) {
    switch (widget.label) {
      case 'Fast Food':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FastfoodScreen()),
        );
        break;
      case 'Dessert':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DessertScreen()),
        );
        break;
      case 'Sandwich':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SandwichScreen()),
        );
        break;
      case 'Food':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FoodScreen()),
        );
        break;
      case 'Cake':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CakeScreen()),
        );
        break;
      case 'Drink':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DrinkScreen()),
        );
        break;
      case 'MealKit':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MealkitScreen()),
        );
        break;
    }
  }
}

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // initState에서 데이터를 불러옵니다.
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://10.55.4.107:8000/'),
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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              _handleProductClick(context, products[index]);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    products[index].frontproduct,
                    fit: BoxFit.cover,
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
