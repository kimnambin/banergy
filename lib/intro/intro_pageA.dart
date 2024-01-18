import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IntroPageA extends StatelessWidget {
  PageController controller;
  IntroPageA(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
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
                '알러지로 마음대로 먹지도\n못하는 당신을 위한 맞춤형\n관리 앱',
                style: TextStyle(fontSize: 18),
              ),
              Image.asset('images/intropage1.png', width: 100, height: 100),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.animateToPage(1,
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
      ),
    );
  }
}
