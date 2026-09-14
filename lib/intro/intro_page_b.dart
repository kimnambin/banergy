// 인트로 두 번째 페이지("필터링 서비스로 원하는 정보만...")입니다.

import 'package:flutter/material.dart';
import 'package:flutter_banergy/intro/intro_page_scaffold.dart';

class IntroPageB extends StatelessWidget {
  const IntroPageB(this.controller, {super.key});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textSize = screenWidth * 0.10;
    final TextStyle textStyle = TextStyle(
      fontSize: textSize,
      color: const Color(0xFF3F3B3B),
      fontFamily: 'PretendardBold',
    );
    final TextStyle highlightStyle = textStyle.copyWith(
      color: const Color(0xFF03C95B),
    );

    return IntroPageScaffold(
      illustrationAsset: 'images/intropage2.png',
      onNext: () {
        controller.animateToPage(
          2,
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
              TextSpan(text: '필터링 ', style: highlightStyle),
              TextSpan(text: '서비스로', style: textStyle),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Image.asset('images/0006.png', width: 55, height: 50),
                ),
              ),
              TextSpan(text: '개인이', style: textStyle),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Image.asset('images/0009.png', width: 50, height: 50),
                ),
              ),
              const TextSpan(text: '\n'),
              TextSpan(text: '원하는 정보만', style: textStyle),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Image.asset('images/00011.png', width: 50, height: 50),
                ),
              ),
              const TextSpan(text: '\n'),
              TextSpan(text: '빠르게 확인', style: textStyle),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Image.asset('images/0002.png', width: 60, height: 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
