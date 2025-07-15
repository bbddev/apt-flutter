import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ProductDB.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Product (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        _name TEXT NOT NULL,
        _price INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    if (product.id != null) {
      // Insert with custom ID
      return await db.insert(
        'Product',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } else {
      // Insert with auto-generated ID
      return await db.insert('Product', product.toMap());
    }
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Product');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Product',
      where: '_name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'Product',
      product.toMap(),
      where: '_id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('Product', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
