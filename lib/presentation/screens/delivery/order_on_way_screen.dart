import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dukascango/domain/models/response/orders_by_status_response.dart';
import 'package:dukascango/domain/services/services.dart';
import 'package:dukascango/presentation/components/card_orders_delivery.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/screens/delivery/delivery_home_screen.dart';
import 'package:dukascango/presentation/screens/delivery/order_details_delivery_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';


class OrderOnWayScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TextCustom(text: 'Orders On Way'),
        centerTitle: true,
        elevation: 0,
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.push(context, routeDukascango(page: DeliveryHomeScreen())),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.arrow_back_ios_new_rounded, size: 17, color: ColorsDukascango.primaryColor),
              TextCustom(text: 'Back', fontSize: 17, color: ColorsDukascango.primaryColor )
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<OrdersResponse>>(
        future: deliveryServices.getOrdersForDelivery('ON WAY'),
        builder: (context, snapshot) 
          => ( !snapshot.hasData )
            ? Column(
                children: const [
                  ShimmerDukascango(),
                  SizedBox(height: 10.0),
                  ShimmerDukascango(),
                  SizedBox(height: 10.0),
                  ShimmerDukascango(),
                ],
              )
            : _ListOrdersForDelivery(listOrdersDelivery: snapshot.data!)
      ),
    );
  }
}

class _ListOrdersForDelivery extends StatelessWidget {
  
  final List<OrdersResponse> listOrdersDelivery;

  const _ListOrdersForDelivery({ required this.listOrdersDelivery});

  @override
  Widget build(BuildContext context) {
    return ( listOrdersDelivery.length != 0 ) 
      ? ListView.builder(
          itemCount: listOrdersDelivery.length,
          itemBuilder: (_, i) 
            => CardOrdersDelivery(
                orderResponse: listOrdersDelivery[i],
                onPressed: () => Navigator.push(context, routeDukascango(page: OrdersDetailsDeliveryScreen(order: listOrdersDelivery[i]))),
               )
        )
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: SvgPicture.asset('Assets/no-data.svg', height: 300)),
          const SizedBox(height: 15.0),
          const TextCustom(text: 'Without Orders on way', color: ColorsDukascango.primaryColor, fontWeight: FontWeight.w500, fontSize: 21)
        ],
      );
  }
}