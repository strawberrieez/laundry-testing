import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry Express',
      theme: ThemeData(fontFamily: 'Sans', brightness: Brightness.light),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
