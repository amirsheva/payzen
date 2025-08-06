import 'package:flutter/material.dart';
import 'package:payzen/api_service.dart';
import 'package:payzen/screens/add_debt_screen.dart';
import 'package:payzen/screens/welcome_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _debtsFuture;

  @override
  void initState() {
    super.initState();
    _loadDebts();
  }

  void _loadDebts() {
    setState(() {
      _debtsFuture = _apiService.getDebts();
    });
  }

  void _navigateAndRefresh() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (ctx) => const AddDebtScreen()),
    );

    // اگر از صفحه افزودن بدهی با موفقیت برگشتیم، لیست را رفرش کن
    if (result == true) {
      _loadDebts();
    }
  }

  void _handleLogout() async {
    await _apiService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const WelcomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _debtsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('You have no debts yet. Add one!'),
            );
          }

          final debts = snapshot.data!;
          return ListView.builder(
            itemCount: debts.length,
            itemBuilder: (context, index) {
              final debt = debts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(debt['debt_name'] ?? 'No Name'),
                  subtitle: Text('Total Amount: ${debt['total_amount']}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    print('Tapped on debt: ${debt['id']}');
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndRefresh,
        child: const Icon(Icons.add),
        tooltip: 'Add New Debt',
      ),
    );
  }
}
