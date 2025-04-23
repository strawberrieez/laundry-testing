import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterLogo(),
                    const SizedBox(height: 32),
                    _FooterLinks(),
                    const SizedBox(height: 32),
                    _HubungiKamiSection(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 2, child: _FooterLogo()),
                    SizedBox(width: 40),
                    Expanded(flex: 5, child: _FooterLinks()),
                    SizedBox(width: 40),
                    Expanded(flex: 3, child: _HubungiKamiSection()),
                  ],
                ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '© 2024 Laundry Express. All rights reserved.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FooterLogo extends StatelessWidget {
  const _FooterLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'LOGO',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Layanan laundry terpercaya dengan sistem\npelacakan status pesanan real-time.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  Widget _buildColumn(String title, List<String> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                e,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      runSpacing: 20,
      children: [
        _buildColumn('Layanan', [
          'Cuci Kering',
          'Cuci Setrika',
          'Setrika Saja',
          'Express (6 Jam)',
        ]),
        _buildColumn('Informasi', [
          'Tentang Kami',
          'Cara Pemesanan',
          'FAQ',
          'Kontak',
        ]),
        _buildColumn('Legal', [
          'Syarat & Ketentuan',
          'Kebijakan Privasi',
        ]),
      ],
    );
  }
}

class _HubungiKamiSection extends StatelessWidget {
  const _HubungiKamiSection();

  Widget _kontakItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hubungi Kami',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        _kontakItem(Icons.location_on, 'Jl. Laundry No. 123, Jakarta Selatan'),
        _kontakItem(Icons.phone, '+62 812-3456-7890'),
        _kontakItem(Icons.email, 'info@laundryexpress.com'),
        _kontakItem(Icons.access_time, 'Senin - Minggu: 07.00 - 21.00'),
        const SizedBox(height: 16),
        const Text(
          'Ikuti Kami',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Icon(FontAwesomeIcons.facebookF, size: 18, color: Colors.white70),
            SizedBox(width: 16),
            Icon(FontAwesomeIcons.twitter, size: 18, color: Colors.white70),
            SizedBox(width: 16),
            Icon(FontAwesomeIcons.instagram, size: 18, color: Colors.white70),
            SizedBox(width: 16),
            Icon(FontAwesomeIcons.whatsapp, size: 18, color: Colors.white70),
          ],
        ),
      ],
    );
  }
}
