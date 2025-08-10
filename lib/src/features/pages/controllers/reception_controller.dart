import 'package:daily_cash/src/features/pages/models/reception_model.dart';
import 'package:daily_cash/src/features/pages/repositories/reception_repositories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ReceptionController extends GetxController {
  final receptionNameController = TextEditingController();
  final merchantController = TextEditingController();
  final premierController = TextEditingController();
  final edahabController = TextEditingController();
  final ebesaController = TextEditingController();
  final othersController = TextEditingController();
  final creditController = TextEditingController();
  final depositController = TextEditingController();
  final refundController = TextEditingController();
  final discountController = TextEditingController();

  final isTransactionCreated = false.obs;
  final isLoading = false.obs;
  var receptionName = ''.obs; // selected reception name
  var receptions = <String>[].obs;

  final RxList<ReceptionModel> transactions = <ReceptionModel>[].obs;
  final ReceptionRepositories _receptionRepository = ReceptionRepositories();

  final isWaiterCreated = false.obs;
  String? selectedPostId; // For update operations
  @override
  void onInit() {
    receptionNameController.addListener(() {
      receptionName.value = receptionNameController.text;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllTransactions();
    });
    super.onInit();
  }

  Future<void> createReceptionTransaction() async {
    receptionNameController.addListener(() {
      receptionName.value = receptionNameController.text;
    });

    print("reception: ${receptionNameController.text}");
    print("merchant: ${merchantController.text}");
    print("premier: ${premierController.text}");
    print("edahab: ${edahabController.text}");
    print("eBesa: ${ebesaController.text}");
    print("others: ${othersController.text}");
    print("credit: ${creditController.text}");
    print("deposit: ${depositController.text}");
    print("refund: ${refundController.text}");
    print("discount: ${discountController.text}");
    if (receptionNameController.text.isEmpty ||
        merchantController.text.isEmpty ||
        premierController.text.isEmpty ||
        edahabController.text.isEmpty ||
        ebesaController.text.isEmpty ||
        othersController.text.isEmpty ||
        creditController.text.isEmpty ||
        depositController.text.isEmpty ||
        refundController.text.isEmpty ||
        discountController.text.isEmpty) {
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

      final transaction = ReceptionModel(
        receptionName: receptionNameController.text.trim().isEmpty
            ? null
            : receptionNameController.text.trim(),
        merchant: double.tryParse(merchantController.text.trim()),
        premier: double.tryParse(premierController.text.trim()),
        edahab: double.tryParse(edahabController.text.trim()),
        eBesa: double.tryParse(ebesaController.text.trim()),
        others: double.tryParse(othersController.text.trim()),
        credit: double.tryParse(creditController.text.trim()),
        deposit: double.tryParse(depositController.text.trim()),
        refund: double.tryParse(refundController.text.trim()),
        discount: double.tryParse(discountController.text.trim()),
      );

      final success = await _receptionRepository.createReception(transaction);

      if (success) {
        receptionNameController.clear();
        merchantController.clear();
        premierController.clear();
        edahabController.clear();
        ebesaController.clear();
        othersController.clear();
        creditController.clear();
        depositController.clear();
        refundController.clear();
        discountController.clear();

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

  ////// Fetch All Receptions

  Future<void> fetchAllTransactions() async {
    try {
      isLoading(true);
      final response = await _receptionRepository.fetchAllReceptions();
      transactions.assignAll(response);

      // Haddii xogtu jirto, ka soo qaado waiter name kii ugu horreeyay
      if (transactions.isNotEmpty) {
        receptionName.value = transactions.first.receptionName ?? '';
      } else {
        receptionName.value = '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch transactions: $e');
    } finally {
      isLoading(false);
    }
  }
}
