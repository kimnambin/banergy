import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_login.dart';

class IntroPageC extends StatelessWidget {
  PageController controller;
  IntroPageC(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              '밴러지',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(
              height: 60,
            ),
            Image.asset('images/000.jpeg', width: 200, height: 200),
            Text(
              'OCR, 바코드 기술로 간편하게\n찾아보는 음식 성분들!',
              style: TextStyle(fontSize: 13),
            ),
            Image.asset('images/intropage3.png', width: 100, height: 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginApp()), //HomeScreen부분을 수정하기
                    );
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
