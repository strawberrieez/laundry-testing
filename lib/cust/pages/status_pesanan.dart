import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPesananPage extends StatelessWidget {
  final Map<String, dynamic> dataOrder;

  const DetailPesananPage({super.key, required this.dataOrder});

  Future<double> fetchHargaLayanan(String layanan) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('laundry_service').where('name', isEqualTo: layanan).limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      final harga = data['price'];
      return harga is int ? harga.toDouble() : double.tryParse(harga.toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    String namaPelanggan = dataOrder['nama'] ?? '-';
    String alamat = dataOrder['alamat'] ?? '-';
    String nomorHP = dataOrder['no_hp'] ?? '-';
    String jenisLayanan = dataOrder['layanan'] ?? '-';
    String berat = dataOrder['berat']?.toString() ?? '0';
    String pengantaran = dataOrder['pengantaran'] ?? '-';
    String status = dataOrder['status'] ?? '-';
    String metodePembayaran = dataOrder['pembayaran'] ?? '-';
    dynamic timestamp = dataOrder['timestamp'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder<double>(
          future: fetchHargaLayanan(jenisLayanan),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            double hargaPerLayanan = snapshot.data ?? 0;
            double beratPakaian = double.tryParse(berat) ?? 0;
            double tambahanCuciKering = jenisLayanan == 'Cuci Kering' ? 2000 : 0;
            double subtotal = beratPakaian * hargaPerLayanan + tambahanCuciKering;
            double ongkir = pengantaran == 'Antar-Jemput' ? 5000 : 0;
            double total = subtotal + ongkir;

            return LayoutBuilder(
              builder:
                  (context, constraints) => SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionCard('Informasi Pelanggan', [
                                    _detailRow('Nama', namaPelanggan),
                                    _detailRow('Nomor HP', nomorHP),
                                    _detailRow('Alamat', alamat),
                                  ]),
                                  const SizedBox(height: 16),
                                  _sectionCard('Detail Pesanan', [
                                    _detailRow('Jenis Layanan', jenisLayanan),
                                    _detailRow('Berat', '$berat kg'),
                                    _detailRow('Pengantaran', pengantaran),
                                  ]),
                                  const SizedBox(height: 16),
                                  _sectionCard('Rincian Pembayaran', [
                                    _detailRow('Metode Pembayaran', metodePembayaran),
                                    _detailRow(
                                      'Harga per Layanan',
                                      'Rp ${NumberFormat('#,###', 'id_ID').format(hargaPerLayanan)}',
                                    ),
                                    _detailRow('Subtotal', 'Rp ${NumberFormat('#,###', 'id_ID').format(subtotal)}'),
                                    _detailRow('Ongkir', 'Rp ${NumberFormat('#,###', 'id_ID').format(ongkir)}'),
                                    const Divider(),
                                    _detailRow('Total', 'Rp ${NumberFormat('#,###', 'id_ID').format(total)}'),
                                  ]),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: Column(children: [_statusSection(status, timestamp, jenisLayanan)]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _statusSection(String currentStatus, dynamic timestamp, String jenisLayanan) {
    final bool isCancelled = currentStatus.toLowerCase() == 'dicancel';
    final List<String> stepTitles =
        isCancelled
            ? ['Pesanan Ditolak oleh Admin', 'Sedang Dicuci', 'Sedang Disetrika', 'Pesanan Selesai']
            : ['Pesanan Diterima', 'Sedang Dicuci', 'Sedang Disetrika', 'Pesanan Selesai'];

    int getActiveStepIndex(String? status) {
      if (isCancelled) {
        return 0;
      }
      switch (status?.toLowerCase()) {
        case 'diproses':
          return 0;
        case 'dicuci':
          return 1;
        case 'disetrika':
          return 2;
        case 'selesai':
          return 3;
        default:
          return -1;
      }
    }

    int activeStepIndex = getActiveStepIndex(currentStatus);

    DateTime? getOrderDate() {
      try {
        if (timestamp is Timestamp) return timestamp.toDate();
        if (timestamp is DateTime) return timestamp;
        if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (timestamp is String) return DateTime.parse(timestamp);
      } catch (_) {}
      return null;
    }

    String getEstimatedCompletion() {
      DateTime? orderDate = getOrderDate();
      if (orderDate == null) return '-';

      final isExpress = jenisLayanan.toLowerCase() == 'express';
      final estimatedDate = isExpress ? orderDate : orderDate.add(const Duration(days: 3));

      return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(estimatedDate);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(child: Text('Status Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        const SizedBox(height: 4),
        const Center(child: Text('Lacak status pesanan Anda secara real-time', style: TextStyle(color: Colors.grey))),
        const SizedBox(height: 20),
        Column(
          children: List.generate(stepTitles.length, (index) {
            final isActive = index <= activeStepIndex;
            final isCancelledStep = isCancelled && index == 0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (index < stepTitles.length - 1)
                            Positioned(
                              top: 16,
                              child: Container(width: 2, height: 30, color: isActive ? Colors.blue : Colors.grey),
                            ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                isActive ? (isCancelledStep ? Colors.red : const Color(0xff0278be)) : Colors.grey,
                            child: Icon(
                              isActive ? Icons.check_circle : Icons.circle,
                              color: isActive ? Colors.white : Colors.grey[400],
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      stepTitles[index],
                      style: TextStyle(
                        color: isCancelledStep ? Colors.red : (isActive ? Colors.black : Colors.grey),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Text('-', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
