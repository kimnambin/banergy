import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IntroPageA extends StatelessWidget {
  PageController controller;
  IntroPageA(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.1;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '알레르기',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF03C95B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '로',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Image.asset(
                            'images/00012.png',
                            width: 50, // Adjust the width and height as needed
                            height: 45,
                          ),
                        ),
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: '마음대로 먹지도',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Image.asset(
                            'images/00010.png',
                            width: 60, // Adjust the width and height as needed
                            height: 60,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: '못하는 당신을 위한\n',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '맞춤형 관리 앱',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Image.asset(
                            'images/0001.png',
                            width: 80, // Adjust the width and height as needed
                            height: 60,
                          ),
                        ),
                      ),
                      const TextSpan(text: '\n'),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Image.asset(
                            'images/0003.png',
                            width: 80, // Adjust the width and height as needed
                            height: 70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 10), // 유연한 공간 추가
              Image.asset('images/intropage1.png', width: 150, height: 100),
              const Spacer(), // 유연한 공간 추가
              SizedBox(
                width: double.infinity,
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF03C95B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      controller.animateToPage(1,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOut);
                    },
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PretendardSemiBold',
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // 하단 여백 추가
            ],
          ),
        ),
      ),
    );
  }
}
