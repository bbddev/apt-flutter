import 'package:flutter/material.dart';
import 'package:demoprovider/database/dbhelper.dart';
import 'package:demoprovider/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  Product? selectedProduct;
  List<Product> get products => _products;
  Future fetchProducts() async {
    final productMaps = await DatabaseHelper().query("products");
    _products = productMaps.map((p) => Product.fromMap(p)).toList();
    notifyListeners();
  }

  Future addProduct(Product product) async {
    final id = await DatabaseHelper().insert("products", product.toMap());
    print("id provider: $id");
    product.id = id;
    _products.add(product);
    notifyListeners();
  }

  Future updateDatabase(Product product) async {
    await DatabaseHelper().update("products", product.toMap(), id: product.id);
    final index = _products.indexWhere((p) => p.id == product.id);
    _products[index] = product;
    notifyListeners();
  }

  Future deleteProduct(int id) async {
    await DatabaseHelper().delete('products', id: id);
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

//set product to update
  setSelectedProduct(Product product) {
    selectedProduct = product;
    notifyListeners();
  }
}
