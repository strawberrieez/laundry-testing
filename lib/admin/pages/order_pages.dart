import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _selectedStatus = 'diproses';

  String? _getNextStatus(String currentStatus) {
    const statusFlow = ['diproses', 'dicuci', 'disetrika', 'selesai'];
    final currentIndex = statusFlow.indexOf(currentStatus);
    if (currentIndex == -1 || currentIndex == statusFlow.length - 1) {
      return null;
    }
    return statusFlow[currentIndex + 1];
  }

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

  IconData _getStatusIcon(String status) {
    return {
          'diproses': Icons.access_time,
          'dicuci': Icons.water_drop,
          'disetrika': Icons.checkroom,
          'selesai': Icons.check_circle,
        }[status] ??
        Icons.help_outline;
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, String nextStatus) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Apakah kamu yakin ingin mengubah status menjadi $nextStatus?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Ya')),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildStatusFilter(), _buildTableHeader(), _buildOrderList()],
      ),
    );
  }

  Widget _buildStatusFilter() {
    final statuses = ['diproses', 'dicuci', 'disetrika', 'selesai'];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text("Manajemen Pesanan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children:
                  statuses.map((status) {
                    final isSelected = _selectedStatus == status;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStatus = status;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                isSelected
                                    ? Border(bottom: BorderSide(color: _getStatusColor(status), width: 3))
                                    : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            status[0].toUpperCase() + status.substring(1),
                            style: TextStyle(
                              color: isSelected ? _getStatusColor(status) : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    final headers = ['ID PESANAN', 'PELANGGAN', 'ALAMAT', 'LAYANAN', 'BERAT', 'TANGGAL MASUK', 'TOTAL', 'STATUS'];
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
                return status == _selectedStatus;
              }).toList();

          if (filteredDocs.isEmpty) {
            return Center(child: Text("Belum ada pesanan yang $_selectedStatus."));
          }

          return ListView(
            children:
                filteredDocs.map((doc) {
                  final timestamp = doc['timestamp']?['diproses']?.toDate() ?? DateTime.now();
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
                        Expanded(child: Text(doc['alamat'] ?? '-', style: const TextStyle(color: Color(0xFF666666)))),
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
                          child: Row(
                            children: [
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _getStatusColor(status),
                                  backgroundColor: _getStatusBg(status),
                                  side: BorderSide(color: _getStatusColor(status)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                                icon: Icon(_getStatusIcon(status), size: 16, color: _getStatusColor(status)),
                                label: Text(
                                  status[0].toUpperCase() + status.substring(1),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                                onPressed: () async {
                                  final nextStatus = _getNextStatus(status);
                                  if (nextStatus == null) return;
                                  final confirmed = await _showConfirmationDialog(context, nextStatus);
                                  if (confirmed != true) return;

                                  try {
                                    await FirebaseFirestore.instance.collection('data_pemesanan').doc(doc.id).update({
                                      'status': nextStatus,
                                      'timestamp.$nextStatus': FieldValue.serverTimestamp(),
                                    });

                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(content: Text('Status updated to $nextStatus')));
                                  } catch (e) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
                                  }
                                },
                              ),
                            ],
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
