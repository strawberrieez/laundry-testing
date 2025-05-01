import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Navbar extends StatefulWidget {
  final Function(String section) onItemSelected;

  const Navbar({super.key, required this.onItemSelected});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String _activeSection = 'beranda'; // Default aktif pertama

  void _handleItemTap(String section) {
    widget.onItemSelected(section);
    setState(() {
      _activeSection = section; // Set aktif section
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Mobile Layout
    if (screenWidth < 800) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('assets/images/logo-laundry.png', height: 40),
        // title: const Text(
        //   'LOGO',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     color: Colors.indigo,
        //   ),
        // ),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
          ),
        ],
      );
    }

    // Desktop Layout
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/logo-laundry.png', height: 40),
              SizedBox(width: 10),
              Row(
                children: [
                  Text(
                    'Kia ',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff0278be),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Laundry',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffaa087c),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // const Text(
          //   'LOGO',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 20,
          //     color: Colors.indigo,
          //     letterSpacing: 1.5,
          //   ),
          // ),

          // Menu Items
          Row(
            children: [
              _buildMenuItem('Beranda', 'beranda'),
              _buildMenuItem('Layanan', 'harga'), // Layanan klik ke harga
              _buildMenuItem('Kontak', 'kontak'),
            ],
          ),

          // Masuk & Daftar
          // Row(
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {},
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.black,
          //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          //       ),
          //       child: const Text('Masuk', style: TextStyle(color: Colors.white)),
          //     ),
          //     const SizedBox(width: 10),
          //     OutlinedButton(
          //       onPressed: () {},
          //       style: OutlinedButton.styleFrom(
          //         side: const BorderSide(color: Colors.black),
          //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          //       ),
          //       child: const Text('Daftar', style: TextStyle(color: Colors.black)),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String label, String section) {
    final isActive = _activeSection == section;

    return InkWell(
      onTap: () => _handleItemTap(section),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(label, style: TextStyle(color: isActive ? Color(0xff0278be) : Colors.black, fontSize: 16)),
        ),
      ),
    );
  }
}

class NavigationDrawerMobile extends StatelessWidget {
  final Function(String section) onItemSelected;

  const NavigationDrawerMobile({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
                onItemSelected('beranda');
              },
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services),
              title: const Text('Layanan'),
              onTap: () {
                Navigator.pop(context);
                onItemSelected('harga');
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.price_change),
            //   title: const Text('Harga'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     onItemSelected('harga');
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Kontak'),
              onTap: () {
                Navigator.pop(context);
                onItemSelected('kontak');
              },
            ),
            // const Divider(),
            // ListTile(leading: const Icon(Icons.login), title: const Text('Masuk'), onTap: () {}),
            // ListTile(leading: const Icon(Icons.app_registration), title: const Text('Daftar'), onTap: () {}),
          ],
        ),
      ),
    );
  }
}
