import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/000.jpeg', width: 200, height: 200),
                const Text(
                  '밴러지',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '알러지로 마음대로 먹지도\n못하는 당신을 위한 \n맞춤형 관리 앱',
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
