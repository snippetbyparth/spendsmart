
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<Map<String, dynamic>> initialTransactions = [
    {'title': 'Salary', 'amount': 100000, 'type': 'income', 'date': 'May 1'},
    {'title': 'Groceries', 'amount': 2000, 'type': 'expense', 'date': 'May 2'},
    {'title': 'Netflix', 'amount': 500, 'type': 'expense', 'date': 'May 3'},
    {'title': 'Freelance', 'amount': 10000, 'type': 'income', 'date': 'May 4'},
    {'title': 'Rent', 'amount': 35000, 'type': 'expense', 'date': 'May 4'},
    {'title': 'EMI', 'amount': 12500, 'type': 'expense', 'date': 'May 5'},
  ];

  final transactionProvider = StateNotifierProvider<TransactionNotifier, List<Map<String, dynamic>>>(
  (ref) => TransactionNotifier(),
);

// The notifier — manages the data
class TransactionNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TransactionNotifier() : super(initialTransactions);

  void addTransaction(Map<String, dynamic> transaction) {
    state = [transaction, ...state];
  }
}