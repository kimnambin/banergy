import 'package:flutter/material.dart';
import 'package:flutter_banergy/appbar/home_search_widget.dart';
import 'package:flutter_banergy/bottombar.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Basket extends StatefulWidget {
  const Basket(BuildContext context, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> with SingleTickerProviderStateMixin {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  String? authToken; // 사용자의 인증 토큰

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SearchWidget(), // 검색 위젯
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Text('찜 화면 임시 구현'),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
