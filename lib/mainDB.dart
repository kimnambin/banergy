// DB Product + 자유게시판

class Product {
  final int id;
  final String barcode;
  final String name;
  final String kategorie;
  final String frontproduct;
  final String backproduct;
  final String allergens;

  Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.kategorie,
    required this.frontproduct,
    required this.backproduct,
    required this.allergens,
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
    );
  }
}

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
