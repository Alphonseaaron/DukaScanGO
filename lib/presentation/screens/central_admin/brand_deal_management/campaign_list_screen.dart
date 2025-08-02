import 'package:dukascango/domain/models/campaign.dart';
import 'package:dukascango/domain/services/campaign_services.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/campaign_details_screen.dart';
import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/create_campaign_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CampaignListScreen extends StatefulWidget {
  final String brandId;

  const CampaignListScreen({Key? key, required this.brandId}) : super(key: key);

  @override
  _CampaignListScreenState createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  late Future<List<Campaign>> _campaigns;

  @override
  void initState() {
    super.initState();
    _campaigns = CampaignService().getCampaignsByBrand(widget.brandId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campaigns'),
      ),
      body: FutureBuilder<List<Campaign>>(
        future: _campaigns,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No campaigns found.'));
          } else {
            final campaigns = snapshot.data!;
            return ListView.builder(
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final campaign = campaigns[index];
                return ListTile(
                  title: Text(campaign.name),
                  subtitle: Text(
                      '${DateFormat.yMd().format(campaign.startDate)} - ${DateFormat.yMd().format(campaign.endDate)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CampaignDetailsScreen(campaign: campaign),
                      ),
                    ).then((_) {
                      // Refresh the list when coming back
                      setState(() {
                        _campaigns =
                            CampaignService().getCampaignsByBrand(widget.brandId);
                      });
                    });
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCampaignScreen(brandId: widget.brandId),
            ),
          ).then((_) {
            // Refresh the list when coming back
            setState(() {
              _campaigns =
                  CampaignService().getCampaignsByBrand(widget.brandId);
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
