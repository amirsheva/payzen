import 'package:flutter/material.dart';
import 'package:payzen/api_service.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({super.key});

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _debtNameController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _installmentsController = TextEditingController();
  
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _handleSaveDebt() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isLoading = true; });

    final success = await _apiService.createDebt(
      debtName: _debtNameController.text,
      totalAmount: double.parse(_totalAmountController.text),
      numberOfInstallments: int.parse(_installmentsController.text),
    );

    setState(() { _isLoading = false; });

    if (success && mounted) {
      // پس از ساخت موفق، به صفحه قبل (داشبورد) برمی‌گردیم
      Navigator.of(context).pop(true); // true را برمی‌گردانیم تا داشبورد رفرش شود
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create debt. Please try again.')),
      );
    }
  }

  @override
  void dispose() {
    _debtNameController.dispose();
    _totalAmountController.dispose();
    _installmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Debt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _debtNameController,
                  decoration: const InputDecoration(labelText: 'Debt Name', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a name';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalAmountController,
                  decoration: const InputDecoration(labelText: 'Total Amount', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _installmentsController,
                  decoration: const InputDecoration(labelText: 'Number of Installments', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _handleSaveDebt,
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                        child: const Text('Save Debt'),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
