import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String selectedPeriode = 'Bulan Ini';
  String searchQuery = '';

  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('data_pemesanan').get();
      final fetchedTransactions =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'nama': data['nama'] ?? '',
              'alamat': data['alamat'] ?? '',
              'layanan': data['layanan'] ?? '',
              'total_bayar': data['total_bayar'] ?? 0,
              'pembayaran': data['pembayaran'] ?? '',
              'status': data['status'] ?? '',
            };
          }).toList();

      setState(() {
        transactions = fetchedTransactions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Optionally handle error, e.g., show a snackbar
    }
  }

  List<Map<String, dynamic>> get filteredTransactions =>
      transactions
          .where((tx) => tx.values.any((val) => val.toString().toLowerCase().contains(searchQuery.toLowerCase())))
          .toList();

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    final totals =
        filteredTransactions.where((tx) => (tx['status'] ?? '').toString().toLowerCase() != 'dicancel').map((tx) {
          if (tx['total_bayar'] is int) {
            return tx['total_bayar'] as int;
          } else if (tx['total_bayar'] is String) {
            return int.tryParse((tx['total_bayar'] as String).replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          }
          return 0;
        }).toList();

    final totalPendapatan = totals.fold(0, (sum, val) => sum + val);

    // Calculate rataRata from all transactions in database excluding 'dicancel'
    final allValidTransactions =
        transactions.where((tx) => (tx['status'] ?? '').toString().toLowerCase() != 'dicancel').toList();
    final allTotals =
        allValidTransactions.map((tx) {
          if (tx['total_bayar'] is int) {
            return tx['total_bayar'] as int;
          } else if (tx['total_bayar'] is String) {
            return int.tryParse((tx['total_bayar'] as String).replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          }
          return 0;
        }).toList();

    final rataRata = allTotals.isNotEmpty ? allTotals.reduce((a, b) => a + b) ~/ allTotals.length : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Laundry'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilters(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _buildStatCard("Total Pendapatan", currencyFormat.format(totalPendapatan))),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard("Rata-rata Pesanan", currencyFormat.format(rataRata))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildReportSection(),
                  ],
                ),
              ),
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // ElevatedButton.icon(
        //   icon: const Icon(Icons.table_view),
        //   label: const Text("Export Excel"),
        //   onPressed: () {
        //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Export Excel belum tersedia")));
        //   },
        // ),
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
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildReportHeader("Detail Transaksi Keuangan"), const SizedBox(height: 16), _buildTransactionTable()],
    );
  }

  Widget _buildReportHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari transaksi...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
        children: [_buildTableHeader(), const Divider(height: 0), ...filteredTransactions.map(_buildTableRow)],
      ),
    );
  }

  Widget _buildTableHeader() {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: const [
          Expanded(child: Text("Nama", style: style)),
          Expanded(child: Text("Alamat", style: style)),
          Expanded(child: Text("Layanan", style: style)),
          Expanded(child: Text("Total", style: style)),
          Expanded(child: Text("Metode", style: style)),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> tx) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(tx['nama'] ?? '')),
          Expanded(child: Text(tx['alamat'] ?? '')),
          Expanded(child: Text(tx['layanan'] ?? '')),
          Expanded(child: Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(tx['total_bayar'] ?? 0))),
          Expanded(child: Text(tx['pembayaran'] ?? '')),
        ],
      ),
    );
  }
}
