import 'package:dukascango/domain/models/payment_gateway_model.dart';
import 'package:dukascango/domain/services/payment_gateway_interface.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TinggGateway implements PaymentGatewayInterface {
  @override
  final PaymentGateway gateway;

  TinggGateway(this.gateway);

  @override
  Future<void> processPayment({
    required double amount,
    required String currency,
    required String customerName,
    required String customerEmail,
    required String txRef,
  }) async {
    // Placeholder for Tingg payment processing logic
    print('Processing Tingg payment...');
    // In a real implementation, you would make an API call to Tingg
    final url = Uri.parse('${gateway.apiConfig['baseUrl']}/v2/checkout/request');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${gateway.apiConfig['accessToken']}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'merchantTransactionID': txRef,
        'customerFirstName': customerName.split(' ').first,
        'customerLastName': customerName.split(' ').last,
        'customerEmail': customerEmail,
        'requestAmount': amount,
        'currencyCode': currency,
        'accountNumber': '12345', // Example account number
        'serviceCode': gateway.apiConfig['serviceCode'],
        'dueDate': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
        'requestDescription': 'DukaScanGo Payment',
        'countryCode': gateway.allowedCountries.first, // Assuming one country for now
      }),
    );

    if (response.statusCode == 200) {
      print('Tingg payment initiated successfully.');
    } else {
      print('Tingg payment initiation failed: ${response.body}');
      throw Exception('Failed to initiate Tingg payment');
    }
  }

  @override
  Future<void> processWithdrawal({
    required double amount,
    required String currency,
    required String subaccountId, // Not used by Tingg
    required String merchantWallet,
  }) async {
    // Placeholder for Tingg withdrawal logic
    print('Processing Tingg withdrawal...');
    // In a real implementation, you would make an API call to Tingg's payout endpoint
    final url = Uri.parse('${gateway.apiConfig['baseUrl']}/v3/payouts');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${gateway.apiConfig['accessToken']}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'destination': {
          'type': 'wallet',
          'wallet': {
            'walletName': 'tingg',
            'accountNumber': merchantWallet,
          },
        },
        'transfer': {
          'amount': amount,
          'currency': currency,
          'description': 'DukaScanGo Withdrawal',
        },
      }),
    );

     if (response.statusCode == 200) {
      print('Tingg withdrawal initiated successfully.');
    } else {
      print('Tingg withdrawal initiation failed: ${response.body}');
      throw Exception('Failed to initiate Tingg withdrawal');
    }
  }
}
