import 'package:daily_cash/src/data/services/api_client.dart';
import 'package:daily_cash/src/features/pages/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // Define your authentication methods and properties here

  var fullname = ''.obs; // Add this to hold the fullname
  var email = ''.obs; // Add this to hold the email
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final currentUserId = ''.obs; // Si aad ugu kaydiso user ID login kadib

  var isPasswordVisible = false.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
  }

  final fullnameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadStoredUserId(); // markuu app-ku furmo
  }

  void _loadStoredUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null && userId.isNotEmpty) {
      currentUserId.value = userId;
    }
  }

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    isLoading(true);

    try {
      final userData = await ApiClient.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userData != null && userData['id'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userData['id']);
        print('User ID saved to SharedPreferences: ${userData['id']}');
        fullname.value = userData['fullname'];
        await prefs.setString('fullname', userData['fullname']);
        email.value = userData['email'];
        await prefs.setString('email', userData['email']);

        // Set the user ID in the controller
        currentUserId.value = userData['id'];
        fullname.value = userData['fullname'];
        email.value = userData['email'];

        Get.offAll(() => HomePage());
      } else {
        Get.snackbar('Error', 'Invalid login response');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
      print("Login error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> logoutUser() async {
    await ApiClient.logout();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    currentUserId.value = '';
    fullname.value = ''; // ✅
  }
}
