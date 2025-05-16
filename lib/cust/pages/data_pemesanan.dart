import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_test/cust/pages/pesan_laundry.dart';

class DataPemesananPage extends StatelessWidget {
  const DataPemesananPage({super.key});

  Future<String> generateOrderId() async {
    final snapshot = await FirebaseFirestore.instance.collection('data_pemesanan').get();
    final count = snapshot.docs.length + 1;
    return 'ORD_${count.toString().padLeft(4, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController alamatController = TextEditingController();
    final TextEditingController noHpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text('Data Pemesan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Silakan lengkapi data diri Anda untuk melanjutkan pemesanan',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: namaController,
                        decoration: _inputDecoration('Masukkan nama lengkap Anda', Icons.person),
                      ),
                      const SizedBox(height: 30),
                      const Text('Alamat Lengkap', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: alamatController,
                        decoration: _inputDecoration('Masukkan alamat lengkap Anda', Icons.location_on),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 30),
                      const Text('Nomor HP', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: noHpController,
                        decoration: _inputDecoration('Contoh: 08123456789', Icons.phone),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (namaController.text.isEmpty ||
                                alamatController.text.isEmpty ||
                                noHpController.text.length < 10) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text("Harap isi data dengan lengkap")));
                              return;
                            }

                            final dataPemesanan = {
                              'nama': namaController.text,
                              'alamat': alamatController.text,
                              'no_hp': noHpController.text,
                            };

                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PesanLaundry(dataPemesanan: dataPemesanan)),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0278be),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Lanjutkan', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Color(0xff0278be)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xff0278be)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xff0278be)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xff0278be), width: 2),
      ),
    );
  }
}
