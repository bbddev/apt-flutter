import 'package:day5/models/movie.dart';
import 'package:day5/services/MovieService.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Movie> allMovies = [];
  List<Movie> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadMovies();
  }

Future<void> loadMovies() async {
    final loadMovies = await MovieService.getMovies();
    final loadFavoriteMovies = loadMovies.where((movie) => movie.isFavorite!).toList();
    setState(() {
      allMovies = loadMovies;
      favoriteMovies = loadFavoriteMovies;
    });
  }

  Future<void> addMovie(String name, String year) async {
    final newMovie = Movie(id: DateTime.now().millisecondsSinceEpoch ,name: name, year: year, isFavorite: false);
    await MovieService.insertMovie(newMovie);    
    await loadMovies();
  }



  Future<void> updateMovie(Movie updatedMovie) async {
    await MovieService.updateMovie(updatedMovie);
    await loadMovies();
  }

  Future<void> deleteMovie(int id) async {
    await MovieService.deleteMovie(id);
    await loadMovies();
  }

  Future<void> toggleFavorite(int id) async {
    await MovieService.toggleFavorite(id);
    await loadMovies();
  }

  void dialogMovie(BuildContext context, {Movie? movie}) {
    final nameController = TextEditingController(text: movie?.name ?? '');
    final yearController = TextEditingController(text: movie?.year ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(movie == null ? 'Add Movie' : 'Edit Movie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (movie == null) {
                  addMovie(nameController.text, yearController.text);
                } else {
                  updateMovie(Movie(id: movie.id, name: nameController.text, year: yearController.text, isFavorite: movie.isFavorite));
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Movie Management'),
        centerTitle: true,
        actions: [
          TextButton(onPressed: (){
            dialogMovie(context);
          }, child: Text("+", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),)),
        ],
        bottom: TabBar(
          controller: _tabController,
          padding: EdgeInsets.zero,          
          tabs:[
          Tab(text: 'All Movies'),
          Tab(text: 'Favorites Movies'),
        ]),
      ),    
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: allMovies.length,
            itemBuilder: (context, index) {
              final movie = allMovies[index];
              return ListTile(
                title: Text(movie.name ?? 'Unknown'),
                subtitle: Text(movie.year ?? 'Unknown'),
                trailing: IconButton(
                  icon: Icon(movie.isFavorite! ? Icons.favorite : Icons.favorite_border),
                  onPressed: () => toggleFavorite(movie.id!.toInt()),
                ),
                onTap: () {
                  dialogMovie(context, movie: movie);
                },
              );
            },
         
          ),
          ListView.builder(
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return ListTile(
                title: Text(movie.name ?? 'Unknown'),
                subtitle: Text(movie.year ?? 'Unknown'),
                trailing: IconButton(
                  icon: Icon(movie.isFavorite! ? Icons.favorite : Icons.favorite_border),
                  onPressed: () => toggleFavorite(movie.id!.toInt()),
                ),
                onTap: () {
                  dialogMovie(context, movie: movie);
                },
              );
            },
          )
        ],
      ),
    );
  }
}