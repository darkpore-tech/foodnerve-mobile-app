import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_nerve/Contents/contents.dart';
import 'package:food_nerve/Giveaway/giveaway_main.dart';
import 'package:food_nerve/Home/foodnerve_drawer.dart';
import 'package:food_nerve/Merchandice/merchandice.dart';

class FoodNerveBottomNav extends StatefulWidget {
  const FoodNerveBottomNav({Key? key}) : super(key: key);

  @override
  State<FoodNerveBottomNav> createState() => _FoodNerveBottomNavState();
}

class _FoodNerveBottomNavState extends State<FoodNerveBottomNav> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    GiveAway(),
    Merchandice(),
    MyHomePage(),
    // Podcast(),
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
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person),
<<<<<<< HEAD
              onPressed: () {},
            ),
=======
onPressed: () {},            ),
>>>>>>> 0cb13fabda2fd35eab7240919b95659cb1a47f9f
          ],
          title: const Text('foodnerve',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Theme.of(context).primaryColorDark),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: const FoodNerveDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_outline,
            ),
            label: 'Giveaway',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'Merchandise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'Podcast',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.grey[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
