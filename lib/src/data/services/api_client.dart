import 'dart:convert';

import 'package:daily_cash/src/features/auth/screens/login_user.dart';
import 'package:daily_cash/src/features/pages/models/reception_model.dart';
import 'package:daily_cash/src/features/pages/models/transaction_waiter_model.dart';
import 'package:daily_cash/src/utils/api_constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static Future<Map<String, dynamic>?> signupUser({
    required String fullname,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstants.userEndpoint}/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Signup failed');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstants.userEndpoint}/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // Token ka soo qaad response-ka
        String token = responseBody['token'];

        // Kaydi token-ka si uu noqdo mid default ah
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);

        Get.snackbar('Success', 'Logged in successfully');
        return responseBody['user'];
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'User does not exist';
        Get.snackbar('Error', errorMessage);
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return null;
    }
  }

  static Future<http.Response> getAdUserProfile(String token) async {
    final url = Uri.parse(
      ApiConstants.profileUserEndpoint,
    ); // Use the new endpoint

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Tirtir dhammaan xogta keydka
    Get.offAll(() => LoginUser());
  }

  static Future<bool> createWaiterTransaction(
    TransactionWaiterModel post,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Get.snackbar('Error', 'User not logged in');
      return false;
    }

    final url = Uri.parse(
      '${ApiConstants.transactionEndpoint}/create-transaction',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        String error = responseBody['message'] ?? 'Failed to create Student';
        Get.snackbar('Error', error);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  static Future<List<dynamic>> getTransactions() async {
    final url = Uri.parse(
      '${ApiConstants.transactionEndpoint}/all-transactions',
    );

    try {
      final response = await http.get(url);
      print("Response status: ${response.statusCode}"); // Log status
      print("Response body: ${response.body}"); // Log the body

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        List students = jsonBody['data'];
        print("RESPONSE DATA: $jsonBody");

        return students;
      } else {
        throw Exception('Failed to load Students');
      }
    } catch (e) {
      throw Exception('Failed to load Students: $e');
    }
  }

  static Future<bool> updateTransaction(
    String id,
    TransactionWaiterModel transaction,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Get.snackbar('Error', 'User not logged in');
      return false;
    }

    final url = Uri.parse(
      '${ApiConstants.transactionEndpoint}/update-waiter/$id',
    );

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(transaction.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        String error = responseBody['message'] ?? 'Failed to update post';
        Get.snackbar('Error', error);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
      return false;
    }
  }

  static Future<bool> deleteTransactionWaiter(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Sending token: $token');

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'No token found');
      return false;
    }

    final url = Uri.parse(
      '${ApiConstants.transactionEndpoint}/delete-transaction/$id',
    ); // Correct URL with query string

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Ensure token is being sent in the header
        },
      );

      if (response.statusCode == 200) {
        print('Post deleted successfully');
        return true;
      } else {
        print('Failed to delete post: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  //// Create Reception Transaction

  static Future<bool> createReception(ReceptionModel post) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Get.snackbar('Error', 'User not logged in');
      return false;
    }

    final url = Uri.parse('${ApiConstants.receptionEndpoint}/create-reception');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        String error = responseBody['message'] ?? 'Failed to create Reception';
        Get.snackbar('Error', error);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
}
