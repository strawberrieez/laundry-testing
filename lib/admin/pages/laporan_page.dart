import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String selectedPeriode = 'Bulan Ini';
  String searchQuery = '';

  final List<Map<String, String>> transactions = [
    {
      "tanggal": "11/04/2025",
      "id": "TRX-25041100001",
      "pelanggan": "Budi Santoso",
      "layanan": "Cuci Setrika",
      "total": "Rp 85.000",
      "status": "Lunas",
    },
    {
      "tanggal": "10/04/2025",
      "id": "TRX-25041000015",
      "pelanggan": "Dewi Lestari",
      "layanan": "Express",
      "total": "Rp 120.000",
      "status": "Lunas",
    },
    {
      "tanggal": "10/04/2025",
      "id": "TRX-25041000012",
      "pelanggan": "Ahmad Fauzi",
      "layanan": "Cuci Kering",
      "total": "Rp 65.000",
      "status": "Lunas",
    },
  ];

  List<Map<String, String>> get filteredTransactions =>
      transactions
          .where(
            (tx) => tx.values.any(
              (val) => val.toLowerCase().contains(searchQuery.toLowerCase()),
            ),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporan Laundry',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildFilters(),
          const SizedBox(height: 24),
          _buildSummaryStats(),
          const SizedBox(height: 24),
          _buildReportSection(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DropdownButton<String>(
          value: selectedPeriode,
          items: const [
            DropdownMenuItem(value: 'Bulan Ini', child: Text('Bulan Ini')),
            DropdownMenuItem(value: 'Bulan Lalu', child: Text('Bulan Lalu')),
          ],
          onChanged: (value) => setState(() => selectedPeriode = value!),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.table_view),
          label: const Text("Export Excel"),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Export Excel belum tersedia")),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryStats() {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
    );
    final totals =
        filteredTransactions
            .map(
              (tx) =>
                  int.tryParse(
                    tx['total']!.replaceAll(RegExp(r'[^0-9]'), ''),
                  ) ??
                  0,
            )
            .toList();

    final totalPendapatan = totals.fold(0, (sum, val) => sum + val);
    final rataRata = totals.isNotEmpty ? totalPendapatan ~/ totals.length : 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Total Pendapatan",
            currencyFormat.format(totalPendapatan),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            "Rata-rata Pesanan",
            currencyFormat.format(rataRata),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReportHeader("Detail Transaksi Keuangan"),
        const SizedBox(height: 16),
        _buildTransactionTable(),
      ],
    );
  }

  Widget _buildReportHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari transaksi...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
            ),
            onChanged: (value) => setState(() => searchQuery = value),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          const Divider(height: 0),
          ...filteredTransactions.map(_buildTableRow),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: const [
          Expanded(child: Text("Tanggal", style: style)),
          Expanded(child: Text("ID Transaksi", style: style)),
          Expanded(child: Text("Nama Pelanggan", style: style)),
          Expanded(child: Text("Layanan", style: style)),
          Expanded(child: Text("Total", style: style)),
          Expanded(child: Text("Status", style: style)),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, String> tx) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(tx['tanggal']!)),
          Expanded(child: Text(tx['id']!)),
          Expanded(child: Text(tx['pelanggan']!)),
          Expanded(child: Text(tx['layanan']!)),
          Expanded(child: Text(tx['total']!)),
          Expanded(child: Text(tx['status']!)),
        ],
      ),
    );
  }
}
