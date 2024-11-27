class Movie {
  final String title;
  final String coverUrl;
  final String? overview;
  final String? writtenBy;
  final String? directedBy;
  final String? trailerUrl;
  double? rating;
  final String? releaseDate;
  late final int releaseYear;

  Movie({
    required this.title,
    required this.coverUrl,
    this.overview,
    this.writtenBy,
    this.directedBy,
    this.trailerUrl,
    this.rating,
    this.releaseDate,
  }) {
    releaseYear = _extractReleaseYear(releaseDate);
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Unknown Title',
      coverUrl: json['cover_url'] ?? '',
      overview: json['overview'],
      writtenBy: json['written_by'],
      directedBy: json['directed_by'],
      trailerUrl: json['trailer_url'],
      rating: json['imdb_rating'] != null
          ? double.tryParse(json['imdb_rating'].toString())
          : null,
      releaseDate: json['release_date'],
    );
  }

  int _extractReleaseYear(String? date) {
    if (date == null || date.isEmpty) {
      return 0;
    }
    try {
      return int.parse(date.split('-')[0]);
    } catch (e) {
      return 0;
    }
  }
}
