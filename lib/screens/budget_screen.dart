import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/providers/transaction_provider.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionProvider);
    final transactions = transactionsAsync.when(
      loading: () => <Map<String, dynamic>>[],
      error: (e, st) => <Map<String, dynamic>>[],
      data: (data) => data,
    );

    Map<String, double> spentByCategory = {};
    for (final t in transactions) {
      if (t['type'] == 'expense') {
        final category = t['title'] as String;
        spentByCategory[category] =
            (spentByCategory[category] ?? 0) + (t['amount'] as num).toDouble();
      }
    }

    final budgets = [
      {
        'category': 'Food',
        'limit': 10000,
        'spent': spentByCategory['Food'] ?? 0,
      },
      {
        'category': 'Transport',
        'limit': 5000,
        'spent': spentByCategory['Transport'] ?? 0,
      },
      {
        'category': 'Shopping',
        'limit': 8000,
        'spent': spentByCategory['Shopping'] ?? 0,
      },
      {
        'category': 'Bills',
        'limit': 15000,
        'spent': spentByCategory['Bills'] ?? 0,
      },
    ];
    return Scaffold(
      backgroundColor: Colors.black87,
      endDrawer: Drawer(
        backgroundColor: Colors.black87,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey.shade900,
              padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.brown.shade900,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Parth",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('parth@gmail.com', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Budget'),
        backgroundColor: Colors.black87,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final b = budgets[index];
          final spent = (b['spent'] as num).toDouble();
          final limit = (b['limit'] as num).toDouble();
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
                        b['category'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${spent.toStringAsFixed(0)} / ₹${limit.toStringAsFixed(0)}',
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
