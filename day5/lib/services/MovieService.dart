import 'package:day5/db/DatabaseHelper.dart';
import 'package:day5/models/movie.dart';

class MovieService {
  static Future<List<Movie>> getMovies() async {
    final db = await DatabaseHelper.dh.database;
    final movies = await db.query('movies');
    return movies.map((e) => Movie.fromJson(e)).toList();
  }

  static Future<Movie> getMovie(int id) async {
    final db = await DatabaseHelper.dh.database;
    final movies = await db.query('movies', where: 'id = ?', whereArgs: [id]);
    if (movies.isNotEmpty) {
      return Movie.fromJson(movies.first);
    } else {
      throw Exception('Movie not found');
    }
  }

  static Future<int> insertMovie(Movie newMovie) async {
    final db = await DatabaseHelper.dh.database;
    return await db.insert('movies', newMovie.toJson());
  }

  static Future<int> updateMovie(Movie updatedMovie) async {
    final db = await DatabaseHelper.dh.database;
    return await db.update(
      'movies',
      updatedMovie.toJson(),
      where: 'id = ?',
      whereArgs: [updatedMovie.id],
    );
  }

  static Future<int> deleteMovie(int id) async {
    final db = await DatabaseHelper.dh.database;
    return await db.delete(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> toggleFavorite(int id) async {
    final movie = await getMovie(id);
    movie.isFavorite = !movie.isFavorite!;
    return await updateMovie(movie);
  }
}
