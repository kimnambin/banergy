import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_firstapp.dart';

// ignore: must_be_immutable
class IntroPageC extends StatelessWidget {
  PageController controller;
  IntroPageC(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.09;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'OCR ',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF03C95B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: ',',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B), // 검정색
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: ' 바코드 ',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF03C95B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      TextSpan(
                        text: '기술로',
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
                            'images/0008.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: '간편하게',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Image.asset(
                            'images/0005.png',
                            width: 70,
                            height: 60,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Image.asset(
                            'images/0004.png',
                            width: 70,
                            height: 60,
                          ),
                        ),
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: '찾아보는 음식 성분들!',
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF3F3B3B),
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                      const TextSpan(text: '\n'),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Image.asset(
                            'images/0007.png',
                            width: 90,
                            height: 70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 10),
              Image.asset('images/intropage3.png', width: 150, height: 100),
              const Spacer(),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FirstApp()));
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
