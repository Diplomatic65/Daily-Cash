import 'package:daily_cash/src/features/auth/controllers/auth_controller.dart';
import 'package:daily_cash/src/features/pages/controllers/transaction_waiter_controller.dart';
import 'package:daily_cash/src/features/pages/screens/home/home_page.dart';
import 'package:daily_cash/src/features/pages/screens/profile/add_waiter.dart';
import 'package:daily_cash/src/features/pages/screens/profile/waiter_profile.dart';
import 'package:daily_cash/src/features/pages/screens/waiters/get_waiter.dart';
import 'package:daily_cash/src/features/pages/screens/waiters/waiter_form.dart';
import 'package:daily_cash/src/shared/custom_appbar.dart';
import 'package:daily_cash/src/utils/colors.dart';
import 'package:daily_cash/src/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceptionForm extends StatefulWidget {
  const ReceptionForm({super.key});

  @override
  State<ReceptionForm> createState() => _ReceptionFormState();
}

class _ReceptionFormState extends State<ReceptionForm> {
  final authController = Get.find<AuthController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Use the controller's existing TextEditingControllers:
  final TransactionWaiterController transactionWaiterController = Get.put(
    TransactionWaiterController(),
  );

  // To track total amount:
  double totalAmount = 0.0;

  var waiterName = ''.obs;
  final TextEditingController waiterNameController = TextEditingController();

  void init() {
    waiterNameController.addListener(() {
      waiterName.value = waiterNameController.text;
    });
  }

  @override
  void dispose() {
    transactionWaiterController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to update total when values change
    [
      transactionWaiterController.merchantController,
      transactionWaiterController.premierController,
      transactionWaiterController.edahabController,
      transactionWaiterController.ebesaController,
      transactionWaiterController.othersController,
      transactionWaiterController.creditController,
      transactionWaiterController.promotionController,
    ].forEach((controller) {
      controller.addListener(_calculateTotal);
    });

    _calculateTotal();
  }

  // @override
  // void dispose() {
  //   // Dispose all controllers owned by transactionWaiterController
  //   transactionWaiterController.merchantController.dispose();
  //   transactionWaiterController.premierController.dispose();
  //   transactionWaiterController.edahabController.dispose();
  //   transactionWaiterController.ebesaController.dispose();
  //   transactionWaiterController.othersController.dispose();
  //   transactionWaiterController.creditController.dispose();
  //   transactionWaiterController.promotionController.dispose();
  //   super.dispose();
  // }

  void _calculateTotal() {
    double total = 0.0;
    final controllers = [
      transactionWaiterController.merchantController,
      transactionWaiterController.premierController,
      transactionWaiterController.edahabController,
      transactionWaiterController.ebesaController,
      transactionWaiterController.othersController,
      transactionWaiterController.creditController,
      transactionWaiterController.promotionController,
    ];

    for (var c in controllers) {
      total += double.tryParse(c.text) ?? 0.0;
    }

    setState(() {
      totalAmount = total;
    });
  }

  // Helper for coloring cells:
  Color _getColor(String label) {
    switch (label) {
      case "Merchant":
        return Colors.teal.shade100;
      case "Premier":
        return Colors.blue.shade100;
      case "Edahab":
        return Colors.yellow.shade100;
      case "E-besa":
        return Colors.purple.shade100;
      case "Others":
        return Colors.orange.shade100;
      case "Credit":
        return Colors.green.shade100;
      case "Promotion":
        return Colors.lightBlue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionWaiterController>();

    final Map<String, TextEditingController> controllerMap = {
      "merchant": transactionWaiterController.merchantController,
      "premier": transactionWaiterController.premierController,
      "edahab": transactionWaiterController.edahabController,
      "e-besa": transactionWaiterController.ebesaController,
      "others": transactionWaiterController.othersController,
      "credit": transactionWaiterController.creditController,
      "promotion": transactionWaiterController.promotionController,
    };

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: CustomAppBar(
        title: "Reception Form",
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,

        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.5),
              ),
              child: Obx(() {
                final String name = authController.fullname.value;
                final String email = authController.email.value;
                final String initial = name.isNotEmpty
                    ? name[0].toUpperCase()
                    : '?'; // xarafka 1aad

                return Row(
                  children: [
                    // CircleAvatar with first letter
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 20,
                      child: Text(
                        initial,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name.isNotEmpty ? 'Welcome, $name' : 'Dashboard Menu',
                          style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: AppSizes.md,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email.isNotEmpty ? email : 'No email provided',
                          style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: AppSizes.md,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
            ListTile(
              title: const Text('Home Page'),
              leading: const Icon(Icons.home),
              onTap: () {
                Get.to(() => const HomePage());
                // Navigate to Add Student Screen
              },
            ),
            Divider(color: Colors.grey, thickness: 1, indent: 1, endIndent: 1),
            ListTile(
              title: const Text('Report Waiters'),
              leading: const Icon(Icons.list),
              onTap: () {
                Get.to(() => GetWaiter());
                // Navigate to All Students Screen
              },
            ),
            ListTile(
              title: const Text('Waiters Form'),
              leading: const Icon(Icons.report),
              onTap: () {
                Get.to(() => WaiterForm());
              },
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),

            ListTile(
              title: const Text('Daily Attendance'),
              leading: const Icon(Icons.access_time),
              onTap: () {
                // Navigate to Attendance Screen
              },
            ),
            ListTile(
              title: const Text('Attendance Report'),
              leading: const Icon(Icons.picture_as_pdf),
              onTap: () {
                // Navigate to Attendance Report Screen
              },
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('Reception Form'),
              leading: const Icon(Icons.access_time),
              onTap: () {
                // Navigate to Reception Form Screen
              },
            ),
            ListTile(
              title: const Text('Reception Report'),
              leading: const Icon(Icons.picture_as_pdf),
              onTap: () {
                // Navigate to Reception Report Screen
              },
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('Waiter Profile'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                Get.to(() => WaiterProfile());
              },
            ),
            ListTile(
              title: const Text('Add New Waiter'),
              leading: const Icon(Icons.admin_panel_settings),
              onTap: () {
                Get.to(() => const AddWaiter());
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(120),
                  1: FlexColumnWidth(),
                },
                border: TableBorder.all(color: Colors.grey.shade300),
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Reception Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Cash Receipt',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Data Row with nested Table for inputs
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 110,
                        ),
                        child: Obx(() {
                          final name = controller.waiterName.value;
                          return Text(
                            name.isNotEmpty ? name : 'Waiter Name',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(80),
                            1: FlexColumnWidth(),
                          },
                          children: controllerMap.entries.map((entry) {
                            return TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getColor(entry.key),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppSizes.md,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: TextFormField(
                                    controller: entry.value,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 8,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return ElevatedButton.icon(
                      onPressed: transactionWaiterController.isLoading.value
                          ? null
                          : () async {
                              await transactionWaiterController
                                  .createWaiterTransaction();
                              Get.off(() => const GetWaiter());
                              _calculateTotal(); // optional
                            },

                      icon: const Icon(
                        Icons.save,
                        color: AppColors.primaryColor,
                      ),
                      label: transactionWaiterController.isLoading.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Save',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Text(
                      'Total Amount: \$ ${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
