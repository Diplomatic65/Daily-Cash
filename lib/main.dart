import 'package:daily_cash/src/features/auth/controllers/auth_controller.dart';
import 'package:daily_cash/src/features/auth/screens/login_user.dart';
import 'package:daily_cash/src/features/pages/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Get.put(UserController());
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController());
  // Get.put(PostController());

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  print("🎯 Token at startup: $token");

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.light, //
      debugShowCheckedModeBanner: false,
      home: token != null ? HomePage() : LoginUser(),
      // home: LoginUser(),
    );
  }
}
