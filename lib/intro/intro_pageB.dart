import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IntroPageB extends StatelessWidget {
  PageController controller;
  IntroPageB(this.controller, {super.key});

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
                padding: const EdgeInsets.only(right: 80.0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '필터링 ',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF03C95B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '서비스로\n',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B), // 검정색
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '개인이\n',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '원하는 정보만\n',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '빠르게 확인',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 10),
              Image.asset('images/intropage2.png', width: 150, height: 100),
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
                      controller.animateToPage(2,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
