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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMobile
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _FooterLogo(),
                      SizedBox(height: 32),
                      _FooterLinks(isMobile: true),
                      SizedBox(height: 32),
                      _HubungiKamiSection(),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [_FooterLogo(), _FooterLinks(isMobile: false), _HubungiKamiSection()],
                  ),
              const SizedBox(height: 40),
              const Divider(color: Colors.white24),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  '© 2025 Made with ❤️ by Kia Laundry Team. All rights reserved',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLogo extends StatelessWidget {
  const _FooterLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/logo-laundry.png',
            width: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.local_laundry_service, size: 40, color: Colors.white70);
            },
          ),
          const SizedBox(height: 12),
          const Text(
            'Layanan laundry terpercaya dengan sistem\npelacakan status pesanan real-time.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final bool isMobile;
  const _FooterLinks({required this.isMobile});

  Widget _buildColumn(String title, List<String> items) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(e, style: const TextStyle(color: Colors.white60, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layananNames = ['Layanan cuci pakaian', 'Layanan antar jemput'];
    final info = ['Tentang Kami', 'Cara Pemesanan', 'FAQ', 'Kontak'];
    final legal = ['Syarat & Ketentuan', 'Kebijakan Privasi'];

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumn('Layanan', layananNames),
          const SizedBox(height: 20),
          _buildColumn('Informasi', info),
          const SizedBox(height: 20),
          _buildColumn('Legal', legal),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildColumn('Layanan', layananNames), _buildColumn('Informasi', info), _buildColumn('Legal', legal)],
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
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.white60))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hubungi Kami', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _kontakItem(
            Icons.location_on,
            'Jl. Tamansari No. 39, Mugarsari, Kec. Tamansari, Kab. Tasikmalaya, Jawa Barat 46196',
          ),
          _kontakItem(Icons.phone, '+62 859-5970-5944'),
          _kontakItem(Icons.email, 'kialaundry@kialaundry.com'),
          _kontakItem(Icons.access_time, 'Senin - Minggu: 07.00 - 21.00'),
          const SizedBox(height: 16),
          const Text('Ikuti Kami', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
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
      ),
    );
  }
}
