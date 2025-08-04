import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/domain/models/order.dart';
import 'package:dukascango/domain/models/pay_type.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/date_custom.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/screens/admin/orders_admin/order_details_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class OrdersAdminScreen extends StatefulWidget {
  @override
  _OrdersAdminScreenState createState() => _OrdersAdminScreenState();
}

class _OrdersAdminScreenState extends State<OrdersAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: payType.length, vsync: this);
    BlocProvider.of<OrdersBloc>(context)
        .add(OnGetOrdersByStatusEvent(payType[0]));
    _tabController.addListener(() {
      BlocProvider.of<OrdersBloc>(context)
          .add(OnGetOrdersByStatusEvent(payType[_tabController.index]));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: 'List Orders', fontSize: 20),
          centerTitle: true,
          leadingWidth: 80,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_back_ios_new_outlined,
                    color: ColorsDukascango.primaryColor, size: 17),
                TextCustom(
                    text: 'Back',
                    color: ColorsDukascango.primaryColor,
                    fontSize: 17)
              ],
            ),
          ),
          bottom: TabBar(
              controller: _tabController,
              indicatorWeight: 2,
              labelColor: ColorsDukascango.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: ColorsDukascango.primaryColor),
              ),
              isScrollable: true,
              tabs: List<Widget>.generate(
                  payType.length,
                  (i) => Tab(
                      child: Text(payType[i],
                          style: GoogleFonts.getFont('Roboto',
                              fontSize: 17))))),
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is LoadingOrderState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FailureOrdersState) {
              return Center(child: TextCustom(text: state.error));
            }
            if (state.orders.isNotEmpty) {
              return _ListOrders(listOrders: state.orders);
            }
            return const Center(child: Text('No orders found.'));
          },
        ));
  }
}

class _ListOrders extends StatelessWidget {
  final List<Order> listOrders;

  const _ListOrders({required this.listOrders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listOrders.length,
      itemBuilder: (context, i) => _CardOrders(order: listOrders[i]),
    );
  }
}

class _CardOrders extends StatelessWidget {
  final Order order;

  const _CardOrders({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.blueGrey, blurRadius: 8, spreadRadius: -5)
          ]),
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () => Navigator.push(
            context, routeDukascango(page: OrderDetailsScreen(order: order))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextCustom(text: 'ORDER ID: ${order.id}'),
              const Divider(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextCustom(
                      text: 'Date',
                      fontSize: 16,
                      color: ColorsDukascango.secundaryColor),
                  TextCustom(
                      text: DateCustom.getDateOrder(order.date.toString()),
                      fontSize: 16),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextCustom(
                      text: 'Client ID',
                      fontSize: 16,
                      color: ColorsDukascango.secundaryColor),
                  TextCustom(text: order.clientId, fontSize: 16),
                ],
              ),
              const SizedBox(height: 10.0),
              const TextCustom(
                  text: 'Address shipping',
                  fontSize: 16,
                  color: ColorsDukascango.secundaryColor),
              const SizedBox(height: 5.0),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextCustom(text: order.address,
                      fontSize: 16, maxLine: 2)),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}