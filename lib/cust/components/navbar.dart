import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_test/cust/pages/home_pages.dart';

class Navbar extends StatefulWidget {
  final Function(String section) onItemSelected;

  const Navbar({super.key, required this.onItemSelected});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String _activeSection = 'beranda';

  void _handleItemTap(String section) {
    widget.onItemSelected(section);
    setState(() {
      _activeSection = section;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 800) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('assets/images/logo-laundry.png', height: 40),
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

    final currentUser = FirebaseAuth.instance.currentUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/logo-laundry.png', height: 40),
              const SizedBox(width: 10),
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
          Row(
            children: [
              _buildMenuItem('Beranda', 'beranda'),
              _buildMenuItem('Layanan', 'harga'),
              _buildMenuItem('Kontak', 'kontak'),
              const SizedBox(width: 24),
              if (currentUser != null) _buildUserDropdown(currentUser),
            ],
          ),
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
          child: Text(label, style: TextStyle(color: isActive ? const Color(0xff0278be) : Colors.black, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildUserDropdown(User user) {
    final email = user.email ?? 'User';
    final initial = email.isNotEmpty ? email[0].toUpperCase() : '?';

    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (value) async {
        if (value == 'logout') {
          await FirebaseAuth.instance.signOut();
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          }
        }
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'email',
              enabled: false,
              child: Text(email, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(children: [Text('Logout', style: TextStyle(color: Colors.red))]),
            ),
          ],
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xff0278be),
        child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Kontak'),
              onTap: () {
                Navigator.pop(context);
                onItemSelected('kontak');
              },
            ),
          ],
        ),
      ),
    );
  }
}
