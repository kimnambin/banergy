// 인트로 첫 번째 페이지("알레르기로 마음대로 먹지도 못하는...")입니다.

import 'package:flutter/material.dart';
import 'package:flutter_banergy/intro/intro_page_scaffold.dart';

class IntroPageA extends StatelessWidget {
  const IntroPageA(this.controller, {super.key});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textSize = screenWidth * 0.1;
    final TextStyle textStyle = TextStyle(
      fontSize: textSize,
      color: const Color(0xFF3F3B3B),
      fontFamily: 'PretendardBold',
    );
    final TextStyle highlightStyle = textStyle.copyWith(
      color: const Color(0xFF03C95B),
    );

    return IntroPageScaffold(
      illustrationAsset: 'images/intropage1.png',
      onNext: () {
        controller.animateToPage(
          1,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
        );
      },
      description: Padding(
        padding: const EdgeInsets.only(right: 40.0),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            children: [
              TextSpan(text: '알레르기', style: highlightStyle),
              TextSpan(text: '로', style: textStyle),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Image.asset('images/00012.png', width: 50, height: 45),
                ),
              ),
              const TextSpan(text: '\n'),
              TextSpan(text: '마음대로 먹지도', style: textStyle),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Image.asset('images/00010.png', width: 60, height: 60),
                ),
              ),
              TextSpan(text: '못하는 당신을 위한\n', style: textStyle),
              TextSpan(text: '맞춤형 관리 앱', style: textStyle),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Image.asset('images/0001.png', width: 80, height: 60),
                ),
              ),
              const TextSpan(text: '\n'),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Image.asset('images/0003.png', width: 80, height: 70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
