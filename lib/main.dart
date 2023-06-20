import 'package:flutter/material.dart';
import 'package:my_digital_library/pages/auth/authTree.dart';
import 'package:my_digital_library/pages/home/home.dart';
import 'package:my_digital_library/pages/settings/settingsHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_digital_library/pages/sources/sourcesTree.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';




Future<void> main() async  {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.openBox('favorites_v01');
  Hive.openBox('library_v01');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


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
        '/home': (context) => const authTree(),//homePage(),
        '/sources': (context) => const sourcesTree(),
        '/settings': (context) => const settingsHome(),
      },
      debugShowCheckedModeBanner: false,
      title: 'DigiLib',
      theme: ThemeData(),
      home: const homePage(),
    );
  }
}

