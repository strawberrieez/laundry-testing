import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laundry_test/firebase_options.dart';
import 'package:laundry_test/cust/pages/home_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry Express',
      theme: ThemeData(fontFamily: 'Sans', brightness: Brightness.light),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
