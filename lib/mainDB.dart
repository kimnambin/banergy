// DB Product + 컴뮤니티 + 유저 정보까지

//상품 정보들
class Product {
  final int id;
  final String barcode;
  final String name;
  final String kategorie;
  final String frontproduct;
  final String backproduct;
  final String allergens;
  bool isHearted;

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
        id: json['id'],
        barcode: json['barcode'],
        kategorie: json['kategorie'],
        name: json['name'],
        frontproduct: json['frontproduct'],
        backproduct: json['backproduct'],
        allergens: json['allergens'],
        isHearted: json['isHearted'] ?? false);
  }
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

  // 좋아요를 토글하는 메서드
  void toggleHeart() {
    isHearted = !isHearted;
  }
}

//커뮤니티용
// ignore: camel_case_types
class freeDB {
  final String? freetitle;
  final String? freecontent;
  final String? timestamp;

  freeDB({
    required this.freetitle,
    required this.freecontent,
    required this.timestamp,
  });

  factory freeDB.fromJson(Map<String, dynamic> json) {
    return freeDB(
      freetitle: json['freetitle'],
      freecontent: json['freecontent'],
      timestamp: json['timestamp'],
    );
  }

  // timestamp를 변경하여 새로운 freeDB 객체를 반환하는 함수
  freeDB copyWith({
    String? freetitle,
    String? freecontent,
    String? timestamp,
  }) {
    return freeDB(
      freetitle: freetitle ?? this.freetitle,
      freecontent: freecontent ?? this.freecontent,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
