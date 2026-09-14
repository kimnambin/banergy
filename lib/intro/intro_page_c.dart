// 인트로 세 번째 페이지("OCR, 바코드 기술로 간편하게...")입니다.

import 'package:flutter/material.dart';
import 'package:flutter_banergy/intro/intro_page_scaffold.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';

class IntroPageC extends StatelessWidget {
  const IntroPageC(this.controller, {super.key});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textSize = screenWidth * 0.09;
    final TextStyle textStyle = TextStyle(
      fontSize: textSize,
      color: const Color(0xFF3F3B3B),
      fontFamily: 'PretendardBold',
    );
    final TextStyle highlightStyle = textStyle.copyWith(
      color: const Color(0xFF03C95B),
    );

    return IntroPageScaffold(
      illustrationAsset: 'images/intropage3.png',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstApp()),
        );
      },
      description: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            children: [
              TextSpan(text: 'OCR ', style: highlightStyle),
              TextSpan(text: ',', style: textStyle),
              TextSpan(text: ' 바코드 ', style: highlightStyle),
              TextSpan(text: '기술로', style: textStyle),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Image.asset('images/0008.png', width: 50, height: 50),
                ),
              ),
              TextSpan(text: '간편하게', style: textStyle),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.asset('images/0005.png', width: 70, height: 60),
                ),
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.asset('images/0004.png', width: 70, height: 60),
                ),
              ),
              const TextSpan(text: '\n'),
              TextSpan(text: '찾아보는 음식 성분들!', style: textStyle),
              const TextSpan(text: '\n'),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Image.asset('images/0007.png', width: 90, height: 70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
