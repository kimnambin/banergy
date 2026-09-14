// 알레르기 정보를 서버에 저장하거나 불러오는 통신(네트워크) 로직을 모아둔 파일입니다.
// 화면(UI) 코드와 분리해서, 여기서는 서버와 주고받는 부분만 다룹니다.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// 로그인된 사용자의 인증 토큰과, 서버에 이미 저장되어 있던 알레르기 목록을 함께 담는 값.
class LoggedInUserAllergyInfo {
  const LoggedInUserAllergyInfo({
    required this.authToken,
    required this.savedAllergies,
  });

  final String authToken;
  final List<String> savedAllergies;
}

/// 알레르기 필터링 화면들이 공통으로 사용하는 서버 통신 담당 클래스.
class AllergyService {
  AllergyService({required this.baseUrl});

  final String baseUrl;

  /// 로그인 시 저장해 둔 인증 토큰이 아직 유효한지 확인하고,
  /// 유효하면 토큰과 서버에 저장된 알레르기 목록을 함께 돌려줍니다.
  /// 로그인 상태가 아니거나 토큰이 만료되었다면 null을 돌려줍니다.
  Future<LoggedInUserAllergyInfo?> loadLoggedInUserAllergies() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');
    if (token == null) {
      return null;
    }

    try {
      final http.Response response = await http.get(
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        return null;
      }

      final Map<String, dynamic> body =
          json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawAllergies =
          (body['allergies'] as List<dynamic>?) ?? const <dynamic>[];
      final List<String> savedAllergies =
          rawAllergies.map((dynamic item) => item.toString()).toList();

      return LoggedInUserAllergyInfo(
        authToken: token,
        savedAllergies: savedAllergies,
      );
    } catch (error) {
      if (kDebugMode) {
        print('사용자 알레르기 정보를 불러오지 못했습니다: $error');
      }
      return null;
    }
  }

  /// 비회원 사용자의 알레르기 선택 결과를 서버에 저장합니다. 성공하면 true를 돌려줍니다.
  Future<bool> submitGuestAllergies(List<String> allergies) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$baseUrl:8000/nouser/ftr'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'allergies': jsonEncode(allergies)}),
      );
      return response.statusCode == 201;
    } catch (error) {
      if (kDebugMode) {
        print('비회원 알레르기 저장에 실패했습니다: $error');
      }
      return false;
    }
  }

  /// 로그인한 회원의 알레르기 선택 결과를 서버에 저장합니다. 성공하면 true를 돌려줍니다.
  Future<bool> submitMemberAllergies({
    required String? authToken,
    required List<String> allergies,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$baseUrl:8000/logindb/allergies'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'allergies': jsonEncode(allergies)}),
      );
      return response.statusCode == 200;
    } catch (error) {
      if (kDebugMode) {
        print('회원 알레르기 저장에 실패했습니다: $error');
      }
      return false;
    }
  }
}
