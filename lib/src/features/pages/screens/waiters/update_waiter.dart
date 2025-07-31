// Full Flutter widget for updating a waiter record
// File: update_waiter.dart

import 'package:daily_cash/src/features/pages/models/transaction_waiter_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_cash/src/features/auth/controllers/auth_controller.dart';
import 'package:daily_cash/src/features/pages/controllers/transaction_waiter_controller.dart';
import 'package:daily_cash/src/utils/colors.dart';
import 'package:daily_cash/src/utils/sizes.dart';

class UpdateWaiter extends StatefulWidget {
  final TransactionWaiterModel transaction;
  const UpdateWaiter({super.key, required this.transaction});

  @override
  State<UpdateWaiter> createState() => _UpdateWaiterState();
}

class _UpdateWaiterState extends State<UpdateWaiter> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TransactionWaiterController transactionController = Get.put(
    TransactionWaiterController(),
  );
  final AuthController authController = Get.find<AuthController>();

  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    Get.changeTheme(isDarkMode ? ThemeData.dark() : ThemeData.light());
  }

  @override
  void initState() {
    super.initState();
    transactionController.waiterNameController.text = widget.transaction.waiter!;
    transactionController.merchantController.text = widget.transaction.merchant
        .toString();
    transactionController.premierController.text = widget.transaction.premier
        .toString();
    transactionController.edahabController.text = widget.transaction.edahab
        .toString();
    transactionController.ebesaController.text = widget.transaction.eBesa
        .toString();
    transactionController.othersController.text = widget.transaction.others
        .toString();
    transactionController.creditController.text = widget.transaction.credit
        .toString();
    transactionController.promotionController.text = widget
        .transaction
        .promotion
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Update Waiter'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          _buildLabel("Waiter Name"),
          _buildTextField(
            transactionController.waiterNameController,
            'Enter Waiter Name',
          ),

          const SizedBox(height: 24),
          _buildLabel("Merchant"),
          _buildTextField(
            transactionController.merchantController,
            'Enter Merchant',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          _buildLabel("Premier"),
          _buildTextField(
            transactionController.premierController,
            'Enter Premier',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          _buildLabel("Edahab"),
          _buildTextField(
            transactionController.edahabController,
            'Enter Edahab',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          _buildLabel("E-Besa"),
          _buildTextField(
            transactionController.ebesaController,
            'Enter E-Besa',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          _buildLabel("Others"),
          _buildTextField(
            transactionController.othersController,
            'Enter Others',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          _buildLabel("Credit"),
          _buildTextField(
            transactionController.creditController,
            'Enter Credit',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          _buildLabel("Promotion"),
          _buildTextField(
            transactionController.promotionController,
            'Enter Promotion',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => transactionController.updateWaiterTransaction(
                widget.transaction.id!,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Update Transaction",
                style: TextStyle(color: AppColors.blackColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: AppSizes.md, color: Colors.grey),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
