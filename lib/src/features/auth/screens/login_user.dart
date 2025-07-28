import 'package:daily_cash/src/features/auth/controllers/auth_controller.dart';
import 'package:daily_cash/src/features/pages/screens/home/home_page.dart';
import 'package:daily_cash/src/shared/custom_buttons.dart';
import 'package:daily_cash/src/utils/colors.dart';
import 'package:daily_cash/src/utils/images.dart';
import 'package:daily_cash/src/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatelessWidget {
  const LoginUser({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppImages.logo, width: 170),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome To Student App',
                      style: TextStyle(
                        fontSize: AppSizes.xxl,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please Login To See App Menu',
                      style: TextStyle(
                        fontSize: AppSizes.lg,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: AppSizes.sm,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: authController.emailController,
                      decoration: InputDecoration(
                        hintText: 'Your Email',
                        hintStyle: TextStyle(
                          fontSize: AppSizes.md,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        prefixIcon: (Icon(
                          Icons.email,
                          color: AppColors.primaryColor,
                        )),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: AppSizes.sm,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GetBuilder<AuthController>(
                      builder: (controller) {
                        return TextFormField(
                          controller: authController.passwordController,
                          obscureText: !authController
                              .isPasswordVisible
                              .value, // Toggle password visibility
                          decoration: InputDecoration(
                            hintText: 'Your Password',
                            hintStyle: TextStyle(
                              fontSize: AppSizes.md,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            prefixIcon: (Icon(
                              Icons.lock,
                              color: AppColors.primaryColor,
                            )),
                            suffixIcon: IconButton(
                              icon: Icon(
                                authController.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                controller
                                    .togglePasswordVisibility(); // Toggle visibility using controller
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 46,
                      width: double.infinity,
                      child: CustomButtons(
                        text: "Login",
                        onTap: () async {
                          await authController
                              .loginUser(); // Corrected method name
                          // Check if token is saved and navigate accordingly
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? token = prefs.getString('token');
                          if (token != null) {
                            Get.offAll(() => HomePage());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
