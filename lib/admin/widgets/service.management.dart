import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceManagement extends StatefulWidget {
  const ServiceManagement({super.key});

  @override
  State<ServiceManagement> createState() => _ServiceManagementState();
}

class _ServiceManagementState extends State<ServiceManagement> {
  List<Service> services = [];

  void _deleteService(Service service) async {
    final query =
        await FirebaseFirestore.instance
            .collection('laundry_service')
            .where('name', isEqualTo: service.name)
            .where('price', isEqualTo: service.price)
            .limit(1)
            .get();
    if (query.docs.isNotEmpty) {
      final docId = query.docs.first.id;
      await FirebaseFirestore.instance.collection('laundry_service').doc(docId).delete();
      setState(() {
        services.remove(service);
      });
    }
  }

  Future<void> _createServiceInFirestore(String name, String price, String satuan) async {
    await FirebaseFirestore.instance.collection('laundry_service').add({
      'name': name,
      'price': price,
      'active': true,
      'satuan': satuan,
    });
  }

  void _showAddServiceDialog() {
    final formKey = GlobalKey<FormState>();
    String newName = '';
    String newPrice = '';
    String newSatuan = 'per kg';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: StatefulBuilder(
                  builder: (context, setModalState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Tambah Layanan Baru', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Nama Layanan', border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama layanan harus diisi';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            newName = value;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Harga', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harga harus diisi';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Harga harus berupa angka';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            newPrice = value;
                          },
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Satuan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('per kg'),
                                value: 'per kg',
                                groupValue: newSatuan,
                                onChanged: (value) {
                                  setModalState(() {
                                    newSatuan = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('per pcs'),
                                value: 'per pcs',
                                groupValue: newSatuan,
                                onChanged: (value) {
                                  setModalState(() {
                                    newSatuan = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Batal'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await _createServiceInFirestore(newName, 'Rp $newPrice', newSatuan);
                                  setState(() {
                                    services.add(Service(newName, 'Rp $newPrice', true, newSatuan));
                                  });
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Tambah'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Manajemen Layanan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _showAddServiceDialog,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Tambah layanan baru", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0278be),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Table header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
              child: Row(
                children: const [
                  Expanded(child: Text("Nama Layanan", style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text("Harga", style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Text("Satuan", style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(child: Center(child: Text("Status", style: TextStyle(fontWeight: FontWeight.w600)))),
                  Expanded(child: Center(child: Text("Aksi", style: TextStyle(fontWeight: FontWeight.w600)))),
                ],
              ),
            ),

            // Table data
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('laundry_service').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) return const Center(child: Text("Belum ada layanan."));

                  services =
                      docs.map((doc) {
                        final data = doc.data()! as Map<String, dynamic>;
                        return Service(
                          data['name'] ?? '',
                          data['price'] ?? '',
                          data['active'] ?? false,
                          data['satuan'] ?? 'per kg',
                        );
                      }).toList();

                  return ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                        child: Row(
                          children: [
                            Expanded(child: Text(service.name)),
                            Expanded(child: Text(service.price)),
                            Expanded(child: Text(service.satuan)),
                            Expanded(
                              child: Center(
                                child: Switch(
                                  value: service.active,
                                  onChanged: (newValue) async {
                                    final query =
                                        await FirebaseFirestore.instance
                                            .collection('laundry_service')
                                            .where('name', isEqualTo: service.name)
                                            .where('price', isEqualTo: service.price)
                                            .limit(1)
                                            .get();
                                    if (query.docs.isNotEmpty) {
                                      final docId = query.docs.first.id;
                                      await FirebaseFirestore.instance.collection('laundry_service').doc(docId).update({
                                        'active': newValue,
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteService(service),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Service {
  final String name;
  final String price;
  bool active;
  final String satuan;

  Service(this.name, this.price, this.active, this.satuan);
}
