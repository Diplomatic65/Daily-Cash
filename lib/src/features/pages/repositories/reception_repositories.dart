import 'package:daily_cash/src/data/services/api_client.dart';
import 'package:daily_cash/src/features/pages/models/reception_model.dart';

class ReceptionRepositories {
  Future<bool> createReception(ReceptionModel post) {
    return ApiClient.createReception(post);
  }

  Future<List<ReceptionModel>> fetchAllReceptions() async {
    final postsData = await ApiClient.getTransactions(); // API call
    print("✅ JSON DATA: $postsData"); // Ku dar tan si aad u hubiso xogta

    return postsData
        .map<ReceptionModel>((json) => ReceptionModel.fromJson(json))
        .toList();
  }
}
