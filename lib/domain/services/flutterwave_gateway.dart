import 'package:dukascango/domain/models/payment_gateway_model.dart';
import 'package:dukascango/domain/services/payment_gateway_interface.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlutterwaveGateway implements PaymentGatewayInterface {
  @override
  final PaymentGateway gateway;

  FlutterwaveGateway(this.gateway);

  @override
  Future<void> processPayment({
    required double amount,
    required String currency,
    required String customerName,
    required String customerEmail,
    required String txRef,
  }) async {
    // Placeholder for Flutterwave payment processing logic
    print('Processing Flutterwave payment...');
    // In a real implementation, you would make an API call to Flutterwave
    final url = Uri.parse('${gateway.apiConfig['baseUrl']}/payments');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${gateway.apiConfig['secretKey']}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'tx_ref': txRef,
        'amount': amount,
        'currency': currency,
        'redirect_url': 'https://your-redirect-url.com',
        'customer': {
          'email': customerEmail,
          'name': customerName,
        },
        'customizations': {
          'title': 'DukaScanGo Payment',
          'logo': 'https://your-logo-url.com/logo.png',
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Flutterwave payment initiated successfully.');
      // Handle the response, which might include a redirect URL for the user
    } else {
      print('Flutterwave payment initiation failed: ${response.body}');
      throw Exception('Failed to initiate Flutterwave payment');
    }
  }

  @override
  Future<void> processWithdrawal({
    required double amount,
    required String currency,
    required String subaccountId,
    required String merchantWallet, // Not used by Flutterwave
  }) async {
    // Placeholder for Flutterwave withdrawal logic
    print('Processing Flutterwave withdrawal...');
    // In a real implementation, you would make an API call to Flutterwave's transfer endpoint
    final url = Uri.parse('${gateway.apiConfig['baseUrl']}/transfers');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${gateway.apiConfig['secretKey']}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'account_bank': 'FLW', // Example, this would be dynamic
        'account_number': subaccountId,
        'amount': amount,
        'narration': 'DukaScanGo Withdrawal',
        'currency': currency,
        'reference': 'ref-${DateTime.now().millisecondsSinceEpoch}',
        'callback_url': 'https://your-callback-url.com',
        'debit_currency': currency,
      }),
    );

    if (response.statusCode == 200) {
      print('Flutterwave withdrawal initiated successfully.');
    } else {
      print('Flutterwave withdrawal initiation failed: ${response.body}');
      throw Exception('Failed to initiate Flutterwave withdrawal');
    }
  }
}
