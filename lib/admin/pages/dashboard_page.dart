import 'package:flutter/material.dart';
import 'package:laundry_test/admin/pages/order_pages.dart';
import 'package:laundry_test/admin/widgets/latest_orders.dart';
import 'package:laundry_test/admin/widgets/service.management.dart';
import 'package:laundry_test/admin/widgets/summary_cards.dart';
import '../widgets/sidebar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedMenu = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    Widget content;

    if (selectedMenu == 'Dashboard') {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 16),
          Text("Dashboard Admin", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          SummaryCards(),
          SizedBox(height: 32),
          RecentOrders(),
          // SizedBox(height: 32),
          // ServiceManagement(),
        ],
      );
    } else if (selectedMenu == 'Pesanan') {
      content = const OrdersPage();
    } else if (selectedMenu == 'Layanan') {
      content = const ServiceManagement();
    } else {
      content = Center(child: Text('Halaman "$selectedMenu" belum tersedia'));
    }

    return Scaffold(
      drawer:
          isMobile
              ? Drawer(
                child: SideBar(
                  selectedMenu: selectedMenu,
                  onMenuTap: (menu) {
                    setState(() {
                      selectedMenu = menu;
                    });
                    Navigator.pop(context); // tutup drawer di mobile
                  },
                ),
              )
              : null,
      appBar: isMobile ? AppBar(title: const Text("Dashboard Admin"), backgroundColor: Colors.deepPurple) : null,
      body: Row(
        children: [
          if (!isMobile)
            SideBar(
              selectedMenu: selectedMenu,
              onMenuTap: (menu) {
                setState(() => selectedMenu = menu);
              },
            ),
          Expanded(
            child:
                selectedMenu == 'Pesanan'
                    ? const OrdersPage()
                    : Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: content),
                    ),
          ),
        ],
      ),
    );
  }
}
