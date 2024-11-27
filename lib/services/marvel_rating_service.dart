import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MarvelRatingService {
  final String _marvelApiUrl = 'https://mcuapi.herokuapp.com/api/v1/movies';

  final Map<String, double> _imdbRatings = {
    "Iron Man": 7.9,
    "The Incredible Hulk": 6.6,
    "Iron Man 2": 7.0,
    "Thor": 7.0,
    "Captain America: The First Avenger": 6.9,
    "The Avengers": 8.0,
    "Iron Man 3": 7.1,
    "Thor: The Dark World": 6.7,
    "Captain America: The Winter Soldier": 7.7,
    "Guardians of the Galaxy": 8.0,
    "Avengers: Age of Ultron": 7.3,
    "Ant-Man": 7.3,
    "Captain America: Civil War": 7.8,
    "Doctor Strange": 7.5,
    "Guardians of the Galaxy Vol. 2": 7.6,
    "Spider-Man: Homecoming": 7.4,
    "Thor: Ragnarok": 7.9,
    "Black Panther": 7.3,
    "Avengers: Infinity War": 8.4,
    "Ant-Man and The Wasp": 7.0,
    "Captain Marvel": 6.9,
    "Avengers: Endgame": 8.4,
    "Spider-Man: Far From Home": 7.4,
    "Eternals": 6.3,
    "Spider-Man: No Way Home": 8.2,
    "Shang-Chi and The Legend of The Ten Rings": 7.4,
    "Guardians of the Galaxy Vol. 3": 7.9,
    "Black Panther: Wakanda Forever": 6.7,
    "Doctor Strange in the Multiverse of Madness": 6.9,
    "Ant-Man and The Wasp: Quantumania": 6.0,
    "Thor: Love and Thunder": 6.2,
    "Black Widow": 6.6,
    "Deadpool & Wolverine": 7.7,
    "The Marvels": 5.5,
  };

  Future<List<Movie>> fetchMarvelMoviesWithRatings() async {
    try {
      final response = await http.get(Uri.parse(_marvelApiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        List<Movie> movies = data.map((json) => Movie.fromJson(json)).toList();

        for (var movie in movies) {
          if (_imdbRatings.containsKey(movie.title)) {
            movie.rating = _imdbRatings[movie.title];
          }
        }

        movies.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

        return movies;
      } else {
        throw Exception('Failed to load Marvel movies');
      }
    } catch (e) {
      print("Error fetching movies: $e");
      return [];
    }
  }
}
