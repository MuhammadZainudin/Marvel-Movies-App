import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:flutter/material.dart';
import '../models/movie.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;

  const DetailPage({super.key, required this.movie});

  Future<void> _launchTrailer() async {
    final url = movie.trailerUrl;
    if (url != null && await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open trailer URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie.coverUrl,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 8),
              Text(
                "Rating: ${movie.rating != null ? movie.rating!.toStringAsFixed(1) : 'N/A'}", // Tampilkan rating 1 desimal
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Directed by: ${movie.directedBy ?? 'Unknown'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Release Date: ${movie.releaseDate ?? 'Unknown'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                movie.overview ?? 'No overview available.',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              if (movie.trailerUrl != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: _launchTrailer,
                    child: const Text('Watch Trailer'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
