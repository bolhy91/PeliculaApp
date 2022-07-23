import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app_flutter/models/movie.dart';
import 'package:peliculas_app_flutter/models/now_playing_response.dart';
import 'package:peliculas_app_flutter/models/popularity_response.dart';

class MovieProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'c597f96b64e654e060bb06a2b01d8a49';
  final String _lenguage = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> onDisplayPopularity = [];

  int _popularPage = 0;

  MovieProvider() {
    // ignore: avoid_print
    print('Movie provider inicializado');
    _getOnDisplayMovies();
    _getOnDisplayPopularity();
  }

  _getOnDisplayMovies() async {
    var response = await _getJsonData('3/movie/now_playing');
    final movies = NowPlayingResponse.fromJson(response);
    onDisplayMovies = movies.results;
    notifyListeners();
  }

  _getOnDisplayPopularity() async {
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
}
