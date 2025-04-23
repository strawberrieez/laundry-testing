import 'package:flutter/material.dart';

class StatusPesanan extends StatelessWidget {
  const StatusPesanan({super.key});

  // Status aktif, misal "Dicuci"
  final String statusAktif = "Dicuci";

  @override
  Widget build(BuildContext context) {
    final List<String> statusList = [
      "Diterima",
      "Dicuci",
      "Disetrika",
      "Siap Diambil"
    ];
    final List<String> waktuList = ["09:00", "11:00", "", ""];

    return Center(
      child: Column(
        children: [
          const Text(
            "Status Pesanan",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Lacak status pesanan Anda secara real-time",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(statusList.length, (index) {
                  final isAktif = statusList[index] == statusAktif;
                  return Expanded(
                    child: Column(
                      children: [
                        // Kotak status
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color:
                                isAktif ? Colors.black : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusList[index],
                            style: TextStyle(
                              color: isAktif ? Colors.white : Colors.black87,
                              fontWeight:
                                  isAktif ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          waktuList[index],
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }).expand((widget) sync* {
                  yield widget;
                  if (widget != statusList.length - 1) {
                    yield Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                    );
                  }
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
