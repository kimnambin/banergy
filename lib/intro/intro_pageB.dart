import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IntroPageB extends StatelessWidget {
  PageController controller;
  IntroPageB(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Text(
              '밴러지',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(
              height: 60,
            ),
            Image.asset('images/000.jpeg', width: 200, height: 200),
            const Text(
              '필터링 서비스로 개인이\n원하는 정보만 빠르게 확인!',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            Image.asset('images/intropage2.png', width: 100, height: 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    controller.animateToPage(2,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOut);
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    '다음',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
