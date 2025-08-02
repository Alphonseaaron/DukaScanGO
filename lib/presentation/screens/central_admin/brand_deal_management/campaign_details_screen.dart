import 'package:dukascango/domain/models/campaign.dart';
import 'package:dukascango/domain/services/campaign_services.dart';
import 'package:dukascango/presentation/helpers/modal_delete.dart';
import 'package:dukascango/presentation/helpers/modal_loading.dart';
import 'package:dukascango/presentation/helpers/modal_success.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/edit_campaign_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CampaignDetailsScreen extends StatefulWidget {
  final Campaign campaign;

  const CampaignDetailsScreen({Key? key, required this.campaign})
      : super(key: key);

  @override
  _CampaignDetailsScreenState createState() => _CampaignDetailsScreenState();
}

class _CampaignDetailsScreenState extends State<CampaignDetailsScreen> {
  late Campaign _campaign;

  @override
  void initState() {
    super.initState();
    _campaign = widget.campaign;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campaign Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCampaignScreen(campaign: _campaign),
                ),
              ).then((value) {
                if (value == true) {
                  // Reload the campaign data if it was updated
                  CampaignService()
                      .getCampaignById(_campaign.id!)
                      .then((updatedCampaign) {
                    if (updatedCampaign != null) {
                      setState(() {
                        _campaign = updatedCampaign;
                      });
                    }
                  });
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              modalDelete(context, 'Delete Campaign',
                  'Are you sure you want to delete this campaign?', () async {
                modalLoading(context);
                await CampaignService().deleteCampaign(_campaign.id!);
                Navigator.pop(context);
                modalSuccess(context, 'Campaign deleted successfully!',
                    onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true); // Go back to campaign list
                });
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_campaign.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Description: ${_campaign.description}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                'Start Date: ${DateFormat.yMd().format(_campaign.startDate)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('End Date: ${DateFormat.yMd().format(_campaign.endDate)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Budget: \$${_campaign.budget.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
