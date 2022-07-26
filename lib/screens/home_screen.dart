import 'package:flutter/material.dart';
import 'package:peliculas_app_flutter/providers/movies_provider.dart';
import 'package:peliculas_app_flutter/widgets/movie_search_delegate.dart';
import 'package:peliculas_app_flutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = context.watch<MovieProvider>();
    //final moviesProvider = Provider.of<MovieProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            const SizedBox(height: 20),
            MovieSlider(
              moviesPopulars: moviesProvider.onDisplayPopularity,
              title: 'Movie Popularity',
              onNextPage: () => moviesProvider.getOnDisplayPopularity(),
            ),
          ],
        ),
      ),
    );
  }
}
