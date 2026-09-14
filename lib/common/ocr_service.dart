// 사진을 서버로 보내 OCR(문자 인식)을 수행하는 통신 로직입니다.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class OcrService {
  OcrService({required this.baseUrl});

  final String baseUrl;

  /// [imageFile]을 서버로 보내 인식된 텍스트를 줄바꿈으로 이어붙여 돌려줍니다.
  /// 서버 요청이 실패하면, 화면에 바로 보여줄 수 있는 실패 안내 문구를 돌려줍니다.
  Future<String> recognizeText({
    required File imageFile,
    required String authToken,
  }) async {
    final Uri url = Uri.parse('$baseUrl:8000/logindb/ocr');
    final http.MultipartRequest request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $authToken'
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

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
