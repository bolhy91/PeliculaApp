import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app_flutter/helpers/debouncer.dart';
import 'package:peliculas_app_flutter/models/cast.dart';
import 'package:peliculas_app_flutter/models/credits_response.dart';
import 'package:peliculas_app_flutter/models/movie.dart';
import 'package:peliculas_app_flutter/models/now_playing_response.dart';
import 'package:peliculas_app_flutter/models/popularity_response.dart';
import 'package:peliculas_app_flutter/models/search_response.dart';

class MovieProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'c597f96b64e654e060bb06a2b01d8a49';
  final String _lenguage = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> onDisplayPopularity = [];

  int _popularPage = 0;

  Map<int, List<Cast>> moviesCast = {};

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _streamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _streamController.stream;

  MovieProvider() {
    // ignore: avoid_print
    print('Movie provider inicializado');
    _getOnDisplayMovies();
    getOnDisplayPopularity();
  }

  _getOnDisplayMovies() async {
    var response = await _getJsonData('3/movie/now_playing');
    final movies = NowPlayingResponse.fromJson(response);
    onDisplayMovies = movies.results;
    notifyListeners();
  }

  getOnDisplayPopularity() async {
    _popularPage++;
    var response = await _getJsonData('3/movie/popular', _popularPage);
    final populars = PopularityResponse.fromJson(response);
    onDisplayPopularity = [...onDisplayPopularity, ...populars.results];
    notifyListeners();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _lenguage, 'page': '$page'});
    var response = await http.get(url);
    return response.body;
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    final response = await _getJsonData('3/movie/$movieId/credits');
    final credits = CreditsResponse.fromJson(response);
    moviesCast[movieId] = credits.cast;

    return credits.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _lenguage, 'query': query});
    final response = await http.get(url);
    final movies = SearchResponse.fromJson(response.body);
    return movies.results;
  }

  void getSuggestionByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _streamController.add(results);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });
    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
