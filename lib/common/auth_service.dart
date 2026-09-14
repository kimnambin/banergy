// 로그인 토큰을 저장소에서 읽고, 서버에 아직 유효한지 확인하는 로직을 모아둔 파일입니다.
// 여러 화면(홈, 상품 목록 등)이 "지금 로그인되어 있는가?"를 확인할 때 함께 사용합니다.

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService({required this.baseUrl});

  final String baseUrl;

  /// 로컬에 저장된 로그인 토큰을 읽어옵니다. 저장된 토큰이 없으면 null.
  Future<String?> readSavedAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  /// 주어진 토큰이 서버 기준으로 아직 유효한지 확인합니다.
  Future<bool> isTokenValid(String token) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$baseUrl:8000/logindb/loginuser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  /// 저장된 토큰을 읽고 유효성까지 확인한 뒤, 유효할 때만 토큰을 돌려줍니다.
  /// 로그인 상태가 아니거나 토큰이 만료되었으면 null을 돌려줍니다.
  Future<String?> loadValidAuthToken() async {
    final String? token = await readSavedAuthToken();
    if (token == null) {
      return null;
    }
    return (await isTokenValid(token)) ? token : null;
  }
}
