import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laundry_test/admin/pages/dashboard_page.dart';
import 'package:laundry_test/auth/register.dart';
import 'package:laundry_test/cust/pages/home_pages.dart';
import 'package:laundry_test/firebase_options.dart';

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
      theme: ThemeData(
        fontFamily: 'Sans',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // <<--- Tambahin ini biar background putih
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
