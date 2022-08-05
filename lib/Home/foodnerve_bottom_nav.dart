import 'package:flutter/material.dart';
import 'package:food_nerve/Giveaway/giveaway_main.dart';
import 'package:food_nerve/Home/foodnerve_drawer.dart';
import 'package:food_nerve/Merchandice/merchandice.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../podcast/webview.dart';

class FoodNerveBottomNav extends StatefulWidget {
  const FoodNerveBottomNav({Key? key}) : super(key: key);

  @override
  State<FoodNerveBottomNav> createState() => _FoodNerveBottomNavState();
}

class _FoodNerveBottomNavState extends State<FoodNerveBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Merchandice(),
    const GiveAway(),
    // const MyHomePage(),
    // const VideoList(),
    const WebViews(
      initialUrl: 'https://www.youtube.com/channel/UCURsvyOjsGMFkH2T8NQQwXA',
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodNerve',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: const FoodNerveDrawer(),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.greenAccent,
        onTap: _onItemTapped,
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.fastfood_outlined),
            title: const Text("Merchandice"),
            selectedColor: Colors.greenAccent,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text("Giveaway"),
            selectedColor: Colors.greenAccent,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.video_label_outlined),
            title: const Text("Podcast"),
            selectedColor: Colors.greenAccent,
          ),
        ],
      ),
    );
  }
}
