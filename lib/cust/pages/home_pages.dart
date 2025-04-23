import 'package:flutter/material.dart';
import 'package:laundry_test/cust/components/footer.dart';
import 'package:laundry_test/cust/components/navbar.dart';

import '../widgets/header_section.dart';
import '../widgets/price_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _berandaKey = GlobalKey();
  final GlobalKey _layananKey = GlobalKey();
  final GlobalKey _hargaKey = GlobalKey();
  final GlobalKey _kontakKey = GlobalKey();

  void scrollToSection(String section) {
    BuildContext? contextToScroll;
    switch (section) {
      case 'beranda':
        contextToScroll = _berandaKey.currentContext;
        break;
      case 'layanan':
        contextToScroll = _layananKey.currentContext;
        break;
      case 'harga':
        contextToScroll = _hargaKey.currentContext;
        break;
      case 'kontak':
        contextToScroll = _kontakKey.currentContext;
        break;
    }

    if (contextToScroll != null) {
      Scrollable.ensureVisible(
        contextToScroll,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavigationDrawerMobile(onItemSelected: scrollToSection),
      body: Stack(
        children: [
          // Konten scrollable
          Padding(
            padding: const EdgeInsets.only(top: 80), // Sesuaikan dengan tinggi Navbar
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Konten utama
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(key: _berandaKey, child: const HeaderSection()),
                        const SizedBox(height: 40),
                        Container(key: _hargaKey, child: const DaftarHarga()),
                        const SizedBox(height: 40),
                        Container(key: _kontakKey),
                      ],
                    ),
                  ),
                  const Footer(),
                ],
              ),
            ),
          ),

          // Navbar tetap di atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Navbar(onItemSelected: scrollToSection),
          ),
        ],
      ),
    );
  }
}
