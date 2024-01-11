import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroPageA extends StatelessWidget {
  PageController controller;
  IntroPageA(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '밴러지',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            Image.asset('images/000.jpeg', width: 200, height: 200),
            Text(
              '알러지로 마음대로 먹지도\n못하는 당신을 위한 맞춤형\n관리 앱',
              style: TextStyle(fontSize: 13),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    controller.animateToPage(1,
                        duration: Duration(milliseconds: 700),
                        curve: Curves.easeOut);
                  },
                  child: Text(
                    '다음',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
