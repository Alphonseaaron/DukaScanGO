import 'package:dukascango/domain/models/wallet_ledger_entry_model.dart';
import 'package:dukascango/domain/services/wallet_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('WalletService', () {
    late WalletService walletService;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      walletService = WalletService(firestore: fakeFirestore);
    });

    test('createWalletForUser creates a new wallet if one does not exist', () async {
      const userId = 'testUser';
      await walletService.createWalletForUser(userId);

      final snapshot = await fakeFirestore.collection('wallets').where('ownerId', isEqualTo: userId).get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first['ownerId'], userId);
    });

    test('createWalletForUser does not create a new wallet if one already exists', () async {
      const userId = 'existingUser';
      await fakeFirestore.collection('wallets').add({'ownerId': userId, 'balance': 100.0});

      await walletService.createWalletForUser(userId);

      final snapshot = await fakeFirestore.collection('wallets').where('ownerId', isEqualTo: userId).get();
      expect(snapshot.docs.length, 1);
    });

    test('getWallet returns a wallet if it exists', () async {
      final docRef = await fakeFirestore.collection('wallets').add({'ownerId': 'testUser'});
      final wallet = await walletService.getWallet(docRef.id);

      expect(wallet, isNotNull);
      expect(wallet!.id, docRef.id);
    });

    test('getWallet returns null if the wallet does not exist', () async {
      final wallet = await walletService.getWallet('nonExistentId');
      expect(wallet, isNull);
    });

    test('addLedgerEntry adds a new entry to the wallet_ledger subcollection', () async {
      final docRef = await fakeFirestore.collection('wallets').add({'ownerId': 'testUser'});
      final ledgerEntry = WalletLedgerEntry(
        id: 'test-entry',
        type: LedgerEntryType.credit,
        amount: 100.0,
        description: 'Test credit',
        gatewayFee: 0,
        platformFee: 0,
        status: LedgerEntryStatus.completed,
        createdAt: Timestamp.now(),
      );

      await walletService.addLedgerEntry(docRef.id, ledgerEntry);

      final snapshot = await fakeFirestore.collection('wallets').doc(docRef.id).collection('wallet_ledger').get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first['description'], 'Test credit');
    });
  });
}
