import 'package:flutter/material.dart';
import 'package:laundry_test/cust/pages/data_pemesanan.dart';
import 'package:laundry_test/cust/widgets/order_status.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return SizedBox(
          height: isMobile ? 500 : 600,
          width: double.infinity,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(child: Image.asset('assets/images/laundry.png', fit: BoxFit.cover)),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white70, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),

              // Text and Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80, vertical: isMobile ? 40 : 80),
                child: Align(alignment: Alignment.centerLeft, child: _buildTextContent(context, isMobile)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextContent(BuildContext context, bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layanan Laundry Profesional\nPakaian Bersih Setiap Hari',
          style: TextStyle(fontSize: isMobile ? 28 : 42, fontWeight: FontWeight.bold, color: Colors.black, height: 1.2),
        ),
        const SizedBox(height: 20),
        const Text(
          'Percayakan pakaian Anda kepada kami.\nKami memberikan layanan laundry berkualitas tinggi\ndengan harga terjangkau dan pengiriman cepat.',
          style: TextStyle(fontSize: 17, color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DataPemesananPage()));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                backgroundColor: const Color(0xff0278be),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // <<--- Tambah rounded dikit
                ),
              ),
              child: const Text('Pesan Sekarang', style: TextStyle(color: Colors.white)),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StatusPesanan()));
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                side: const BorderSide(color: Color(0xff0278be)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // <<--- Tambah rounded dikit juga
                ),
              ),
              child: const Text('Lacak Pesanan', style: TextStyle(color: Color(0xff0278be))),
            ),
          ],
        ),
      ],
    );
  }
}
