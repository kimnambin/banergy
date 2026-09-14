// 서버에서 받아오는 상품 정보, 자유게시판 글 정보를 담는 모델(데이터 형태)들입니다.

/// 상품 정보.
class Product {
  Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.kategorie,
    required this.frontproduct,
    required this.backproduct,
    this.allergens = '',
    this.isHearted = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      barcode: json['barcode'] as String,
      kategorie: json['kategorie'] as String,
      name: json['name'] as String,
      frontproduct: json['frontproduct'] as String,
      backproduct: json['backproduct'] as String,
      allergens: json['allergens'] as String,
      isHearted: json['isHearted'] as bool? ?? false,
    );
  }

  final int id;
  final String barcode;
  final String name;
  final String kategorie;
  final String frontproduct;
  final String backproduct;
  final String allergens;
  bool isHearted;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'kategorie': kategorie,
      'frontproduct': frontproduct,
      'backproduct': backproduct,
      'allergens': allergens,
      'isHearted': isHearted,
    };
  }
}

/// 자유게시판(커뮤니티) 글 하나.
class FreeboardPost {
  FreeboardPost({
    required this.freetitle,
    required this.freecontent,
    required this.timestamp,
  });

  factory FreeboardPost.fromJson(Map<String, dynamic> json) {
    return FreeboardPost(
      freetitle: json['freetitle'] as String?,
      freecontent: json['freecontent'] as String?,
      timestamp: json['timestamp'] as String?,
    );
  }

  final String? freetitle;
  final String? freecontent;
  final String? timestamp;
}
