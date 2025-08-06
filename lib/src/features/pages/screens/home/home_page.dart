import 'package:daily_cash/src/features/auth/controllers/auth_controller.dart';
import 'package:daily_cash/src/features/pages/controllers/transaction_waiter_controller.dart';
import 'package:daily_cash/src/features/pages/screens/home/widget/hand_card.dart';
import 'package:daily_cash/src/features/pages/screens/home/widget/info_card.dart';
import 'package:daily_cash/src/features/pages/screens/home/widget/payment_card.dart';
import 'package:daily_cash/src/features/pages/screens/profile/add_waiter.dart';
import 'package:daily_cash/src/features/pages/screens/profile/waiter_profile.dart';
import 'package:daily_cash/src/features/pages/screens/reception/reception_form.dart';
import 'package:daily_cash/src/features/pages/screens/waiters/get_waiter.dart';
import 'package:daily_cash/src/features/pages/screens/waiters/waiter_form.dart';
import 'package:daily_cash/src/shared/custom_appbar.dart';
import 'package:daily_cash/src/utils/colors.dart';
import 'package:daily_cash/src/utils/sizes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authController = Get.find<AuthController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TransactionWaiterController transactionWaiterController =
      Get.find<TransactionWaiterController>();
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      if (isDarkMode) {
        Get.changeThemeMode(ThemeMode.dark);
      } else {
        Get.changeThemeMode(ThemeMode.light);
      }
    });
  }

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<int> years = List.generate(7, (index) => 2024 + index);
  final List<int> days = List.generate(30, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      transactionWaiterController.fetchAllTransactions();
    });
  }

  String selectedMonth = 'January';
  int selectedYear = 2024;
  int selectedDay = 1;

  String merchant = 'Loading...';
  String open = 'Loading...';
  String promotion = 'Loading...';
  String credit = 'Loading...';
  String get selectedDate =>
      '$selectedDay ${months[months.indexOf(selectedMonth)]} $selectedYear';

  void onNotificationTap() {
    print('Notification icon tapped');
  }

  @override
  Widget build(BuildContext context) {
    List<String> dateOptions = [
      for (var day in days)
        for (var month in months)
          for (var year in years) '$day $month $year',
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: CustomAppBar(
        title: "Home Page",
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
                Get.to(() => ReceptionForm());
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DECORATED CONTAINER WITH STACK
                Stack(
                  children: [
                    // Background decoration
                    Positioned(
                      top: -20,
                      left: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Top-Right
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Bottom-Left
                    Positioned(
                      bottom: -20,
                      left: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Bottom-Right
                    Positioned(
                      bottom: -20,
                      right: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Center-Left
                    Positioned(
                      top: 150, // Adjusted position for center left
                      left: 10, // Adjust the left side spacing
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Center
                    Positioned(
                      top: 100, // Adjusted position for center
                      left:
                          MediaQuery.of(context).size.width / 2 -
                          40, // Horizontal center
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.yellow.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Center-Right
                    Positioned(
                      top: 150, // Adjusted position for center right
                      right: 10, // Adjust the right side spacing
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Main Container Content
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Daily Revenue Report',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                                    fontSize: AppSizes.md,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    DropdownButton<String>(
                                      value: selectedDate,
                                      dropdownColor: AppColors.primaryColor,
                                      underline: SizedBox(),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                      items: dateOptions.map((date) {
                                        return DropdownMenuItem<String>(
                                          value: date,
                                          child: Text(
                                            date,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDay = int.parse(
                                            value!.split(' ')[0],
                                          );
                                          selectedMonth = value.split(' ')[1];
                                          selectedYear = int.parse(
                                            value.split(' ')[2],
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Selected Date: $selectedDate',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              InfoCard(
                                icon: Icons.hotel,
                                title: 'Diplomatic \nHotel',
                                amount: '\$980.09',
                                iconColor: Colors.orange,
                              ),
                              InfoCard(
                                icon: Icons.hotel,
                                title: 'Promotion',
                                amount: '\$980.09',
                                iconColor: Colors.orange,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InfoCard(
                                icon: Icons.restaurant,
                                title: 'Diplomatic \nRestuarent',
                                amount: '\$980.09',
                              ),
                              InfoCard(
                                icon: Icons.villa,
                                title: 'Titanic \nResort',
                                amount: '\$980.09',
                                iconColor: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  "Daily Cash Receipt Report",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: AppSizes.md,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Obx(() {
                      final totalMerchant =
                          transactionWaiterController.merchantTotal;
                      return HandCard(
                        icon: Icons.account_balance_wallet,
                        title: 'Cash On Hand',
                        amount: '\$${totalMerchant.toStringAsFixed(2)}',
                        iconColor: Colors.green,
                        backgroundColor: Colors.green.withOpacity(0.3),
                      );
                    }),

                    const SizedBox(width: 10),
                    Obx(() {
                      final totalOpen = transactionWaiterController.openTotal;
                      return HandCard(
                        icon: Icons.receipt,
                        title: 'Open Receipt',
                        amount: '\$${totalOpen.toStringAsFixed(2)}',
                        iconColor: Colors.purple,
                        backgroundColor: Colors.purple.withOpacity(0.3),
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final totalPromotion =
                          transactionWaiterController.promotionTotal;
                      return HandCard(
                        icon: Icons.campaign,
                        title: 'Promotion',
                        amount: '\$${totalPromotion.toStringAsFixed(2)}',
                        iconColor: Colors.blue,
                        backgroundColor: Colors.blue.withOpacity(0.2),
                      );
                    }),
                    const SizedBox(width: 10),
                    Obx(() {
                      final totalCredit =
                          transactionWaiterController.creditTotal;
                      return HandCard(
                        icon: Icons.campaign,
                        title: 'Credit (Deyn)',
                        amount: '\$${totalCredit.toStringAsFixed(2)}',
                        iconColor: Colors.red,
                        backgroundColor: Colors.red.withOpacity(0.2),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Obx(() {
                      final totalMerchant =
                          transactionWaiterController.merchantTotal;
                      return HandCard(
                        icon: Icons.account_balance,
                        title: 'Deposit',
                        amount: '\$${totalMerchant.toStringAsFixed(2)}',
                        iconColor: Colors.pink,
                        backgroundColor: Colors.pink.withOpacity(0.3),
                      );
                    }),

                    const SizedBox(width: 10),
                    Obx(() {
                      final totalOpen = transactionWaiterController.openTotal;
                      return HandCard(
                        icon: Icons.cancel,
                        title: 'Cancelled',
                        amount: '\$${totalOpen.toStringAsFixed(2)}',
                        iconColor: Colors.orange,
                        backgroundColor: Colors.orange.withOpacity(0.3),
                      );
                    }),
                  ],
                ),

                SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            final totalMerchant =
                                transactionWaiterController.merchantTotal;
                            return PaymentCard(
                              iconColor: Colors.green,
                              icon: Icons.phone_android,
                              title: "Merchant",
                              amount: '\$${totalMerchant.toStringAsFixed(2)}',
                            );
                          }),
                          Obx(() {
                            final totalPremier =
                                transactionWaiterController.premierTotal;
                            return PaymentCard(
                              iconColor: Colors.red,
                              icon: Icons.account_balance_wallet,
                              title: "Premier Bank",
                              amount: '\$${totalPremier.toStringAsFixed(2)}',
                            );
                          }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            final totaledahab =
                                transactionWaiterController.edahabTotal;
                            return PaymentCard(
                              iconColor: Colors.pink,
                              icon: Icons.send,
                              title: "Edahab",
                              amount: '\$${totaledahab.toStringAsFixed(2)}',
                            );
                          }),
                          Obx(() {
                            final totalEBesa =
                                transactionWaiterController.ebesaTotal;
                            return PaymentCard(
                              iconColor: Colors.brown,
                              icon: Icons.receipt,
                              title: "Ebesa",
                              amount: '\$${totalEBesa.toStringAsFixed(2)}',
                            );
                          }),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PaymentCard(
                            iconColor: Colors.orange,
                            icon: Icons.monetization_on,
                            title: "EvcPlus",
                            amount: '\$980.09',
                          ),
                          Obx(() {
                            final totalOthers =
                                transactionWaiterController.othersTotal;
                            return PaymentCard(
                              iconColor: Colors.deepPurple,
                              icon: Icons.sms,
                              title: "Cash",
                              amount: '\$${totalOthers.toStringAsFixed(2)}',
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
