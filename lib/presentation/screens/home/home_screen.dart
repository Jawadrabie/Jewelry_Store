import 'package:flutter/material.dart';
import '../add/add_item_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/settings_screen.dart';
import 'home_content.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),        // الرئيسية
    FavoritesScreen(),    // المفضلة
    AddItemScreen(),   // إضافة
    SettingsScreen(),     // الإعدادات
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'المفضلة'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'إضافة'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}

