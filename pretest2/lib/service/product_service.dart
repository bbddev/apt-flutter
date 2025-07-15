import '../db/database_helper.dart';
import '../model/product.dart';

class ProductService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<bool> createProduct(
    String idText,
    String name,
    String priceText,
  ) async {
    // Validate ID
    int? id;
    if (idText.trim().isNotEmpty) {
      id = int.tryParse(idText.trim());
      if (id == null) {
        throw Exception('ID must be a valid number');
      }
      if (id <= 0) {
        throw Exception('ID must be greater than zero');
      }
    }

    // Validate input
    if (name.trim().isEmpty) {
      throw Exception('Product name cannot be blank');
    }

    if (priceText.trim().isEmpty) {
      throw Exception('Price cannot be blank');
    }

    int? price = int.tryParse(priceText.trim());
    if (price == null) {
      throw Exception('Price must be a valid number');
    }

    if (price <= 0) {
      throw Exception('Price must be greater than zero');
    }

    // Create and save product
    try {
      Product product = Product(id: id, name: name.trim(), price: price);
      await _databaseHelper.insertProduct(product);
      return true;
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception(
          'Product ID already exists. Please use a different ID.',
        );
      }
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return await _databaseHelper.getAllProducts();
    } else {
      return await _databaseHelper.searchProducts(query.trim());
    }
  }

  Future<List<Product>> getAllProducts() async {
    return await _databaseHelper.getAllProducts();
  }

  Future<bool> updateProduct(
    String idText,
    String name,
    String priceText,
  ) async {
    // Validate ID
    if (idText.trim().isEmpty) {
      throw Exception('Product ID cannot be blank');
    }

    int? id = int.tryParse(idText.trim());
    if (id == null) {
      throw Exception('ID must be a valid number');
    }

    if (id <= 0) {
      throw Exception('ID must be greater than zero');
    }

    // Validate input
    if (name.trim().isEmpty) {
      throw Exception('Product name cannot be blank');
    }

    if (priceText.trim().isEmpty) {
      throw Exception('Price cannot be blank');
    }

    int? price = int.tryParse(priceText.trim());
    if (price == null) {
      throw Exception('Price must be a valid number');
    }

    if (price <= 0) {
      throw Exception('Price must be greater than zero');
    }

    // Update product
    Product product = Product(id: id, name: name.trim(), price: price);
    int result = await _databaseHelper.updateProduct(product);
    if (result == 0) {
      throw Exception('Product not found or update failed');
    }
    return true;
  }

  Future<bool> deleteProduct(int id) async {
    if (id <= 0) {
      throw Exception('Invalid product ID');
    }

    int result = await _databaseHelper.deleteProduct(id);
    if (result == 0) {
      throw Exception('Product not found or delete failed');
    }
    return true;
  }
}
