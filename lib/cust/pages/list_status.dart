import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundry_test/cust/pages/status_pesanan.dart'; // Import DetailPesananPage

class ListStatus extends StatelessWidget {
  const ListStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('data_pemesanan')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var pesanan = data[index];
              var tanggalPemesanan = pesanan['timestamp'] != null
                  ? (pesanan['timestamp'] as Timestamp).toDate()
                  : DateTime.now();
              var formattedDate = "${tanggalPemesanan.day}-${tanggalPemesanan.month}-${tanggalPemesanan.year}";

              var pesananData = {
                'nama': pesanan['nama'] ?? '-',
                'alamat': pesanan['alamat'] ?? '-',
                'no_hp': pesanan['no_hp'] ?? '-',
                'layanan': pesanan['layanan'] ?? '-',
                'berat': pesanan['berat']?.toString() ?? '0',
                'pengantaran': pesanan['pengantaran'] ?? '-',
                'status': pesanan['status'] ?? '-',
                'pembayaran': pesanan['pembayaran'] ?? '-',
              };

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  title: Text('Pesanan pada $formattedDate', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Klik untuk melihat status pemesanan'),
                  leading: const Icon(Icons.local_laundry_service, color: Color(0xff0278be)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPesananPage(dataOrder: pesananData)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
