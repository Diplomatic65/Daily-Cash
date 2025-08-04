import 'package:daily_cash/src/features/pages/models/transaction_waiter_model.dart';
import 'package:daily_cash/src/features/pages/repositories/transaction_waiter_repositories.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TransactionWaiterController extends GetxController {
  final waiterNameController = TextEditingController();
  final merchantController = TextEditingController();
  final premierController = TextEditingController();
  final edahabController = TextEditingController();
  final ebesaController = TextEditingController();
  final othersController = TextEditingController();
  final creditController = TextEditingController();
  final promotionController = TextEditingController();
  final openController = TextEditingController();

  final isTransactionCreated = false.obs;
  final isLoading = false.obs;
  var waiterName = ''.obs; // selected waiter name
  var waiters = <String>[].obs;

  final RxList<TransactionWaiterModel> transactions =
      <TransactionWaiterModel>[].obs;
  final TransactionWaiterRepositories _transactionWaiterRepository =
      TransactionWaiterRepositories();

  final isWaiterCreated = false.obs;
  String? selectedPostId; // For update operations
  @override
  void onInit() {
    waiterNameController.addListener(() {
      waiterName.value = waiterNameController.text;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllTransactions();
    });
    super.onInit();
  }

  double get merchantTotal {
    return transactions.fold(0.0, (sum, item) => sum + (item.merchant ?? 0.0));
  }

  void setSelectedPostId(String id) {
    selectedPostId = id;
  }

  Future<void> createWaiterTransaction() async {
    waiterNameController.addListener(() {
      waiterName.value = waiterNameController.text;
    });

    print("waiter: ${waiterNameController.text}");
    print("merchant: ${merchantController.text}");
    print("premier: ${premierController.text}");
    print("edahab: ${edahabController.text}");
    print("eBesa: ${ebesaController.text}");
    print("others: ${othersController.text}");
    print("credit: ${creditController.text}");
    print("promotion: ${promotionController.text}");

    if (waiterNameController.text.isEmpty ||
        merchantController.text.isEmpty ||
        premierController.text.isEmpty ||
        edahabController.text.isEmpty ||
        ebesaController.text.isEmpty ||
        othersController.text.isEmpty ||
        creditController.text.isEmpty ||
        promotionController.text.isEmpty) {
      Get.snackbar(
        'Foomka Khaldan',
        'Fadlan buuxi dhammaan meelaha lacagaha',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      final transaction = TransactionWaiterModel(
        waiter: waiterNameController.text.trim().isEmpty
            ? null
            : waiterNameController.text.trim(),
        merchant: double.tryParse(merchantController.text.trim()),
        premier: double.tryParse(premierController.text.trim()),
        edahab: double.tryParse(edahabController.text.trim()),
        eBesa: double.tryParse(ebesaController.text.trim()),
        others: double.tryParse(othersController.text.trim()),
        credit: double.tryParse(creditController.text.trim()),
        promotion: double.tryParse(promotionController.text.trim()),
        open: double.tryParse(openController.text.trim()),
      );

      final success = await _transactionWaiterRepository.createTransaction(
        transaction,
      );

      if (success) {
        waiterNameController.clear();
        merchantController.clear();
        premierController.clear();
        edahabController.clear();
        ebesaController.clear();
        othersController.clear();
        creditController.clear();
        promotionController.clear();

        Get.snackbar(
          'Success',
          'Transaction created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isTransactionCreated(true);
      } else {
        Get.snackbar(
          'Error',
          'Failed to create transaction',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllTransactions() async {
    try {
      isLoading(true);
      final response = await _transactionWaiterRepository
          .fetchAllTransactions();
      transactions.assignAll(response);

      // Haddii xogtu jirto, ka soo qaado waiter name kii ugu horreeyay
      if (transactions.isNotEmpty) {
        waiterName.value = transactions.first.waiter ?? '';
      } else {
        waiterName.value = '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch transactions: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateWaiterTransaction(String s) async {
    if (selectedPostId == null) {
      Get.snackbar('Error', 'No post selected');
      return;
    }

    // Validate if any fields are empty
    if (waiterNameController.text.isEmpty) {
      Get.snackbar('Error', 'Waiter Name is required');
      return;
    }

    if (merchantController.text.isEmpty) {
      Get.snackbar('Error', 'Merchant field is required');
      return;
    }

    if (premierController.text.isEmpty) {
      Get.snackbar('Error', 'Premier field is required');
      return;
    }

    if (edahabController.text.isEmpty) {
      Get.snackbar('Error', 'Edahab field is required');
      return;
    }

    if (ebesaController.text.isEmpty) {
      Get.snackbar('Error', 'EBesa field is required');
      return;
    }
    if (othersController.text.isEmpty) {
      Get.snackbar('Error', 'Others field is required');
      return;
    }

    if (creditController.text.isEmpty) {
      Get.snackbar('Error', 'Credit field is required');
      return;
    }

    if (promotionController.text.isEmpty) {
      Get.snackbar('Error', 'Promotion field is required');
      return;
    }

    try {
      isLoading(true);
      double merchantAmount = double.parse(merchantController.text.trim());
      double premierAmount = double.parse(premierController.text.trim());
      double edahabAmount = double.parse(edahabController.text.trim());
      double ebesaAmount = double.parse(ebesaController.text.trim());
      double othersAmount = double.parse(othersController.text.trim());
      double creditAmount = double.parse(creditController.text.trim());
      double promotionAmount = double.parse(promotionController.text.trim());

      final post = TransactionWaiterModel(
        merchant: merchantAmount,
        premier: premierAmount,
        edahab: edahabAmount,
        eBesa: ebesaAmount,
        others: othersAmount,
        credit: creditAmount,
        promotion: promotionAmount,
      );

      bool success = await _transactionWaiterRepository.updateTransactionWaiter(
        selectedPostId!,
        post,
      );

      if (success) {
        waiterNameController.clear();
        merchantController.clear();
        premierController.clear();
        edahabController.clear();
        ebesaController.clear();
        othersController.clear();
        creditController.clear();
        promotionController.clear();

        Get.snackbar(
          'Updated',
          'Student updated',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isTransactionCreated(true);
        await fetchAllTransactions();
      } else {
        Get.snackbar(
          'Error',
          'Update failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteTransactionWaiter() async {
    if (selectedPostId == null) {
      Get.snackbar('Error', 'No post selected');
      return;
    }

    try {
      isLoading(true);
      bool success = await _transactionWaiterRepository.deleteTransactionWaiter(
        selectedPostId!,
      );

      if (success) {
        Get.snackbar(
          'Deleted',
          'Transaction deleted',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        selectedPostId = null;
        await fetchAllTransactions();
      } else {
        Get.snackbar(
          'Error',
          'Delete failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
