//아이콘 슬라이더 미들웨어

import 'package:flutter/material.dart';
import 'package:flutter_banergy/main_category/bigsnacks.dart';
import 'package:flutter_banergy/main_category/gimbap.dart';
import 'package:flutter_banergy/main_category/snacks.dart';
import 'package:flutter_banergy/main_category/Drink.dart';
import 'package:flutter_banergy/main_category/instantfood.dart';
import 'package:flutter_banergy/main_category/ramen.dart';
import 'package:flutter_banergy/main_category/lunchbox.dart';
import 'package:flutter_banergy/main_category/Sandwich.dart';

class IconSlider extends StatelessWidget {
  const IconSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          IconItem(imagePath: 'images/noodle.png', label: '라면'),
          IconItem(imagePath: 'images/drinkcan.png', label: '음료'),
          //IconItem(imagePath: 'images/oni.png', label: '김밥류'),
          IconItem(imagePath: 'images/onigiri.png', label: '도시락'),
          IconItem(imagePath: 'images/snackchip.png', label: '과자류'),
          IconItem(imagePath: 'images/candy.png', label: '간식류'),
          IconItem(imagePath: 'images/fastfood.png', label: '즉석식품'),
          IconItem(imagePath: 'images/sandwich.png', label: '샌드위치'),
        ],
      ),
    );
  }
}

class IconItem extends StatefulWidget {
  final String imagePath;
  final String label;

  const IconItem({Key? key, required this.imagePath, required this.label})
      : super(key: key);

  @override
  _IconItemState createState() => _IconItemState();
}

class _IconItemState extends State<IconItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          _handleIconTap(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.imagePath,
                width: 36,
                height: 36,
                color: isHovered ? Colors.grey : Colors.black,
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
      case '라면':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RamenScreen()),
        );
        break;
      case '음료':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DrinkScreen()),
        );
        break;
      case '김밥류':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GimbapScreen()),
        );
        break;
      case '도시락':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LunchboxScreen()),
        );
        break;
      case '과자류':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BigsnacksScreen()),
        );
        break;
      case '간식류':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const snacksScreen()),
        );
        break;
      case '즉석식품':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InstantfoodScreen()),
        );
        break;
      case '샌드위치':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SandwichScreen()),
        );
        break;
    }
  }
}
