import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/wallet_ledger_entry_model.dart';
import 'package:dukascango/domain/models/wallet_model.dart';

class WalletService {
  final FirebaseFirestore _firestore;

  WalletService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _walletsCollection => _firestore.collection('wallets');

  Future<void> createWalletForUser(String userId) async {
    try {
      // Check if a wallet already exists for the user
      final querySnapshot = await _walletsCollection.where('ownerId', isEqualTo: userId).get();
      if (querySnapshot.docs.isNotEmpty) {
        print('Wallet already exists for this user.');
        return;
      }

      // Create a new wallet
      await _walletsCollection.add({
        'ownerId': userId,
        'gateway': 'default', // Or determine a default gateway
        'gatewayReference': '',
        'balance': 0.0,
        'currency': 'USD', // Or a default currency
        'commissionPercent': 0.0,
        'holdBalance': 0.0,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error creating wallet: $e');
      throw Exception('Failed to create wallet');
    }
  }

  Future<Wallet?> getWallet(String walletId) async {
    try {
      final doc = await _walletsCollection.doc(walletId).get();
      if (doc.exists) {
        return Wallet.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting wallet: $e');
      throw Exception('Failed to get wallet');
    }
  }

  Future<void> addLedgerEntry(String walletId, WalletLedgerEntry entry) async {
    try {
      await _walletsCollection.doc(walletId).collection('wallet_ledger').add(entry.toMap());
    } catch (e) {
      print('Error adding ledger entry: $e');
      throw Exception('Failed to add ledger entry');
    }
  }

  Future<List<WalletLedgerEntry>> getLedgerEntries(String walletId) async {
    try {
      final snapshot = await _walletsCollection.doc(walletId).collection('wallet_ledger').orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) => WalletLedgerEntry.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting ledger entries: $e');
      throw Exception('Failed to get ledger entries');
    }
  }
}
