import 'package:daily_cash/src/features/auth/controllers/auth_controller.dart';
import 'package:daily_cash/src/features/pages/controllers/transaction_waiter_controller.dart';
import 'package:daily_cash/src/features/pages/screens/home/home_page.dart';
import 'package:daily_cash/src/features/pages/screens/profile/add_waiter.dart';
import 'package:daily_cash/src/features/pages/screens/profile/waiter_profile.dart';
import 'package:daily_cash/src/features/pages/screens/waiters/update_waiter.dart';
import 'package:daily_cash/src/features/pages/screens/waiters/waiter_form.dart';
import 'package:daily_cash/src/shared/custom_appbar.dart';
import 'package:daily_cash/src/utils/colors.dart';
import 'package:daily_cash/src/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetWaiter extends StatefulWidget {
  const GetWaiter({super.key});

  @override
  State<GetWaiter> createState() => _GetWaiterState();
}

class _GetWaiterState extends State<GetWaiter> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TransactionWaiterController waiterController =
      Get.find<TransactionWaiterController>();
  final AuthController authController = Get.find<AuthController>();

  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    if (isDarkMode) {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
    }
  }

  @override
  void initState() {
    super.initState();
    authController.loadUserData(); // Fetch user data when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: CustomAppBar(
        title: "Waiters Report",
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
            ListTile(
              title: const Text('Report Waiters'),
              leading: const Icon(Icons.list),
              onTap: () {
                Get.to(() => GetWaiter());
                // Navigate to All Students Screen
              },
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('Waiters Form'),
              leading: const Icon(Icons.report),
              onTap: () {
                Get.to(() => WaiterForm());
              },
            ),
            ListTile(
              title: const Text('Daily Attendance'),
              leading: const Icon(Icons.access_time),
              onTap: () {
                // Navigate to Attendance Screen
              },
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('Attendance Report'),
              leading: const Icon(Icons.picture_as_pdf),
              onTap: () {
                // Navigate to Attendance Report Screen
              },
            ),
            ListTile(
              title: const Text('Waiter Profile'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                Get.to(() => WaiterProfile());
              },
            ),
            Divider(color: Colors.grey, thickness: 1, indent: 1, endIndent: 1),
            ListTile(
              title: const Text('Add New Waiter'),
              leading: const Icon(Icons.admin_panel_settings),
              onTap: () {
                Get.to(() => const AddWaiter());
              },
            ),
            ListTile(
              title: const Text('Manage Class Time'),
              leading: const Icon(Icons.schedule),
              onTap: () {
                // Navigate to Manage Class Time Screen
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            // Search Box (optional)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('Search by name or phone...')),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Student List
            Expanded(
              child: Obx(() {
                if (waiterController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (waiterController.posts.isEmpty) {
                  return const Center(child: Text('No waiters found.'));
                }

                return ListView.builder(
                  itemCount: waiterController.posts.length,
                  itemBuilder: (context, index) {
                    final waiter = waiterController.posts[index];
                    return Card(
                      elevation: 2,
                      // margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              waiter.waiter ?? 'Unknown Waiter',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'update') {
                                  waiterController.setSelectedPostId(
                                    waiter.id!,
                                  );
                                  Get.to(
                                    () => UpdateWaiter(transaction: waiter),
                                  );
                                } else if (value == 'delete') {
                                  _showDeleteConfirmationDialog(context);
                                  waiterController.selectedPostId = waiter.id;
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem(
                                  value: 'update',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ), // Icon for Update
                                      SizedBox(
                                        width: 8,
                                      ), // Space between icon and text
                                      Text('Update'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',

                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ), // Icon for Update
                                      SizedBox(
                                        width: 8,
                                      ), // Space between icon and text
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Registered: ${waiter.createdDate}"),

                            Divider(thickness: 2, indent: 1, endIndent: 1),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Marchent:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.md,
                                        ),
                                      ),
                                      SizedBox(width: 3),

                                      Text(
                                        "${waiter.merchant}",
                                        style: TextStyle(
                                          fontSize: AppSizes.md,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Premier:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.md,
                                        ),
                                      ),
                                      SizedBox(width: 3),

                                      Text(
                                        "${waiter.premier}",
                                        style: TextStyle(
                                          fontSize: AppSizes.md,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "E dahab:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.md,
                                        ),
                                      ),
                                      SizedBox(width: 3),

                                      Text(
                                        "${waiter.edahab}",
                                        style: TextStyle(
                                          fontSize: AppSizes.md,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "E bessa:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.md,
                                        ),
                                      ),
                                      SizedBox(width: 3),

                                      Text(
                                        "${waiter.eBesa}",
                                        style: TextStyle(
                                          fontSize: AppSizes.md,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Other:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.md,
                                        ),
                                      ),
                                      SizedBox(width: 3),

                                      Text(
                                        "${waiter.others}",
                                        style: TextStyle(
                                          fontSize: AppSizes.md,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Credit:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.md,
                                        ),
                                      ),
                                      SizedBox(width: 3),

                                      Text(
                                        "${waiter.credit}",
                                        style: TextStyle(
                                          fontSize: AppSizes.md,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Promotion:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.md,
                                        ),
                                      ),
                                      SizedBox(width: 3),

                                      Text(
                                        "${waiter.promotion}",
                                        style: TextStyle(
                                          fontSize: AppSizes.md,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Open:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.md,
                                        ),
                                      ),
                                      SizedBox(width: 3),

                                      Text(
                                        "${waiter.open}",
                                        style: TextStyle(
                                          fontSize: AppSizes.md,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // SizedBox(height: 20),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text("Required"),
                            //         Text(
                            //           "\$${student.required.toStringAsFixed(2)}",
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //       ],
                            //     ),

                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text("Paid"),
                            //         Text(
                            //           "\$${student.paid.toStringAsFixed(2)}",
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text("Remaining"),
                            //         Text(
                            //           "\$${student.remaining.toStringAsFixed(2)}",
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.red,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 10),
                            // Divider(thickness: 2, indent: 1, endIndent: 1),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Row(children: [Text("Activity")]),
                            //         Text(
                            //           "\$${student.required}",
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //       ],
                            //     ),

                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Container(
                            //           padding: const EdgeInsets.symmetric(
                            //             horizontal: 12,
                            //             vertical: 6,
                            //           ),
                            //           decoration: BoxDecoration(
                            //             color: student.status == 'Approved'
                            //                 ? Colors.green.withOpacity(0.4)
                            //                 : Colors.orange.withOpacity(0.4),
                            //             borderRadius: BorderRadius.circular(10),
                            //           ),
                            //           child: Text(
                            //             student.status,
                            //             style: TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this student?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel button
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                await waiterController
                    .deleteTransactionWaiter(); // ✅ call delete
                waiterController
                    .fetchAllTransactions(); // optional: refresh list
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
