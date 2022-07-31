import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_nerve/podcast/webview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_nerve/Auth/auth.dart';
import 'package:food_nerve/Home/foodnerve_bottom_nav.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'FoodNerve',
      theme: ThemeData().copyWith(
          backgroundColor: Colors.orange,
          textTheme:
              GoogleFonts.questrialTextTheme(Theme.of(context).textTheme)),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const FoodNerveBottomNav();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
