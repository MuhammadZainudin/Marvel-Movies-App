import 'package:flutter/material.dart';
import '../services/marvel_rating_service.dart';
import '../models/movie.dart';
import '../widgets/app_footer.dart';
import 'detail_page.dart';
import 'home_page.dart';

class TopRatedMoviesCache {
  static final TopRatedMoviesCache _instance = TopRatedMoviesCache._internal();
  factory TopRatedMoviesCache() => _instance;

  TopRatedMoviesCache._internal();

  List<Movie>? topRatedMovies;
}

class TopMoviePage extends StatefulWidget {
  const TopMoviePage({super.key});

  @override
  _TopMoviePageState createState() => _TopMoviePageState();
}

class _TopMoviePageState extends State<TopMoviePage> {
  List<Movie>? topRatedMovies;
  List<Movie>? filteredMovies;
  bool showRatingButtons = false;
  int? hoveredIndex;

  @override
  void initState() {
    super.initState();
    fetchTopRatedMovies();
  }

  Future<void> fetchTopRatedMovies() async {
    final cache = TopRatedMoviesCache();
    if (cache.topRatedMovies == null) {
      List<Movie> movies =
          await MarvelRatingService().fetchMarvelMoviesWithRatings();
      cache.topRatedMovies = movies
          .where((movie) => movie.rating != null)
          .toList()
        ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    }
    topRatedMovies = cache.topRatedMovies;
    filteredMovies = topRatedMovies;
    setState(() {});
  }

  void filterMoviesByRating(double minRating, double maxRating) {
    setState(() {
      filteredMovies = topRatedMovies
          ?.where((movie) =>
              movie.rating != null &&
              movie.rating! >= minRating &&
              movie.rating! <= maxRating)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Marvel Movies'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: filteredMovies == null
                    ? const Center(child: CircularProgressIndicator())
                    : filteredMovies!.isEmpty
                        ? const Center(
                            child: Text(
                              'No movies found',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Container(
                            color: Colors.black,
                            padding: const EdgeInsets.all(16),
                            child: ListView.builder(
                              itemCount: filteredMovies!.length,
                              itemBuilder: (context, index) {
                                final movie = filteredMovies![index];
                                final isHovered = hoveredIndex == index;

                                return MouseRegion(
                                  onEnter: (_) {
                                    setState(() {
                                      hoveredIndex = index;
                                    });
                                  },
                                  onExit: (_) {
                                    setState(() {
                                      hoveredIndex = null;
                                    });
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPage(movie: movie),
                                        ),
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: isHovered
                                            ? Colors.grey[850]
                                            : Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              movie.coverUrl,
                                              height: 80,
                                              width: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  movie.title,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Rating: ${movie.rating?.toStringAsFixed(1) ?? "N/A"}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showRatingButtons = !showRatingButtons;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: const CircleBorder(),
                    backgroundColor: Colors.blueAccent,
                    shadowColor: Colors.blueAccent.withOpacity(0.5),
                    elevation: 8,
                  ),
                  child: Icon(
                    showRatingButtons ? Icons.close : Icons.filter_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: showRatingButtons ? 500 : 0,
                  width: 50,
                  curve: Curves.easeInOut,
                  child: SingleChildScrollView(
                    child: AnimatedOpacity(
                      opacity: showRatingButtons ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        children: List.generate(
                          10,
                          (index) {
                            final ratingValue = 10 - index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: ElevatedButton(
                                onPressed: () {
                                  filterMoviesByRating(
                                    ratingValue.toDouble(),
                                    ratingValue.toDouble() + 0.9,
                                  );
                                  setState(() {
                                    showRatingButtons = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                  backgroundColor:
                                      const Color.fromARGB(0, 0, 0, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  '$ratingValue',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppFooter(currentIndex: 1),
    );
  }
}
