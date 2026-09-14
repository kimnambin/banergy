// OCR로 읽은 텍스트에서 『...』로 감싸인 강조 표시 부분을 뽑아내는 로직입니다.

/// OCR 결과 한 줄짜리 목록에서 뽑아낸 일반 텍스트와 강조 표시 텍스트.
class OcrHighlightResult {
  const OcrHighlightResult({
    required this.plainText,
    required this.highlightedTerms,
  });

  /// OCR로 읽은 텍스트 전체를 한 줄로 이어붙인 것.
  final String plainText;

  /// 『...』로 감싸인 부분만 모아 쉼표로 이어붙인 것.
  final String highlightedTerms;
}

/// [ocrLines]에서 『...』로 감싸인 부분을 찾아 [OcrHighlightResult]로 정리합니다.
OcrHighlightResult extractOcrHighlights(List<String> ocrLines) {
  final RegExp regex = RegExp(r'『(.*?)』');
  final List<String> highlightedTerms = [];
  for (final String line in ocrLines) {
    highlightedTerms.addAll(
      regex.allMatches(line).map((match) => match.group(1) ?? ''),
    );
  }

  return OcrHighlightResult(
    plainText: ocrLines.join(' ').trim(),
    highlightedTerms: highlightedTerms.join(', ').trim(),
  );
}
