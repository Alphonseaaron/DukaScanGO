import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/dashboard/dashboard_bloc.dart';
import 'package:dukascango/domain/models/restocking_request.dart';
import 'package:dukascango/domain/services/inventory_services.dart';
import 'package:dukascango/presentation/components/components.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DashboardBloc>(context).add(FetchDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Dashboard'),
        centerTitle: true,
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardFailure) {
            return Center(child: TextCustom(text: state.error));
          }
          if (state is DashboardSuccess) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const TextCustom(text: 'Dashboard Overview', fontSize: 24, fontWeight: FontWeight.bold),
                const SizedBox(height: 20),
                _buildMetricsCard('Total Sales', '\$${state.totalSales.toStringAsFixed(2)}'),
                const SizedBox(height: 10),
                _buildMetricsCard('Pending Orders', state.pendingOrders.toString()),
                const SizedBox(height: 10),
                _buildMetricsCard('Completed Orders', state.completedOrders.toString()),
                const SizedBox(height: 20),
                const TextCustom(text: 'Low Stock Items', fontSize: 20, fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                _buildLowStockList(state.lowStockItems),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildMetricsCard(String title, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextCustom(text: title, fontSize: 18, fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            TextCustom(text: value, fontSize: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockList(List<dynamic> items) {
    if (items.isEmpty) {
      return const Text('No low stock items.');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: TextCustom(text: item.name),
          subtitle: TextCustom(text: 'Stock: ${item.stockQuantity}'),
          trailing: TextButton(
            child: const Text('Request Restock'),
            onPressed: () {
              // TODO: Implement this properly with a BLoC
              final request = RestockingRequest(
                productId: item.id!,
                productName: item.name,
                currentQuantity: item.stockQuantity!,
                lowStockThreshold: item.lowStockThreshold!,
                status: 'pending',
                dateRequested: DateTime.now(),
                requestorId: 'admin_user_id', // TODO: Get real user ID
              );
              InventoryServices().createRestockingRequest(request);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restocking request created.')),
              );
            },
          ),
        );
      },
    );
  }
}
