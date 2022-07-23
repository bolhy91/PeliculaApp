// To parse this JSON data, do
//
//     final popularityResponse = popularityResponseFromMap(jsonString);

import 'dart:convert';

import 'package:peliculas_app_flutter/models/movie.dart';

class PopularityResponse {
  PopularityResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory PopularityResponse.fromJson(String str) =>
      PopularityResponse.fromMap(json.decode(str));

  factory PopularityResponse.fromMap(Map<String, dynamic> json) =>
      PopularityResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
