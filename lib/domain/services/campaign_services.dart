import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/campaign.dart';

class CampaignService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCampaign(Campaign campaign) async {
    await _firestore.collection('campaigns').add(campaign.toMap());
  }

  Future<List<Campaign>> getCampaignsByBrand(String brandId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('campaigns')
        .where('brandId', isEqualTo: brandId)
        .get();
    return snapshot.docs
        .map((doc) => Campaign.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Campaign?> getCampaignById(String id) async {
    final DocumentSnapshot doc =
        await _firestore.collection('campaigns').doc(id).get();
    if (doc.exists) {
      return Campaign.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateCampaign(Campaign campaign) async {
    await _firestore
        .collection('campaigns')
        .doc(campaign.id)
        .update(campaign.toMap());
  }

  Future<void> deleteCampaign(String id) async {
    await _firestore.collection('campaigns').doc(id).delete();
  }
}
