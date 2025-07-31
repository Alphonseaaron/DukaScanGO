import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/data/env/environment.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/domain/models/order.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/date_custom.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/screens/admin/orders_admin/orders_admin_screen.dart';
import 'package:dukascango/presentation/screens/admin/orders_admin/admin_scan_receipt_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';


class OrderDetailsScreen extends StatefulWidget {
  final Order order;

  const OrderDetailsScreen({required this.order});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final ordersBloc = BlocProvider.of<OrdersBloc>(context);
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is LoadingOrderState) {
          modalLoading(context);
        } else if (state is SuccessOrdersState) {
          Navigator.pop(context);
          modalSuccess(
              context,
              'SUCCESS',
              () => Navigator.pushReplacement(
                  context, routeDukascango(page: OrdersAdminScreen())));
        } else if (state is FailureOrdersState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextCustom(text: state.error, color: Colors.white),
              backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: TextCustom(text: 'Order N° ${widget.order.id}'),
          centerTitle: true,
          leadingWidth: 80,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_back_ios_new_rounded,
                    size: 17, color: ColorsDukascango.primaryColor),
                TextCustom(
                    text: 'Back', color: ColorsDukascango.primaryColor, fontSize: 17)
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: _ListProductsDetails(
                    listProductDetails: widget.order.details)),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextCustom(
                          text: 'Total',
                          color: ColorsDukascango.secundaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                      TextCustom(
                          text: '\$ ${widget.order.total}0',
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextCustom(
                          text: 'Cliente:',
                          color: ColorsDukascango.secundaryColor,
                          fontSize: 16),
                      TextCustom(text: '${widget.order.clientId}'),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextCustom(
                          text: 'Date:',
                          color: ColorsDukascango.secundaryColor,
                          fontSize: 16),
                      TextCustom(
                          text: DateCustom.getDateOrder(
                              widget.order.date.toString()),
                          fontSize: 16),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextCustom(
                        text: 'Delivery Method:',
                        color: ColorsDukascango.secundaryColor,
                        fontSize: 16
                      ),
                      TextCustom(
                        text: widget.order.deliveryMethod == DeliveryMethod.ClickAndCollect ? 'Click & Collect' : 'Delivery',
                        fontSize: 16
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const TextCustom(
                      text: 'Address shipping:',
                      color: ColorsDukascango.secundaryColor,
                      fontSize: 16),
                  const SizedBox(height: 5.0),
                  TextCustom(
                      text: widget.order.address, maxLine: 2, fontSize: 16),
                  const SizedBox(height: 5.0),
                  (widget.order.status == 'DISPATCHED')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TextCustom(
                                text: 'Delivery',
                                fontSize: 17,
                                color: ColorsDukascango.secundaryColor),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              ''))), // TODO: Add delivery image
                                ),
                                const SizedBox(width: 10.0),
                                TextCustom(
                                    text: widget.order.deliveryId!,
                                    fontSize: 17)
                              ],
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            )),
            if (widget.order.deliveryMethod == DeliveryMethod.ClickAndCollect && widget.order.status == 'PENDING_PICKUP')
              Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    BtnDukascango(
                      text: 'Scan Receipt',
                      fontWeight: FontWeight.w500,
                      onPressed: () async {
                        final receiptId = await Navigator.push<String>(context, routeDukascango(page: AdminScanReceiptScreen()));
                        if (receiptId != null && receiptId == widget.order.id) {
                          ordersBloc.add(OnUpdateStatusOrderEvent(widget.order.id!, 'PICKED_UP'));
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    BtnDukascango(
                      text: 'Send Reminder',
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        // TODO: Implement send reminder
                      },
                    ),
                    const SizedBox(height: 10),
                    BtnDukascango(
                      text: 'Initiate Delivery',
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        ordersBloc.add(OnUpdateStatusOrderEvent(widget.order.id!, 'DISPATCHED'));
                      },
                    ),
                  ],
                ),
              )
            else if (widget.order.status == 'PAID OUT')
                Container(
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BtnDukascango(
                          text: 'SELECT DELIVERY',
                          fontWeight: FontWeight.w500,
                          onPressed: () =>
                              modalSelectDelivery(context, widget.order.id!),
                        )
                      ],
                    ),
                  )
                else
                  const SizedBox()
          ],
        ),
      ),
    );
  }
}

class _ListProductsDetails extends StatelessWidget {
  final List<OrderDetail> listProductDetails;

  const _ListProductsDetails({required this.listProductDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: listProductDetails.length,
      separatorBuilder: (_, index) => const Divider(),
      itemBuilder: (_, i) => Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(''))), // TODO: Add product image
            ),
            const SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                    text: listProductDetails[i].productName,
                    fontWeight: FontWeight.w500),
                const SizedBox(height: 5.0),
                TextCustom(
                    text: 'Quantity: ${listProductDetails[i].quantity}',
                    color: Colors.grey,
                    fontSize: 17),
              ],
            ),
            Expanded(
                child: Container(
              alignment: Alignment.centerRight,
              child: TextCustom(text: '\$ ${listProductDetails[i].price}'),
            ))
          ],
        ),
      ),
    );
  }
}
