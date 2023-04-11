import 'package:flutter/material.dart';
import 'package:my_digital_library/pages/home/home.dart';
import 'package:my_digital_library/pages/settings/settingsHome.dart';
import 'package:my_digital_library/pages/sources/sourcesHome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => homePage(),
        '/sources': (context) => sourcesHome(),
        '/settings': (context) => settingsHome(),
      },
      debugShowCheckedModeBanner: false,
      title: 'My Digital Library',
      theme: ThemeData(),
      home: homePage(),
    );
  }
}

