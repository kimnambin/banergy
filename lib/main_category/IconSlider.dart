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
          IconItem(icon: Icons.ramen_dining, label: '라면'),
          IconItem(icon: Icons.local_cafe, label: '음료'),
          IconItem(icon: Icons.dining, label: '김밥류'), //김밥 아이콘 필요
          IconItem(icon: Icons.dining, label: '도시락'), //도시락 아이콘 필요
          IconItem(icon: Icons.cookie, label: '과자류'), //과자
          IconItem(icon: Icons.dining, label: '간식류'), // 간식류
          IconItem(icon: Icons.fastfood, label: '즉석식품'),
          IconItem(icon: Icons.food_bank, label: '샌드위치'),
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
      case '라면':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ramenScreen()),
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
          MaterialPageRoute(builder: (context) => const gimbapScreen()),
        );
        break;
      case '도시락':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const lunchboxScreen()),
        );
        break;
      case '과자류':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const bigsnacksScreen()),
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
          MaterialPageRoute(builder: (context) => const instantfoodScreen()),
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
