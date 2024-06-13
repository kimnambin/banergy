// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/intro/splash_screen.dart';
import 'package:flutter_banergy/intro/auth_screen.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';
import 'package:flutter_banergy/main.dart';
import 'package:flutter_banergy/rounter/locations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final _routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
          pathBlueprints: ['/'],
          check: (context, location) {
            return false;
          },
          showPage: BeamPage(child: const AuthScreen()))
    ],
    locationBuilder:
        BeamerLocationBuilder(beamLocations: [HomeLocation()]).call);
//인트로의 첫 화면
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const introApp());
}

// ignore: camel_case_types
class introApp extends StatefulWidget {
  const introApp({super.key});

  @override
  State<introApp> createState() => _introAppState();
}

// ignore: camel_case_types
class _introAppState extends State<introApp> {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          autoLogin(context);
          return FutureBuilder<Object>(
            future: Future.delayed(const Duration(seconds: 5), () => 100),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 900),
                child: _splashLodingWidget(snapshot),
              );
            },
          );
        },
      ),
    );
  }

  StatelessWidget _splashLodingWidget(AsyncSnapshot<Object> snapshot) {
    if (snapshot.hasError) {
      return const Text('Error');
    } else if (snapshot.hasData) {
      return const RadishApp();
    } else {
      return const SplashScreen();
    }
  }

  // 로그인 유지를 위한 토큰
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // 사용자 정보를 가져오는 함수
  Future<void> fetchUserInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final username = jsonDecode(response.body)['username'];
        if (kDebugMode) {
          print('로그인한 사용자: $username');
        }
      } else {
        throw Exception('Failed to fetch user info');
      }
    } catch (error) {
      // 오류 발생 시 처리
    }
  }

  // 자동 로그인
  Future<void> autoLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      String? authToken = prefs.getString('authToken');
      if (authToken != null) {
        // 토큰이 유효한지 확인하고 사용자 정보 가져오기
        final isValid = await _validateToken(authToken);
        if (isValid) {
          // 유효한 경우 사용자 정보 가져오기
          await fetchUserInfo(authToken);
          // 홈 화면으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainpageApp(),
            ),
          );
          return;
        } else {
          // 토큰이 만료된 경우 로그아웃 처리
          await logout(context);
        }
      }
    }
  }

  // 로그아웃
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('authToken');
    // 로그인 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FirstApp(),
      ),
    );
  }

  // 토큰 유효성 검사 함수
  Future<bool> _validateToken(String token) async {
    return true;
  }
}

class RadishApp extends StatelessWidget {
  const RadishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}
