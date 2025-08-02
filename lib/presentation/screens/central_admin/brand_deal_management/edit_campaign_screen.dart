import 'package:dukascango/domain/models/campaign.dart';
import 'package:dukascango/domain/models/featured_store.dart';
import 'package:dukascango/domain/services/campaign_services.dart';
import 'package:dukascango/domain/services/featured_store_service.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditCampaignScreen extends StatefulWidget {
  final Campaign campaign;

  const EditCampaignScreen({Key? key, required this.campaign})
      : super(key: key);

  @override
  _EditCampaignScreenState createState() => _EditCampaignScreenState();
}

class _EditCampaignScreenState extends State<EditCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedFeaturedStoreId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.campaign.name);
    _descriptionController =
        TextEditingController(text: widget.campaign.description);
    _budgetController =
        TextEditingController(text: widget.campaign.budget.toString());
    _startDate = widget.campaign.startDate;
    _endDate = widget.campaign.endDate;
    _selectedFeaturedStoreId = widget.campaign.featuredStoreId;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate! : _endDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Campaign'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _budgetController,
                decoration: InputDecoration(labelText: 'Budget'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budget';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              if (widget.campaign.brandId == null)
                FutureBuilder<List<FeaturedStore>>(
                  future: FeaturedStoreService().getFeaturedStores(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButtonFormField<String>(
                        value: _selectedFeaturedStoreId,
                        items: snapshot.data!
                            .map((store) => DropdownMenuItem(
                                  value: store.id,
                                  child: Text(store.storeId), // TODO: Get store name
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFeaturedStoreId = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Select a featured store',
                          border: OutlineInputBorder(),
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(_startDate == null
                        ? 'No start date selected'
                        : 'Start Date: ${DateFormat.yMd().format(_startDate!)}'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text('Select Start Date'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(_endDate == null
                        ? 'No end date selected'
                        : 'End Date: ${DateFormat.yMd().format(_endDate!)}'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text('Select End Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _startDate != null &&
                      _endDate != null) {
                    modalLoading(context);
                    final updatedCampaign = widget.campaign.copyWith(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      startDate: _startDate,
                      endDate: _endDate,
                      budget: double.parse(_budgetController.text),
                      featuredStoreId: _selectedFeaturedStoreId,
                    );
                    await CampaignService().updateCampaign(updatedCampaign);
                    Navigator.pop(context); // Close loading modal
                    modalSuccess(context, 'Campaign updated successfully!',
                        onPressed: () {
                      Navigator.pop(context); // Close success modal
                      Navigator.pop(context, true); // Go back to details screen
                    });
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
