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
