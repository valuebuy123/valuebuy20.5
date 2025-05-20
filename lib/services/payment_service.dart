import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class PaymentService {
  static const String baseUrl = 'YOUR_NGROK_URL'; // Replace with your ngrok URL (e.g., https://abcd-1234.ngrok-free.app)

  Future<Map<String, dynamic>> createPaymentSession({
    required String orderId,
    required double amount,
    required String customerId,
    required String customerEmail,
    required String customerPhone,
  }) async {
    try {
      print('Initiating payment session request: $orderId, $amount'); // Debug log
      final response = await http.post(
        Uri.parse('$baseUrl/create-payment-session'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'orderId': orderId,
          'amount': amount,
          'customerId': customerId,
          'customerEmail': customerEmail,
          'customerPhone': customerPhone,
        }),
      );

      print('Payment session response: ${response.statusCode} - ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment session: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in createPaymentSession: $e'); // Debug log
      Get.snackbar(
        'Error',
        'Payment session creation failed: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }
}