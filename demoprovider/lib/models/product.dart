class Product {
  int id;
  String name;
  String description;
  double price;
  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
    );
  }
  @override
  String toString() {
    return "$id $name $price $description";
  }
}
