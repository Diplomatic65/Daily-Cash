import 'package:daily_cash/src/data/services/api_client.dart';

import '../models/transaction_waiter_model.dart';

class TransactionWaiterRepositories {
  Future<bool> createTransaction(TransactionWaiterModel post) {
    return ApiClient.createWaiterTransaction(post);
  }

  Future<List<TransactionWaiterModel>> fetchAllTransactions() async {
    final postsData = await ApiClient.getTransactions(); // API call
    print("✅ JSON DATA: $postsData"); // Ku dar tan si aad u hubiso xogta

    return postsData
        .map<TransactionWaiterModel>(
          (json) => TransactionWaiterModel.fromJson(json),
        )
        .toList();
  }

  Future<bool> updateTransactionWaiter(
    String id,
    TransactionWaiterModel waiter,
  ) {
    return ApiClient.updateTransaction(id, waiter);
  }

  Future<bool> deleteTransactionWaiter(String id) {
    return ApiClient.deleteTransactionWaiter(id);
  }
}
