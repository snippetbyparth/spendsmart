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
    final transactionsAsync = ref.watch(transactionProvider);
    final transactions = transactionsAsync.when(loading: () => <Map<String,dynamic>>[],
    error: (e,st)=> <Map<String,dynamic>>[],
    data: (data) => data,);
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
