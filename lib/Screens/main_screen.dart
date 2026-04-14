import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jewelry", style: TextStyle(color: Colors.green)),
        centerTitle: true,
      ),

      body: const Center(
        child: Text("Main Screen", style: TextStyle(fontSize: 24)),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // ✅ Home selected
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: "Products",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: "Favorites",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.phone_outlined),
            activeIcon: Icon(Icons.phone),
            label: "Contact",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
