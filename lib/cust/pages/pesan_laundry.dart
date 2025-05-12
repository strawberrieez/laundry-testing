import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_test/cust/pages/rincian_pesanan.dart';

class PesanLaundry extends StatefulWidget {
  final Map<String, dynamic> dataPemesanan;
  const PesanLaundry({Key? key, required this.dataPemesanan}) : super(key: key);

  @override
  State<PesanLaundry> createState() => _PesanLaundryState();
}

class _PesanLaundryState extends State<PesanLaundry> {
  String? jenisLayanan;
  String pengantaran = 'Antar-Jemput';
  final TextEditingController beratController = TextEditingController();

  List<Map<String, dynamic>> layananList = [];
  double? hargaLayanan;

  @override
  void initState() {
    super.initState();
    fetchLayanan();
  }

  Future<void> fetchLayanan() async {
    final snapshot = await FirebaseFirestore.instance.collection('laundry_service').get();
    final services =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return {'name': data['name'] ?? '', 'harga': data['harga'] != null ? (data['harga'] as num).toDouble() : 0.0};
        }).toList();

    setState(() {
      layananList = services;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
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
                      child: Text('Formulir Pemesanan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Isi formulir berikut untuk memesan layanan laundry',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text('Jenis Layanan', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: jenisLayanan,
                      decoration: _inputDecoration('Pilih layanan...'),
                      dropdownColor: Colors.white,
                      iconEnabledColor: const Color(0xff0278be),
                      items:
                          layananList.map((service) {
                            return DropdownMenuItem<String>(value: service['name'], child: Text(service['name']));
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          jenisLayanan = value;
                          final selectedService = layananList.firstWhere(
                            (service) => service['name'] == value,
                            orElse: () => {},
                          );
                          hargaLayanan = selectedService['harga'] ?? 0.0;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    const Text('Berat Pakaian (Kg)', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: beratController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Contoh: 5'),
                    ),
                    const SizedBox(height: 20),

                    // Removed price display as per user request
                    // if (hargaLayanan != null)
                    //   Text(
                    //     'Harga: Rp ${hargaLayanan!.toStringAsFixed(0)}',
                    //     style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff0278be)),
                    //   ),
                    // const SizedBox(height: 20),
                    const Text('Pengambilan / Pengantaran', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    RadioListTile<String>(
                      activeColor: const Color(0xff0278be),
                      title: const Text('Antar-Jemput'),
                      value: 'Antar-Jemput',
                      groupValue: pengantaran,
                      onChanged: (value) {
                        setState(() {
                          pengantaran = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      activeColor: const Color(0xff0278be),
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

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (jenisLayanan == null || beratController.text.isEmpty) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(const SnackBar(content: Text("Lengkapi formulir terlebih dahulu ya!")));
                            return;
                          }

                          final dataLaundry = {
                            'layanan': jenisLayanan,
                            'berat': beratController.text,
                            'harga': hargaLayanan,
                            'pengantaran': pengantaran,
                            'status': '',
                          };

                          final combinedData = {...widget.dataPemesanan, ...dataLaundry};

                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RincianPesanan(dataOrder: combinedData)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0278be),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Pesan Sekarang', style: TextStyle(color: Colors.white)),
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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
