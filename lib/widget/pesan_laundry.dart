import 'package:flutter/material.dart';
import 'package:laundry_test/main.dart';

class PesanLaundry extends StatefulWidget {
  const PesanLaundry({super.key});

  @override
  State<PesanLaundry> createState() => _PesanLaundryState();
}

class _PesanLaundryState extends State<PesanLaundry> {
  String? jenisLayanan;
  String pengantaran = 'Antar-Jemput';
  final TextEditingController beratController = TextEditingController();
  final List<String> jenisPakaianDipilih = [];

  final List<String> jenisPakaian = [
    'Pakaian Biasa',
    'Pakaian Dalam',
    'Selimut/Bed Cover',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0), // Margin di sekitar form
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1000, // Lebar form lebih lebar untuk desktop
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0), // Padding di dalam form
              child: Container(
                padding: const EdgeInsets.all(32.0), // Padding di dalam form
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul
                    const Center(
                      child: Text(
                        'Formulir Pemesanan',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Isi formulir berikut untuk memesan layanan laundry',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Jenis Layanan
                    const Text(
                      'Jenis Layanan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: jenisLayanan,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Pilih layanan...',
                      ),
                      items: ['Cuci Kering', 'Cuci Basah', 'Setrika']
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          jenisLayanan = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Berat Pakaian
                    const Text(
                      'Berat Pakaian (Kg)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: beratController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Contoh: 5',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Jenis Pakaian
                    const Text(
                      'Jenis Pakaian',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    ...jenisPakaian.map((pakaian) {
                      return CheckboxListTile(
                        title: Text(pakaian),
                        value: jenisPakaianDipilih.contains(pakaian),
                        onChanged: (selected) {
                          setState(() {
                            selected! ? jenisPakaianDipilih.add(pakaian) : jenisPakaianDipilih.remove(pakaian);
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }),
                    const SizedBox(height: 20),

                    // Pengantaran
                    const Text(
                      'Pengambilan / Pengantaran',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile(
                      title: const Text('Antar-Jemput'),
                      value: 'Antar-Jemput',
                      groupValue: pengantaran,
                      onChanged: (value) {
                        setState(() {
                          pengantaran = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('Ambil Sendiri'),
                      value: 'Ambil Sendiri',
                      groupValue: pengantaran,
                      onChanged: (value) {
                        setState(() {
                          pengantaran = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 30),

                    // Tombol Submit
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Setelah klik, arahkan ke halaman home
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()), // Gantilah dengan halaman utama yang sesuai
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Pesan Sekarang',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
