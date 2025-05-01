import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RecentOrders extends StatelessWidget {
  const RecentOrders({super.key});

  void _terimaPesanan(BuildContext context, String docId) async {
    await FirebaseFirestore.instance.collection('data_pemesanan').doc(docId).update({'status': 'diproses'});
  }

  void _tolakPesanan(BuildContext context, String docId) async {
    await FirebaseFirestore.instance.collection('data_pemesanan').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pesanan Terbaru", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('data_pemesanan')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Belum ada pesanan."));
                }

                // 🔥 Hanya tampilkan pesanan dengan status "menunggu"
                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final status = doc['status'] ?? '';
                  return status == '';
                });

                final rows =
                    filteredDocs.map<DataRow>((doc) {
                      final timestamp = doc['timestamp']?.toDate() ?? DateTime.now();
                      final berat = double.tryParse(doc['berat']?.toString() ?? '0') ?? 0;
                      final hargaPerKg = 10000;
                      final total = berat * hargaPerKg;

                      return DataRow(
                        cells: [
                          DataCell(Text(doc.id)),
                          DataCell(Text(doc['nama'] ?? '-')),
                          DataCell(Text(doc['layanan'] ?? '-')),
                          DataCell(Text('$berat kg')),
                          DataCell(Text(DateFormat('dd MMM yyyy, HH:mm').format(timestamp))),
                          DataCell(Text('Rp ${NumberFormat("#,###", "id_ID").format(total)}')),
                          DataCell(
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => _terimaPesanan(context, doc.id),
                                  child: const Text("Terima", style: TextStyle(color: Colors.green)),
                                ),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: () => _tolakPesanan(context, doc.id),
                                  child: const Text("Tolak", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(label: Text("ID Pesanan")),
                        DataColumn(label: Text("Pelanggan")),
                        DataColumn(label: Text("Layanan")),
                        DataColumn(label: Text("Berat")),
                        DataColumn(label: Text("Tanggal Masuk")),
                        DataColumn(label: Text("Total")),
                        DataColumn(label: Text("Aksi")),
                      ],
                      rows: rows,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
