import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;
  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'products.db');
    return openDatabase(path, version: 1, onCreate: _onCreate, onOpen: _onOpen);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE products(id INTEGER PRIMARY"
      " KEY AUTOINCREMENT, name TEXT,"
      "description TEXT, price REAL)",
    );
  }

  // Thêm dữ liệu mẫu khi mở database nếu bảng trống
  Future _onOpen(Database db) async {
    List<Map<String, dynamic>> products = await db.query('products');
    if (products.isEmpty) {
      await db.insert('products', {'name': 'Laptop', 'description': 'High-performance laptop', 'price': 1200.00});
      await db.insert('products', {'name': 'Mouse', 'description': 'Wireless optical mouse', 'price': 25.00});
      await db.insert('products', {'name': 'Keyboard', 'description': 'Mechanical gaming keyboard', 'price': 75.00});
      await db.insert('products', {'name': 'Monitor', 'description': '27-inch 4K monitor', 'price': 300.00});
    }
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await this.db;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await this.db;
    return db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> row,
      {required int id}) async {
    final db = await this.db;
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, {required int id}) async {
    final db = await this.db;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
