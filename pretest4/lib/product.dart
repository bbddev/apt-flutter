class Product {
  int? id;
  String? productName;
  int? price;
  double? quantity;

  Product({this.id, this.productName, this.price, this.quantity});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map["id"] = id;
    map["product_name"] = productName;
    map["price"] = price;
    map["quantity"] = quantity;
    return map;
  }

  Product.fromJson(dynamic json) {
    id = json["id"];
    productName = json["product_name"];
    price = json["price"];
    quantity = json["quantity"];
  }
}
