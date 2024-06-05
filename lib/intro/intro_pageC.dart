import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';

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
              padding: const EdgeInsets.only(right: 40.0),
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
                      text: '기술로 \n',
                      style: TextStyle(
                        fontSize: textSize,
                        color: const Color(0xFF3F3B3B),
                        fontFamily: 'PretendardBold',
                      ),
                    ),
                    TextSpan(
                      text: '간편하게\n',
                      style: TextStyle(
                        fontSize: textSize,
                        color: const Color(0xFF3F3B3B),
                        fontFamily: 'PretendardBold',
                      ),
                    ),
                    TextSpan(
                      text: '찾아보는 음식 성분들!',
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
            Image.asset('images/intropage3.png', width: 150, height: 100),
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
            const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
