import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/payment_gateway_model.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';
import 'package:flutter/material.dart';

class GatewayManagementScreen extends StatelessWidget {
  const GatewayManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsDukascango.backgroundColor,
      appBar: AppBar(
        title: const TextCustom(text: 'Gateway Management', color: Colors.white),
        backgroundColor: ColorsDukascango.primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('gateways').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: TextCustom(text: 'Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final gateways = snapshot.data!.docs.map((doc) => PaymentGateway.fromFirestore(doc)).toList();

          return ListView.builder(
            itemCount: gateways.length,
            itemBuilder: (context, index) {
              final gateway = gateways[index];
              return ListTile(
                title: TextCustom(text: gateway.name, fontWeight: FontWeight.bold),
                subtitle: TextCustom(text: 'Countries: ${gateway.allowedCountries.join(', ')}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: ColorsDukascango.primaryColor),
                  onPressed: () {
                    _showAddEditGatewayDialog(context, gateway: gateway);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditGatewayDialog(context);
        },
        backgroundColor: ColorsDukascango.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddEditGatewayDialog(BuildContext context, {PaymentGateway? gateway}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: gateway?.name);
    final _countriesController = TextEditingController(text: gateway?.allowedCountries.join(', '));
    final _apiKeyController = TextEditingController(text: gateway?.apiConfig['apiKey']);
    final _secretKeyController = TextEditingController(text: gateway?.apiConfig['secretKey']);
    final _baseUrlController = TextEditingController(text: gateway?.apiConfig['baseUrl']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextCustom(text: gateway == null ? 'Add Gateway' : 'Edit Gateway', fontWeight: FontWeight.bold),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormFieldDukascango(
                    controller: _nameController,
                    hintText: 'Gateway Name',
                    validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  const SizedBox(height: 10),
                  FormFieldDukascango(
                    controller: _countriesController,
                    hintText: 'Allowed Countries (comma-separated)',
                    validator: (value) => value!.isEmpty ? 'Please enter countries' : null,
                  ),
                  const SizedBox(height: 10),
                  FormFieldDukascango(
                    controller: _apiKeyController,
                    hintText: 'API Key',
                  ),
                  const SizedBox(height: 10),
                  FormFieldDukascango(
                    controller: _secretKeyController,
                    hintText: 'Secret Key',
                  ),
                  const SizedBox(height: 10),
                  FormFieldDukascango(
                    controller: _baseUrlController,
                    hintText: 'Base URL',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const TextCustom(text: 'Cancel', color: ColorsDukascango.secundaryColor)),
            BtnDukascango(
              text: 'Save',
              width: 100,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newGateway = {
                    'name': _nameController.text,
                    'allowedCountries': _countriesController.text.split(',').map((e) => e.trim().toUpperCase()).toList(),
                    'apiConfig': {
                      'apiKey': _apiKeyController.text,
                      'secretKey': _secretKeyController.text,
                      'baseUrl': _baseUrlController.text,
                    }
                  };

                  if (gateway == null) {
                    FirebaseFirestore.instance.collection('gateways').add(newGateway);
                  } else {
                    FirebaseFirestore.instance.collection('gateways').doc(gateway.id).update(newGateway);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
