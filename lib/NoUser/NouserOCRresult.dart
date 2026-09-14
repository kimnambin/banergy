// 비회원의 OCR 결과 화면입니다.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_banergy/common/ocr_highlighting.dart';
import 'package:flutter_banergy/common/ocr_result_view.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Ocrresult2 extends StatefulWidget {
  const Ocrresult2({
    super.key,
    required this.imagePath,
    required this.ocrResult,
  });

  final String imagePath;
  final String ocrResult;

  @override
  State<Ocrresult2> createState() => _Ocrresult2State();
}

class _Ocrresult2State extends State<Ocrresult2> {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  late String _plainText;
  late String _highlightedTerms;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _plainText = widget.ocrResult;
    _highlightedTerms = widget.ocrResult;
    _loadOcrResult();
  }

  Future<void> _loadOcrResult() async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$_baseUrl:8000/nouser/result'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        final List<String> ocrLines = (data['text'] as List).cast<String>();
        final OcrHighlightResult highlights = extractOcrHighlights(ocrLines);
        setState(() {
          _plainText = highlights.plainText;
          _highlightedTerms = highlights.highlightedTerms;
        });
      } else {
        setState(() => _highlightedTerms = '');
      }
    } catch (error) {
      setState(() => _highlightedTerms = 'Error occurred: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OcrResultView(
      imagePath: widget.imagePath,
      isLoading: _isLoading,
      plainText: _plainText,
      highlightedTerms: _highlightedTerms,
      showHeading: true,
      onBack: () => Navigator.of(context).pop(),
      onClose: () => Navigator.pop(context),
    );
  }
}
