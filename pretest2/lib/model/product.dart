class Product {
  int? id;
  String name;
  int price;

  Product({this.id, required this.name, required this.price});

  // Convert Product to Map for SQLite
  Map<String, dynamic> toMap() {
    return {'_id': id, '_name': name, '_price': price};
  }

  // Convert Map to Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(id: map['_id'], name: map['_name'], price: map['_price']);
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price}';
  }
}
