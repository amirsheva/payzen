import 'package:flutter/material.dart';
import 'package:payzen/api_service.dart'; // <-- مسیر صحیح این است

class DebtDetailsScreen extends StatefulWidget {
  final int debtId;
  final String debtName;

  const DebtDetailsScreen({
    super.key,
    required this.debtId,
    required this.debtName,
  });

  @override
  State<DebtDetailsScreen> createState() => _DebtDetailsScreenState();
}

class _DebtDetailsScreenState extends State<DebtDetailsScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>?> _detailsFuture;

  @override
  void initState() {
    super.initState();
    // به محض باز شدن صفحه، جزئیات بدهی را از سرور درخواست می‌کنیم
    _detailsFuture = _apiService.getDebtDetails(widget.debtId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.debtName),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('امکان دریافت جزئیات وجود نداشت.'));
          }

          final debtDetails = snapshot.data!;
          final installments = debtDetails['installments'] as List<dynamic>? ?? [];

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // بخش اطلاعات کلی بدهی
              _buildInfoCard(debtDetails),
              const SizedBox(height: 24),
              // بخش لیست اقساط
              Text(
                'اقساط',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(),
              if (installments.isEmpty)
                const Text('قسطی برای این بدهی یافت نشد.')
              else
                ...installments.map((inst) => _buildInstallmentTile(inst)),
            ],
          );
        },
      ),
    );
  }

  // ویجت برای نمایش کارت اطلاعات کلی
  Widget _buildInfoCard(Map<String, dynamic> details) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('مبلغ کل:', '${details['total_amount']} تومان'),
            _buildInfoRow('تعداد اقساط:', '${details['number_of_installments']}'),
            _buildInfoRow('وضعیت:', details['status']),
          ],
        ),
      ),
    );
  }

  // ویجت برای نمایش یک ردیف از اطلاعات
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  // ویجت برای نمایش یک قسط در لیست
  Widget _buildInstallmentTile(Map<String, dynamic> installment) {
    final isPaid = installment['status'] == 'paid';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPaid ? Colors.green : Colors.orange,
        child: Text('${installment['installment_number']}'),
      ),
      title: Text('مبلغ: ${installment['amount_due']} تومان'),
      subtitle: Text('تاریخ سررسید: ${installment['due_date']}'), // TODO: Format date
      trailing: Checkbox(
        value: isPaid,
        onChanged: (value) {
          // TODO: پیاده‌سازی منطق پرداخت قسط
          print('Checkbox for installment ${installment['id']} changed');
        },
      ),
    );
  }
}
