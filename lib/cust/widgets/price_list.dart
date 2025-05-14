import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaftarHarga extends StatelessWidget {
  const DaftarHarga({super.key});

  static const List<String> defaultBenefits = ['Termasuk deterjen premium', 'Durasi 3 hari', 'Harga terjangkau'];

  static List<String> getBenefits(String name) {
    if (name == 'Express') {
      return ['Termasuk deterjen premium', 'Durasi 6 jam', 'Harga terjangkau'];
    }
    return defaultBenefits;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Daftar Harga',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Harga terjangkau dengan kualitas terbaik',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('laundry_service').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Terjadi kesalahan saat memuat data');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Text('Data layanan laundry tidak tersedia');
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16), // Ensure there's space above and below
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final name = data['name'] as String? ?? 'Unknown';
                            final price = data['price']?.toString() ?? '-';
                            final benefits = getBenefits(name);
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: _HargaCard(title: name, price: 'Rp $price', benefits: benefits),
                            );
                          }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HargaCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> benefits;

  const _HargaCard({required this.title, required this.price, required this.benefits});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300, // Tinggi tetap untuk semua kartu
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text('$price/kg', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children:
                    benefits.map((b) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(b, style: const TextStyle(fontSize: 14))),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
