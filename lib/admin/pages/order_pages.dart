import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _searchQuery = '';

  Color _getStatusColor(String status) {
    return {
          'diproses': Colors.orange,
          'dicuci': Colors.blue,
          'disetrika': Colors.purple,
          'selesai': Colors.green,
        }[status] ??
        Colors.grey;
  }

  Color _getStatusBg(String status) {
    return {
          'diproses': const Color(0xFFFFF3DC),
          'dicuci': const Color(0xFFE6F2FF),
          'disetrika': const Color(0xFFF5E6FF),
          'selesai': const Color(0xFFE6FFE6),
        }[status] ??
        Colors.grey.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildSearchBox(), _buildTableHeader(), _buildOrderList()],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
        child: TextField(
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: const InputDecoration(
            hintText: 'Cari pesanan atau pelanggan...',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 4),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    final headers = ['ID PESANAN', 'PELANGGAN', 'LAYANAN', 'BERAT', 'TANGGAL MASUK', 'TOTAL', 'STATUS'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children:
            headers
                .map(
                  (title) => Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildOrderList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('data_pemesanan').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada pesanan."));
          }

          final filteredDocs =
              snapshot.data!.docs.where((doc) {
                final status = (doc['status'] ?? '').toString().toLowerCase();
                final q = _searchQuery.toLowerCase();
                final pelanggan = doc['nama']?.toString().toLowerCase() ?? '';
                final id = doc.id.toLowerCase();
                return status == 'diproses' && (id.contains(q) || pelanggan.contains(q));
              }).toList();

          if (filteredDocs.isEmpty) {
            return const Center(child: Text("Belum ada pesanan yang diproses."));
          }

          return ListView(
            children:
                filteredDocs.map((doc) {
                  final timestamp = doc['timestamp']?.toDate() ?? DateTime.now();
                  final berat = doc['berat'] ?? '-';
                  final status = (doc['status'] ?? '-').toString().toLowerCase();
                  final beratDisplay = berat.toString().endsWith('kg') ? berat : '$berat kg';
                  final total = (double.tryParse(doc['berat']?.toString() ?? '0') ?? 0) * 10000;

                  return Container(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(child: Text(doc.id, style: const TextStyle(fontWeight: FontWeight.w500))),
                        Expanded(child: Text(doc['nama'] ?? '-', style: const TextStyle(color: Color(0xFF666666)))),
                        Expanded(child: Text(doc['layanan'] ?? '-', style: const TextStyle(color: Color(0xFF666666)))),
                        Expanded(child: Text(beratDisplay, style: const TextStyle(color: Color(0xFF666666)))),
                        Expanded(child: Text(DateFormat('dd MMM yyyy').format(timestamp))),
                        Expanded(
                          child: Text(
                            'Rp ${NumberFormat("#,###", "id_ID").format(total)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusBg(status),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              status[0].toUpperCase() + status.substring(1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
