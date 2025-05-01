import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 4;
    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth < 900) {
      crossAxisCount = 3;
    }

    final now = DateTime.now();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('data_pemesanan').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final docs = snapshot.data!.docs;

        int pesananHariIni = 0;
        int dalamProses = 0;
        double pendapatanHariIni = 0;
        final Set<String> pelangganUnik = {};

        for (var doc in docs) {
          final ts = doc['timestamp']?.toDate() ?? DateTime(2000);
          final selisihJam = now.difference(ts).inHours;

          final nama = doc['nama'] ?? '';
          final nohp = doc['no_hp'] ?? '';

          pelangganUnik.add('$nama|$nohp');

          if (selisihJam <= 24) {
            pesananHariIni++;

            // if ((doc['status'] ?? 'Menunggu') == 'Menunggu') {
            //   dalamProses++;
            // }

            final berat = double.tryParse(doc['berat']?.toString() ?? '0') ?? 0;
            pendapatanHariIni += berat * 10000;
          }
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SummaryCard(
              title: "Pesanan Hari Ini",
              value: pesananHariIni.toString(),
              percentage: "+12%", // placeholder
              subtitle: "dari kemarin",
              icon: Icons.event_note,
              color: Colors.indigo,
            ),
            SummaryCard(
              title: "Dalam Proses",
              value: dalamProses.toString(),
              percentage: "-3%", // placeholder
              subtitle: "dari kemarin",
              icon: Icons.sync,
              color: Colors.yellow,
            ),
            SummaryCard(
              title: "Pendapatan Hari Ini",
              value: "Rp ${NumberFormat("#,###", "id_ID").format(pendapatanHariIni)}",
              percentage: "+8%", // placeholder
              subtitle: "dari kemarin",
              icon: Icons.attach_money,
              color: Colors.green,
            ),
            SummaryCard(
              title: "Total Pelanggan",
              value: pelangganUnik.length.toString(),
              percentage: "+5%", // placeholder
              subtitle: "bulan ini",
              icon: Icons.person,
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title, value, percentage, subtitle;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text("$percentage $subtitle", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}
