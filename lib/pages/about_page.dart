import 'package:flutter/material.dart';
import 'home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Marvel Movies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marvel Movies App',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Explore Marvel movies with this app.\nRelease Date: 2024\n\n'
                  'Marvel Movies app memberikan informasi lengkap tentang film Marvel Cinematic Universe (MCU), seperti judul, sinopsis, tanggal rilis, sutradara, rating, serta fitur menonton trailer.\n\n'
                  'Dengan antarmuka yang responsif, aplikasi ini memanfaatkan API eksternal untuk menampilkan data real-time. Fitur utama mencakup daftar film dengan poster, detail lengkap, dan tombol "Watch Trailer" untuk menonton cuplikan film secara langsung.\n\n'
                  'Navigasi antarhalaman dirancang mulus untuk memberikan pengalaman terbaik bagi pengguna.\n\n',
                  // 'Muhammad Zainudin Damar Jati [21120122140095].',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
