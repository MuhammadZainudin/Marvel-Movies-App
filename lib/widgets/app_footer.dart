import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/about_page.dart';
import '../pages/top_movie_page.dart';

class AppFooter extends StatelessWidget {
  final int currentIndex;

  const AppFooter({super.key, required this.currentIndex});

  void _navigateTo(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = const TopMoviePage();
        break;
      case 2:
        page = const AboutPage();
        break;
      case 3:
        page = const ProfilePage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigateTo(context, index),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Rating',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'About',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
