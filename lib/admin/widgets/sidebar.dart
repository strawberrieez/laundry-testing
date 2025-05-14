import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laundry_test/auth/login.dart';
import 'nav_item.dart';

class SideBar extends StatelessWidget {
  final String selectedMenu;
  final void Function(String) onMenuTap;

  const SideBar({super.key, required this.selectedMenu, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Image.asset('assets/images/logo-laundry.png', width: 80, height: 80),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 40),
          NavItem(title: 'Dashboard', selected: selectedMenu == 'Dashboard', onTap: () => onMenuTap('Dashboard')),
          NavItem(title: 'Pesanan', selected: selectedMenu == 'Pesanan', onTap: () => onMenuTap('Pesanan')),
          NavItem(title: 'Layanan', selected: selectedMenu == 'Layanan', onTap: () => onMenuTap('Layanan')),
          NavItem(title: 'Laporan', selected: selectedMenu == 'Laporan', onTap: () => onMenuTap('Laporan')),
          const Spacer(),
          const Divider(),
          SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text("Logout", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red)),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
