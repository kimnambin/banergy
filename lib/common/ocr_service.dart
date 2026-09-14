// 사진을 서버로 보내 OCR(문자 인식)을 수행하는 통신 로직입니다.
// 회원(로그인 토큰 필요)과 비회원(토큰 불필요)이 서로 다른 주소를 쓰기 때문에
// 메서드를 둘로 나눴습니다.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class OcrService {
  OcrService({required this.baseUrl});

  final String baseUrl;

  /// 로그인한 회원의 사진을 서버로 보내 인식된 텍스트를 돌려받습니다.
  Future<String> recognizeText({
    required File imageFile,
    required String authToken,
  }) {
    return _sendForRecognition(
      path: '/logindb/ocr',
      imageFile: imageFile,
      authToken: authToken,
    );
  }

  /// 비회원의 사진을 서버로 보내 인식된 텍스트를 돌려받습니다.
  Future<String> recognizeTextAsGuest({required File imageFile}) {
    return _sendForRecognition(path: '/nouser/ocr', imageFile: imageFile);
  }

  /// 이미지를 [path]로 전송하고, 인식된 텍스트를 줄바꿈으로 이어붙여 돌려줍니다.
  /// 서버 요청이 실패하면, 화면에 바로 보여줄 수 있는 실패 안내 문구를 돌려줍니다.
  Future<String> _sendForRecognition({
    required String path,
    required File imageFile,
    String? authToken,
  }) async {
    final Uri url = Uri.parse('$baseUrl:8000$path');
    final http.MultipartRequest request = http.MultipartRequest('POST', url);
    if (authToken != null) {
      request.headers['Authorization'] = 'Bearer $authToken';
    }
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    final http.StreamedResponse response = await request.send();
    final String body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      return 'Failed to perform OCR: ${response.statusCode}';
    }

    final Map<String, dynamic> decoded =
        json.decode(body) as Map<String, dynamic>;
    final List<dynamic> lines = decoded['text'] as List<dynamic>;
    return lines.join('\n');
  }
}
