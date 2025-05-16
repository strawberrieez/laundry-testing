import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundry_test/cust/pages/home_pages.dart';

class RincianPesanan extends StatefulWidget {
  final Map<String, dynamic> dataOrder;

  const RincianPesanan({super.key, required this.dataOrder});

  @override
  State<RincianPesanan> createState() => _RincianPesananState();
}

class _RincianPesananState extends State<RincianPesanan> {
  String metodePembayaran = 'QRIS';
  double? hargaLayanan;
  bool isLoadingHarga = true;

  @override
  void initState() {
    super.initState();
    _fetchHargaLayanan();
  }

  Future<void> _fetchHargaLayanan() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('laundry_service')
            .where('name', isEqualTo: widget.dataOrder['layanan'])
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      final harga = data['price'];
      final hargaParsed =
          harga is int ? harga.toDouble() : double.tryParse(harga.toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

      setState(() {
        hargaLayanan = hargaParsed;
        isLoadingHarga = false;
      });
    } else {
      setState(() {
        hargaLayanan = 0;
        isLoadingHarga = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingHarga) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final data = widget.dataOrder;
    double beratPakaian = double.tryParse(data['berat']) ?? 0;
    double hargaPerKg = hargaLayanan ?? 0;
    double tambahanCuciKering = data['layanan'] == 'Cuci Kering' ? 2000 : 0;
    double subtotal = beratPakaian * hargaPerKg + tambahanCuciKering;
    double ongkir = data['pengantaran'] == 'Antar-Jemput' ? 5000 : 0;
    double total = subtotal + ongkir;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Dialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // fix jarak dari AppBar ke dialog
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rincian Pesanan',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  _buildCardSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Informasi Pelanggan'),
                        const SizedBox(height: 8),
                        _buildDetailRow('Nama', data['nama']),
                        _buildDetailRow('Alamat', data['alamat']),
                        _buildDetailRow('Nomor HP', data['no_hp']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Detail Pesanan'),
                        const SizedBox(height: 8),
                        _buildDetailRow('Jenis Layanan', data['layanan']),
                        _buildDetailRow('Berat Pakaian', '${data['berat']} kg'),
                        _buildDetailRow('Pengantaran', data['pengantaran']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Rincian Pembayaran'),
                        const SizedBox(height: 8),
                        _buildDetailRow('Harga per Layanan', 'Rp ${hargaPerKg.toStringAsFixed(0)}'),
                        _buildDetailRow('Subtotal', 'Rp ${subtotal.toStringAsFixed(0)}'),
                        _buildDetailRow('Ongkir', 'Rp ${ongkir.toStringAsFixed(0)}'),
                        const Divider(height: 30, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Bayar',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                            ),
                            Text(
                              'Rp ${total.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Pilih Metode Pembayaran'),
                        const SizedBox(height: 8),
                        _buildPaymentOption('QRIS'),
                        _buildPaymentOption('Tunai'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0278be),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            try {
                              final docId = await _saveOrderData();
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      title: const Text('Pembayaran Berhasil'),
                                      content: Text('Pembayaran melalui $metodePembayaran berhasil.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => const HomePage()),
                                              (route) => false,
                                            );
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan data pesanan')));
                              }
                            }
                          },
                          child: const Text('Lanjutkan Pembayaran'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _generateCustomDocId() async {
    final snapshot = await FirebaseFirestore.instance.collection('data_pemesanan').get();
    final count = snapshot.docs.length + 1;
    return 'RD_${count.toString().padLeft(4, '0')}';
  }

  Future<String> _saveOrderData() async {
    final data = widget.dataOrder;
    double beratPakaian = double.tryParse(data['berat']) ?? 0;
    double hargaPerKg = hargaLayanan ?? 0;
    double tambahanCuciKering = data['layanan'] == 'Cuci Kering' ? 2000 : 0;
    double subtotal = beratPakaian * hargaPerKg + tambahanCuciKering;
    double ongkir = data['pengantaran'] == 'Antar-Jemput' ? 5000 : 0;
    double total = subtotal + ongkir;

    final docId = await _generateCustomDocId();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('data_pemesanan').doc(docId).set({
      'uid': uid,
      'nama': data['nama'],
      'alamat': data['alamat'],
      'no_hp': data['no_hp'],
      'layanan': data['layanan'],
      'berat': data['berat'],
      'pengantaran': data['pengantaran'],
      'status': data['status'],
      'pembayaran': metodePembayaran,
      'total_bayar': total,
      'timestamp': FieldValue.serverTimestamp(),
    });
    return docId;
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87));
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14))),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: valueStyle ?? const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    return RadioListTile<String>(
      title: Text(method, style: const TextStyle(fontSize: 14)),
      value: method,
      groupValue: metodePembayaran,
      onChanged: (value) {
        setState(() {
          metodePembayaran = value!;
        });
      },
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      activeColor: const Color(0xFF0278BE),
    );
  }

  Widget _buildCardSection({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}
