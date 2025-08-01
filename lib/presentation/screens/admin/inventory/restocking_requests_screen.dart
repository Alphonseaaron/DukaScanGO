import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/inventory/inventory_bloc.dart';
import 'package:dukascango/domain/models/restocking_request.dart';
import 'package:dukascango/presentation/components/components.dart';

class RestockingRequestsScreen extends StatefulWidget {
  @override
  _RestockingRequestsScreenState createState() =>
      _RestockingRequestsScreenState();
}

class _RestockingRequestsScreenState extends State<RestockingRequestsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InventoryBloc>(context)
        .add(OnGetRestockingRequestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Restocking Requests'),
        centerTitle: true,
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is InventoryFailure) {
            return Center(child: TextCustom(text: state.error));
          }
          if (state.restockingRequests.isNotEmpty) {
            return _ListRestockingRequests(
                requests: state.restockingRequests);
          }
          return const Center(child: Text('No restocking requests found.'));
        },
      ),
    );
  }
}

class _ListRestockingRequests extends StatelessWidget {
  final List<RestockingRequest> requests;

  const _ListRestockingRequests({required this.requests});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          child: ListTile(
            title: TextCustom(text: request.productName),
            subtitle: TextCustom(
                text:
                    'Current: ${request.currentQuantity}, Threshold: ${request.lowStockThreshold}'),
            trailing: TextCustom(text: request.status),
          ),
        );
      },
    );
  }
}
