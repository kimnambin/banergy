// 상품 상세 화면(메인 화면에서 들어간 것/찜한 목록에서 들어간 것)이 함께 쓰는 화면(UI)입니다.
// 좋아요 버튼을 누르면 어떤 일이 일어나는지는 화면마다 달라서 likeButton으로 따로 받습니다.

import 'package:flutter/material.dart';
import 'package:flutter_banergy/mainDB.dart';
import 'package:photo_view/photo_view.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({
    super.key,
    required this.product,
    required this.onBack,
    required this.likeButton,
    required this.hasMatchingAllergy,
    required this.textScaleFactor,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  static const double minTextScaleFactor = -2.0;
  static const double maxTextScaleFactor = 2.0;

  final Product product;
  final VoidCallback onBack;

  /// 화면마다 동작이 다른 좋아요 버튼(하트 아이콘).
  final Widget likeButton;

  /// 상품의 알레르기 성분이 사용자의 알레르기 정보와 겹치는지 여부.
  final bool hasMatchingAllergy;

  final double textScaleFactor;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: onBack,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32, top: 8),
                  child: likeButton,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: SizedBox(
                    width: 250,
                    height: 200,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: _buildZoomableImage(
                            context,
                            product.frontproduct,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32, bottom: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.zoom_in,
                          color: textScaleFactor > minTextScaleFactor
                              ? const Color(0xFF7C7C7C)
                              : Colors.green,
                        ),
                        onPressed: onZoomIn,
                        iconSize: 28,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(
                          Icons.zoom_out,
                          color: Color(0xFF7C7C7C),
                        ),
                        onPressed: onZoomOut,
                        color: Colors.white,
                        iconSize: 28,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Color(0xFFDDD7D7),
                thickness: 1.0,
                height: 5.0,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: _buildTitleTexts([product.category, product.name]),
              ),
              const SizedBox(height: 50),
              _buildLabeledText('알레르기 식품:', product.allergens),
              const SizedBox(height: 20),
              if (hasMatchingAllergy)
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    '사용자와 맞지 않은 상품입니다.',
                    style: TextStyle(
                      backgroundColor: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const SizedBox(height: 40),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        '$label $value',
        style: TextStyle(fontSize: 14 * textScaleFactor),
      ),
    );
  }

  // 앞에 라벨 없이 내용만 세로로 나열하는 부분 (카테고리, 상품명).
  Widget _buildTitleTexts(List<String> texts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: texts.map((text) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildZoomableImage(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () => _showZoomedImage(context, imageUrl),
      child: Image.network(imageUrl),
    );
  }

  void _showZoomedImage(BuildContext context, String imageUrl) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Stack(
            alignment: Alignment.topRight,
            children: [
              PhotoView(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained * 1.0,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
