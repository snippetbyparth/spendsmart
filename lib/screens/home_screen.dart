import 'package:flutter/material.dart';
import 'package:spendsmart/screens/budget_screen.dart';
import 'package:spendsmart/screens/dashboard_screen.dart';
import 'package:spendsmart/screens/reports_screen.dart';
import 'package:spendsmart/screens/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    DashboardScreen(),
    TransactionScreen(),
    BudgetScreen(),
    ReportsScreen(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.black87,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.shade400,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list),label: 'Transactions'),
        BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Budget'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart),label: 'Reports'),
        ],
      ),
    );
  }
}
