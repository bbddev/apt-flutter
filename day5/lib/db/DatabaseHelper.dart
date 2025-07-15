import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper dh = DatabaseHelper();
  static Database? db;
  Future<Database> get database async {
    if (db != null) return db!;
    db = await _initDb();
    return db!;
  }

  // Add this method to insert sample data
  Future<void> insertSampleData() async {
    final dbClient = await database;
    await dbClient.insert('movies', {
      'name': 'Inception',
      'year': '2010',
      'isFavorite': 1,
    });
    await dbClient.insert('movies', {
      'name': 'The Matrix',
      'year': '1999',
      'isFavorite': 0,
    });
    await dbClient.insert('movies', {
      'name': 'Interstellar',
      'year': '2014',
      'isFavorite': 1,
    });
  }
}

Future<Database> _initDb() async {
  String sql =
      "CREATE TABLE movies ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "name TEXT, "
      "year TEXT, "
      "isFavorite INTEGER)";
  final pathDB = await getDatabasesPath();
  final path = join(pathDB, "MovieDB.db");
  return await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(sql);
      await db.execute('INSERT INTO movies (name, year, isFavorite) VALUES ("Inception", "2010", 1)');
      await db.execute('INSERT INTO movies (name, year, isFavorite) VALUES ("The Matrix", "1999", 0)');
      await db.execute('INSERT INTO movies (name, year, isFavorite) VALUES ("Interstellar", "2014", 1)');
      
    },
  );
}
