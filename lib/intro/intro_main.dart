import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/intro/splash_screen.dart';
import 'package:flutter_banergy/intro/auth_screen.dart';
import 'package:flutter_banergy/rounter/locations.dart';

final _routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
          pathBlueprints: ['/'],
          check: (context, location) {
            return false;
          },
          showPage: BeamPage(child: AuthScreen()))
    ],
    locationBuilder:
        BeamerLocationBuilder(beamLocations: [HomeLocation()]).call);
//인트로의 첫 화면
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: Future.delayed(const Duration(seconds: 5), () => 100),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 900),
          child: _splashLodingWidget(snapshot),
        );
      },
    );
  }

  StatelessWidget _splashLodingWidget(AsyncSnapshot<Object> snapshot) {
    if (snapshot.hasError) {
      print('에러 발생');
      return Text('Error');
    } else if (snapshot.hasData) {
      return RadishApp();
    } else {
      return SplashScreen();
    }
  }
}

class RadishApp extends StatelessWidget {
  const RadishApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}
