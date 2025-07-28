import 'dart:convert';
import 'package:daily_cash/src/data/services/api_client.dart';
import 'package:daily_cash/src/features/auth/controllers/auth_controller.dart';
import 'package:daily_cash/src/features/pages/screens/home/home_page.dart';
import 'package:daily_cash/src/features/pages/screens/profile/add_waiter.dart';
import 'package:daily_cash/src/features/pages/screens/profile/widget/profile_widget.dart';
import 'package:daily_cash/src/features/pages/screens/waiters/get_waiter.dart';
import 'package:daily_cash/src/features/pages/screens/waiters/waiter_form.dart';
import 'package:daily_cash/src/shared/custom_appbar.dart';
import 'package:daily_cash/src/utils/colors.dart';
import 'package:daily_cash/src/utils/images.dart';
import 'package:daily_cash/src/utils/sizes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaiterProfile extends StatefulWidget {
  @override
  _WaiterProfileState createState() => _WaiterProfileState();
}

class _WaiterProfileState extends State<WaiterProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final StudentController studentController = Get.put(StudentController());
  final AuthController authController = Get.find<AuthController>();
  bool isDarkMode = false;

  // Method to toggle dark/light mode
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    // Update the theme (if using GetX or another state manager, use that to change the theme)
    if (isDarkMode) {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
    }
  }

  String fullname = 'Loading...';
  String email = 'Loading...';
  String phone = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Method to load user data from SharedPreferences and API
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userEmail = prefs.getString('email');

    if (token != null && userEmail != null) {
      try {
        final response = await ApiClient.getAdUserProfile(token);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final users = responseData['data'] as List;

          final currentUser = users.firstWhere(
            (user) => user['email'] == userEmail,
            orElse: () => null,
          );

          if (currentUser != null) {
            setState(() {
              fullname = currentUser['fullname'] ?? 'Unknown';
              email = currentUser['email'] ?? 'Unknown';
              phone = currentUser['phone'] ?? 'Unknown';
            });
          } else {
            _showError('User not found');
          }
        } else {
          _showError('Failed to load user data');
        }
      } catch (e) {
        _showError('Error: $e');
      }
    } else {
      _showError('Login data missing. Please login again.');
    }
  }

  // Helper method to show error messages
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,

      appBar: CustomAppBar(
        title: "Waiter Profile",
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
              title: const Text('Admin Profile'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                // Get.to(() => AdminProfile());
              },
            ),
            Divider(color: Colors.grey, thickness: 1, indent: 1, endIndent: 1),
            ListTile(
              title: const Text('Add New Waiter'),
              leading: const Icon(Icons.admin_panel_settings),
              onTap: () {
                Get.to(
                  () => const AddWaiter(),
                ); // Replace with actual Add Waiter Screen
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
      body: ListView(
        children: [
          Divider(color: Colors.grey, thickness: 1, indent: 1, endIndent: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                // Profile image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    border: Border.all(color: Colors.grey, width: 2),
                    image: DecorationImage(
                      image: AssetImage(AppImages.profile),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // User info
                Text(fullname, style: TextStyle(fontSize: AppSizes.xl)),
                Text(email, style: TextStyle(fontSize: AppSizes.lg)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isDarkMode ? "Dark Mode" : "Light Mode",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              isDarkMode = value;
                            });
                            if (isDarkMode) {
                              Get.changeTheme(ThemeData.dark());
                            } else {
                              Get.changeTheme(ThemeData.light());
                            }
                          },
                          activeColor: AppColors.primaryColor,
                          inactiveThumbColor: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Profile details
                ProfileWidget(
                  text: "Username",
                  subText: fullname,
                  iconData: Icons.person,
                ),
                SizedBox(height: 24),
                ProfileWidget(
                  text: "Phone",
                  subText: phone,
                  iconData: Icons.phone,
                ),
                SizedBox(height: 24),
                ProfileWidget(
                  text: "Status",
                  subText: "Active",
                  iconData: Icons.star_outline_sharp,
                ),

                // Logout button
                Container(
                  width: 130,
                  height: 50,
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          // await authController.logoutAdmin();
                          Get.offAllNamed('/login'); // Redirect to login page
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.logout,
                              size: AppSizes.iconMd,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: AppSizes.md,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
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
