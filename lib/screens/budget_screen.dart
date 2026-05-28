import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  final List<Map<String, dynamic>> budgets = [
    {'category': 'Food', 'limit': 10000, 'spent': 6000},
    {'category': 'Transport', 'limit': 5000, 'spent': 4500},
    {'category': 'Shopping', 'limit': 8000, 'spent': 2000},
    {'category': 'Bills', 'limit': 15000, 'spent': 14000},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(title: const Text('Budget'), backgroundColor: Colors.black87,),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final b = budgets[index];
          final spent = b['spent'] as int;
          final limit = b['limit'] as int;
          final progress = spent / limit;
          final isWarning = progress >= 0.8;

          return Card(
            color: Colors.grey.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        b['category'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹$spent / ₹$limit',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ], // ← Row children closes
                  ), // ← Row closes
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade800,
                    color: isWarning ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 8,
                  ),
                  if (isWarning)
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '⚠️ Over 80% of budget used!',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ], // ← Column children closes
              ), // ← Column closes
            ), // ← Padding closes
          ); // ← Card closes
        },
      ),
    );
  }
}
