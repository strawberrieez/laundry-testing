import 'package:flutter/material.dart';
import 'package:laundry_test/cust/pages/data_pemesanan.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: isMobile ? 40 : 60,
          ),
          color: Colors.white,
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextContent(context, isMobile),
                    const SizedBox(height: 30),
                    _buildImagePlaceholder(isMobile),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 1, child: _buildTextContent(context, isMobile)),
                    const SizedBox(width: 40),
                    Expanded(flex: 1, child: _buildImagePlaceholder(isMobile)),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildTextContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layanan Laundry\nTerpercaya',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Percayakan pakaian Anda kepada kami. '
          'Layanan laundry profesional dengan sistem pelacakan status pesanan real-time.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataPemesananPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.black,
              ),
              child: const Text('Pesan Sekarang'),
            ),
            OutlinedButton(
              onPressed: () {
                // Bisa diisi logika untuk pelacakan pesanan
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Text(
                'Lacak Pesanan',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(bool isMobile) {
    return Container(
      height: isMobile ? 300 : 300,
      width: double.infinity,
      color: Colors.grey[100],
      child: Image.asset(
        'assets/images/header.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
