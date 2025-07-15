import '../product.dart';
import '../database_helper.dart';

class ProductService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Lấy tất cả sản phẩm từ database
  Future<List<Product>> getAllProducts() async {
    return await _databaseHelper.getAllProducts();
  }

  // Thêm sản phẩm mới
  Future<int> addProduct(Product product) async {
    return await _databaseHelper.insertProduct(product);
  }

  // Cập nhật sản phẩm
  Future<int> updateProduct(Product product) async {
    return await _databaseHelper.updateProduct(product);
  }

  // Xóa sản phẩm
  Future<int> deleteProduct(int id) async {
    return await _databaseHelper.deleteProduct(id);
  }

  // Tìm kiếm sản phẩm theo từ khóa
  Future<List<Product>> searchProducts(String keyword) async {
    return await _databaseHelper.searchProducts(keyword);
  }
}
