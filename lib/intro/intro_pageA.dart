import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroPageA extends StatelessWidget {
  PageController controller;
  IntroPageA(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.10;

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
                          color: Color(0xFF03C95B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '로\n',
                        style: TextStyle(
                          fontSize: textSize,
                          color: Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '마음대로 먹지도\n',
                        style: TextStyle(
                          fontSize: textSize,
                          color: Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '못하는 당신을 위한\n',
                        style: TextStyle(
                          fontSize: textSize,
                          color: Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '맞춤형 관리 앱',
                        style: TextStyle(
                          fontSize: textSize,
                          color: Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 300),
              Image.asset('images/intropage1.png', width: 150, height: 100),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 100,
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
                      child: Text(
                        '다음',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PretendardSemiBold',
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
