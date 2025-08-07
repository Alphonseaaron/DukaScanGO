import 'package:dukascango/domain/bloc/wallet/wallet_bloc.dart';
import 'package:dukascango/domain/models/wallet_ledger_entry_model.dart';
import 'package:dukascango/domain/services/wallet_service.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletScreen extends StatelessWidget {
  final String walletId;

  const WalletScreen({Key? key, required this.walletId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(walletService: WalletService())..add(LoadWalletDetailsEvent(walletId)),
      child: Scaffold(
        backgroundColor: ColorsDukascango.backgroundColor,
        appBar: AppBar(
          title: const TextCustom(text: 'My Wallet', color: Colors.white),
          backgroundColor: ColorsDukascango.primaryColor,
        ),
        body: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is WalletLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WalletFailure) {
              return Center(child: TextCustom(text: 'Error: ${state.error}'));
            } else if (state is WalletLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WalletBloc>().add(LoadWalletDetailsEvent(walletId));
                },
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildBalanceCard(state),
                    const SizedBox(height: 20),
                    BtnDukascango(
                      text: 'Withdraw Funds',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Withdrawal functionality not yet implemented.')),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const TextCustom(text: 'Transaction History', fontSize: 20, fontWeight: FontWeight.bold),
                    const SizedBox(height: 10),
                    _buildTransactionList(state),
                  ],
                ),
              );
            }
            return const Center(child: TextCustom(text: 'No wallet data.'));
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard(WalletLoaded state) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextCustom(text: 'Balance', fontSize: 16, color: ColorsDukascango.secundaryColor),
            TextCustom(text: '${state.wallet.balance} ${state.wallet.currency}', fontSize: 32, fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            const TextCustom(text: 'Held Balance', fontSize: 16, color: ColorsDukascango.secundaryColor),
            TextCustom(text: '${state.wallet.holdBalance} ${state.wallet.currency}', fontSize: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(WalletLoaded state) {
    if (state.ledgerEntries.isEmpty) {
      return const Center(child: TextCustom(text: 'No transactions yet.'));
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.ledgerEntries.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final entry = state.ledgerEntries[index];
        final isCredit = entry.type == LedgerEntryType.credit;
        return ListTile(
          leading: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? Colors.green : Colors.red, size: 30),
          title: TextCustom(text: entry.description),
          subtitle: TextCustom(text: '${entry.createdAt.toDate()}', fontSize: 12),
          trailing: TextCustom(
            text: '${isCredit ? '+' : '-'}${entry.amount}',
            color: isCredit ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        );
      },
    );
  }
}
