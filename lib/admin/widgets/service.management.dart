import 'package:flutter/material.dart';

class ServiceManagement extends StatefulWidget {
  const ServiceManagement({super.key});

  @override
  State<ServiceManagement> createState() => _ServiceManagementState();
}

class _ServiceManagementState extends State<ServiceManagement> {
  final List<Service> services = [
    Service("Cuci Kering", "Rp 7.000/kg", true),
    Service("Cuci Setrika", "Rp 10.000/kg", true),
    Service("Express (6 Jam)", "Rp 15.000/kg", true),
    Service("Selimut/Bed Cover", "Rp 25.000/pcs", false),
  ];

  void _editService(Service service) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit layanan: ${service.name}')));
  }

  void _deleteService(Service service) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hapus layanan: ${service.name}')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Manajemen Layanan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: DataTable(
              columnSpacing: 16, // Sama seperti yang di "RecentOrders"
              columns: const [
                DataColumn(label: Text("Nama Layanan")),
                DataColumn(label: Text("Harga")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Aksi")),
              ],
              rows:
                  services.map((service) {
                    return DataRow(
                      cells: [
                        DataCell(Text(service.name)),
                        DataCell(Text(service.price)),
                        DataCell(
                          Switch(
                            value: service.active,
                            onChanged: (newValue) {
                              setState(() {
                                service.active = newValue;
                              });
                            },
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 16),
                                tooltip: 'Edit',
                                onPressed: () => _editService(service),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 16),
                                tooltip: 'Hapus',
                                onPressed: () => _deleteService(service),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
        // Tombol "Tambah Layanan" di sebelah kanan
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, // Menempatkan tombol di sebelah kanan
            children: [
              ElevatedButton(
                onPressed: () {
                  // Aksi untuk menambah layanan baru
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tambah layanan baru')));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  backgroundColor: const Color(0xff0278be),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // <<--- Tambah rounded dikit
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text('Tambah layanan baru', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Service {
  final String name;
  final String price;
  bool active;

  Service(this.name, this.price, this.active);
}
