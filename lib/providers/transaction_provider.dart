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
    if (userId == null) return [];
    final data = await ApiService().getTransactions(userId);
    return data.map((t) => {
      'title': t['title'],
      'amount': t['amount'],
      'type': t['type'],
      'date': t['date'],
      'dateTime': DateTime.parse(t['created_at']),
    }).toList();
  }

  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    final userId = UserSession.userId;
    if (userId == null) return;
    await ApiService().createTransaction(userId, transaction);
    state = AsyncData(await _fetchTransactions());
  }
}