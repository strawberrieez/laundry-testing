import 'package:flutter/material.dart';

class DetailPesananPage extends StatelessWidget {
  final String namaPelanggan = 'Amelia Andini';
  final String alamat = 'Jl. Merdeka No.123, Subang';
  final String nomorHP = '0812-3456-7890';
  final String jenisLayanan = 'Cuci Kering';
  final String berat = '4.5';
  final List<String> jenisPakaian = ['Kemeja', 'Celana', 'Jaket'];
  final String pengantaran = 'Antar Jemput';
  final int currentStep = 1; // 0 = Diterima, 1 = Dicuci, dst.

  DetailPesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    double beratPakaian = double.tryParse(berat) ?? 0;
    double subtotal =
        beratPakaian * 5000 + (jenisLayanan == 'Cuci Kering' ? 2000 : 0);
    double ongkir = 5000;
    double total = subtotal + ongkir;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Pesanan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
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
                    _detailRow('Jenis Pakaian', jenisPakaian.join(', ')),
                    _detailRow('Pengantaran', pengantaran),
                  ]),
                  const SizedBox(height: 16),
                  _sectionCard('Rincian Pembayaran', [
                    _detailRow('Subtotal', 'Rp ${subtotal.toStringAsFixed(0)}'),
                    _detailRow('Ongkir', 'Rp ${ongkir.toStringAsFixed(0)}'),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          'Rp ${total.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ],
                    )
                  ]),
                  const SizedBox(height: 24),
                  _statusSection(currentStep),
                ],
              ),
            ),
          ),
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
          Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _statusSection(int current) {
    final List<Map<String, String>> steps = [
      {'title': 'Diterima', 'time': '09:00'},
      {'title': 'Dicuci', 'time': '11:00'},
      {'title': 'Disetrika', 'time': '--:--'},
      {'title': 'Siap Diambil', 'time': '--:--'},
    ];

    return Column(
      children: [
        const Text('Status Pesanan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Lacak status pesanan Anda secara real-time',
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final isActive = index == current;
            return Expanded(
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.black : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      steps[index]['title']!,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[index]['time']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            );
          })
              .expand((widget) => [
                    widget,
                    if (widget != steps.last) const SizedBox(width: 8),
                  ])
              .toList(),
        ),
      ],
    );
  }
}
