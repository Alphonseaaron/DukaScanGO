import 'package:flutter/material.dart';
import 'package:dukascango/domain/models/response/orders_client_response.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class DeliveryApprovalScreen extends StatelessWidget {
  final OrdersClient orderClient;

  const DeliveryApprovalScreen({Key? key, required this.orderClient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Approve Delivery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextCustom(text: 'Your order is ready for delivery!', fontSize: 18, fontWeight: FontWeight.w500),
            const SizedBox(height: 20),
            TextCustom(text: 'Order ID: ${orderClient.id}'),
            const SizedBox(height: 10),
            TextCustom(text: 'Total: \$${orderClient.amount}'),
            const Divider(),
            const TextCustom(text: 'Delivery Fee: \$5.00', fontSize: 16, fontWeight: FontWeight.w500),
            const SizedBox(height: 10),
            const TextCustom(text: 'The delivery fee will be added to your total.'),
            const Spacer(),
            BtnDukascango(
              text: 'Approve & Pay',
              onPressed: () {
                // TODO: Implement payment and address selection
              },
            ),
            const SizedBox(height: 10),
            BtnDukascango(
              text: 'Reject',
              color: Colors.red,
              onPressed: () {
                // TODO: Implement rejection logic
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
