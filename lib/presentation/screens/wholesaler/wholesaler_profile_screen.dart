import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/domain/models/wholesaler.dart';
import 'package:dukascango/domain/services/wholesaler_services.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';
import 'package:dukascango/presentation/walkthrough/wholesaler_walkthrough.dart';

class WholesalerProfileScreen extends StatefulWidget {
  @override
  _WholesalerProfileScreenState createState() =>
      _WholesalerProfileScreenState();
}

class _WholesalerProfileScreenState extends State<WholesalerProfileScreen> {
  late TextEditingController _businessNameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _deliveryAreasController;
  late TextEditingController _paymentDetailsController;

  final _wholesalerServices = WholesalerServices();
  Wholesaler? _wholesaler;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController();
    _contactPersonController = TextEditingController();
    _deliveryAreasController = TextEditingController();
    _paymentDetailsController = TextEditingController();
    _loadWholesalerData();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _contactPersonController.dispose();
    _deliveryAreasController.dispose();
    _paymentDetailsController.dispose();
    super.dispose();
  }

  Future<void> _loadWholesalerData() async {
    final user = BlocProvider.of<UserBloc>(context).state.user;
    if (user != null) {
      final wholesaler = await _wholesalerServices.getWholesalerById(user.uid);
      if (wholesaler != null) {
        setState(() {
          _wholesaler = wholesaler;
          _businessNameController.text = wholesaler.businessName;
          _contactPersonController.text = wholesaler.contactPerson;
          _deliveryAreasController.text = wholesaler.deliveryAreas.join(', ');
          _paymentDetailsController.text = wholesaler.paymentDetails;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextCustom(text: 'Profile'),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => WholesalerWalkthroughScreen())),
                child: TextCustom(
                  text: 'Walkthrough',
                  color: ColorsDukascango.primaryColor,
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_wholesaler != null) {
                    final updatedWholesaler = Wholesaler(
                      uid: _wholesaler!.uid,
                      businessName: _businessNameController.text,
                      contactPerson: _contactPersonController.text,
                      deliveryAreas: _deliveryAreasController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList(),
                      paymentDetails: _paymentDetailsController.text,
                    );
                    await _wholesalerServices
                        .updateWholesaler(updatedWholesaler);
                    modalSuccess(context, 'Profile updated successfully',
                        () => Navigator.pop(context));
                  }
                },
                child: TextCustom(
                  text: 'Save',
                  color: ColorsDukascango.primaryColor,
                ),
              ),
            ],
          )
        ],
      ),
      body: _wholesaler == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FormFieldDukascango(
                    controller: _businessNameController,
                    hintText: 'Business Name',
                  ),
                  SizedBox(height: 16),
                  FormFieldDukascango(
                    controller: _contactPersonController,
                    hintText: 'Contact Person',
                  ),
                  SizedBox(height: 16),
                  FormFieldDukascango(
                    controller: _deliveryAreasController,
                    hintText: 'Delivery Areas (comma separated)',
                  ),
                  SizedBox(height: 16),
                  FormFieldDukascango(
                    controller: _paymentDetailsController,
                    hintText: 'Payment Details',
                  ),
                ],
              ),
            ),
    );
  }
}
