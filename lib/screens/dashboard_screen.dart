import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/providers/transaction_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionProvider);
    final transactions = transactionsAsync.when(loading: () => <Map<String,dynamic>>[],
    error: (e, st) => <Map<String,dynamic>>[],
    data: (data) => data,);
    final sortedTransactions = [...transactions]
      ..sort((a, b) {
        final aDate = a['dateTime'] as DateTime?;
        final bDate = b['dateTime'] as DateTime?;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });
    final totalIncome = transactions
        .where((t) => t['type'] == 'income')
        .fold(0.0, (sum, t) => sum + (t['amount'] as num).toDouble());

    final totalExpense = transactions
        .where((t) => t['type'] == 'expense')
        .fold(0.0, (sum, t) => sum + (t['amount'] as num).toDouble());

    final totalBalance = totalIncome - totalExpense;
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
        title: const Text('Dashboard'),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.grey.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Hi Parth',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Total Balance', style: TextStyle(fontSize: 20)),
                        Text('₹${totalBalance.toStringAsFixed(0)}', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.grey.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text('Income', style: TextStyle(fontSize: 20)),
                            Text(
                              '₹${totalIncome.toStringAsFixed(0)}',
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.grey.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text('Expenses', style: TextStyle(fontSize: 20)),
                            Text(
                              '₹${totalExpense.toStringAsFixed(0)}',
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Transactions:',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: sortedTransactions.length,
                          itemBuilder: (context, index) {
                            final t =
                                sortedTransactions[index]; // ← inside the function
                            return ListTile(
                              // ← return is inside too
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
                                  color: t['type'] == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }, // ← function closes here
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
