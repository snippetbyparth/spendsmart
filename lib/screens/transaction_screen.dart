import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/providers/transaction_provider.dart';
import 'package:spendsmart/widgets/add_transaction_sheet.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  String _selectedFilter = 'All'; // 'All', 'Income', 'Expense'
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);

    final filtered =
        (_selectedFilter == 'All'
              ? transactions
              : transactions
                    .where((t) => t['type'] == _selectedFilter.toLowerCase())
                    .toList())
          ..sort((a, b) {
            final aDate = a['dateTime'] as DateTime?;
            final bDate = b['dateTime'] as DateTime?;
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return bDate.compareTo(aDate);
          });
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Filter tabs
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: ['All', 'Income', 'Expense'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.grey.shade500
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(filter),
                  ),
                );
              }).toList(),
            ),
          ),
          // Transactions list
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final t = filtered[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: t['type'] == 'income'
                        ? Colors.green
                        : Colors.red,
                    child: Icon(
                      t['type'] == 'income'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(t['title']),
                  subtitle: Text(t['date']),
                  trailing: Text(
                    '₹${t['amount']}',
                    style: TextStyle(
                      color: t['type'] == 'income' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade800,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.grey.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            builder: (context) => AddTransactionSheet(),
          );
        },
        child: Icon(Icons.add, color: Colors.grey.shade400),
      ),
    );
  }
}
