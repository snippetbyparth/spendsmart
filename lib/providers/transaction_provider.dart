import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/services/api_services.dart';
import 'package:spendsmart/services/user_session.dart';

final transactionProvider = AsyncNotifierProvider<TransactionNotifier, List<Map<String, dynamic>>>(
  () => TransactionNotifier(),
);

class TransactionNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    return await _fetchTransactions();
  }

  Future<List<Map<String, dynamic>>> _fetchTransactions() async {
    final userId = UserSession.userId;
    print('Fetching transactions for userID: $userId');
    if (userId == null) return [];
    final data = await ApiService().getTransactions(userId);
    print('Data from API: $data');
    return data.map((t) {
  print('selected_date: ${t['selected_date']}');
  return {
    'title': t['title'],
    'amount': t['amount'],
    'type': t['type'],
    'date': t['date'],
    'dateTime': t['selected_date'] != null
      ? DateTime.parse(t['selected_date'])
      : t['created_at'] != null
        ? DateTime.parse(t['created_at'])
        : DateTime.now(),
  };
}).toList();
  }

  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    final userId = UserSession.userId;
    if (userId == null) return;
    await ApiService().createTransaction(userId, transaction);
    state = AsyncData(await _fetchTransactions());
  }
}