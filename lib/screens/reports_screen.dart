import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/providers/transaction_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    // Get daily spending for last 7 days
    final transactionsAsync = ref.watch(transactionProvider);
    final transactions = transactionsAsync.when(
      loading: () => <Map<String,dynamic>>[],
      error: (e,st)=> <Map<String,dynamic>>[],
      data: (data) => data,
    );
    final Map<int, double> dailySpending = {};
    for (final t in transactions) {
      if (t['type'] == 'expense' && t['dateTime'] != null) {
        final date = t['dateTime'] as DateTime;
        final now = DateTime.now();
        final diff = now.difference(date).inDays;
        print('Title: ${t['Title']}, date: $date, diff: $diff, weekday: ${date.weekday}');
        if (diff < 7) {
          dailySpending[date.weekday] =
              (dailySpending[date.weekday] ?? 0) +
              (t['amount'] as num).toDouble();
        }
      }
    }
    print('Transactions: $transactions');
    print('Daily spending: $dailySpending');

    final Map<String, double> categorySpending = {};
    for (final t in transactions) {
      if (t['type'] == 'expense') {
        final category = t['title'] as String;
        final amount = (t['amount'] as num).toDouble();
        categorySpending[category] = (categorySpending[category] ?? 0) + amount;
      }
    }
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
        title: const Text('Reports'),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending by category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: categorySpending.entries.map((entry) {
                    final colors = [
                      Colors.red,
                      Colors.blue,
                      Colors.orange,
                      Colors.purple,
                      Colors.green,
                    ];
                    final colorIndex = categorySpending.keys.toList().indexOf(
                      entry.key,
                    );
                    return PieChartSectionData(
                      value: entry.value,
                      title: entry.key,
                      color: colors[colorIndex % colors.length],
                      radius: 80,
                      titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'This Week',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(7, (index) {
                    final day = index + 1;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: dailySpending[day] ?? 0,
                          color: Colors.pink,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta){
                          const days = ['M', 'T', 'W', 'Th', 'F', 'S', 'S'];
                          return Text(days[value.toInt()],
                          style: TextStyle(color: Colors.white),);
                        }
                      )
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
