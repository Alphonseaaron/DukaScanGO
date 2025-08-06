import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/domain/models/order.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/date_custom.dart';
import 'package:dukascango/presentation/screens/admin/orders_admin/order_details_screen.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class SelfScanOrdersScreen extends StatefulWidget {
  @override
  _SelfScanOrdersScreenState createState() => _SelfScanOrdersScreenState();
}

class _SelfScanOrdersScreenState extends State<SelfScanOrdersScreen> {
  late TextEditingController _searchController;
  List<Order> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    BlocProvider.of<OrdersBloc>(context)
        .add(OnGetOrdersByPaymentTypeEvent('SELF-SCAN'));
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final orders = (BlocProvider.of<OrdersBloc>(context).state).orders;
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOrders = orders
          .where((order) =>
              order.id!.toLowerCase().contains(query) ||
              order.clientId.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Self-Scan Orders'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Order ID or Customer ID',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                if (state is LoadingOrderState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is FailureOrdersState) {
                  return Center(child: TextCustom(text: state.error));
                }
                if (_searchController.text.isEmpty) {
                  _filteredOrders = state.orders;
                }
                if (_filteredOrders.isNotEmpty) {
                  return _ListOrders(listOrders: _filteredOrders);
                }
                return const Center(child: Text('No orders found.'));
              },
            ),
          ),
        ],
      ),
    );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextCustom(
                      text: 'Total',
                      fontSize: 16,
                      color: ColorsDukascango.secundaryColor),
                  TextCustom(
                      text: '\$${order.total.toStringAsFixed(2)}',
                      fontSize: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
