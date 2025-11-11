import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/gateway/personal-services.dart';
import 'package:kms/src/widgets/savingsTransactionDialog.dart';
import 'package:kms/src/widgets/ussdDepositDialog.dart';
import 'package:kms/src/widgets/withdrawalRequestsCard.dart';

class AllSavings extends StatefulWidget {
  const AllSavings({super.key});

  @override
  State<AllSavings> createState() => _AllSavingsState();
}

class _AllSavingsState extends State<AllSavings> {
  List<dynamic> _savingsData = [];
  List<dynamic> _withdrawalRequests = [];
  bool _isLoading = true;
  final PersonalService _personalService = PersonalService();

  @override
  void initState() {
    super.initState();
    _loadSavingsData();
  }

  Future<void> _loadSavingsData() async {
    setState(() => _isLoading = true);

    try {
      // Load both savings data and withdrawal requests in parallel
      final results = await Future.wait([
        _personalService.getSavingsData(context),
        _personalService.getWithdrawalRequests(context),
      ]);

      setState(() {
        _savingsData = results[0] ?? [];
        _withdrawalRequests = results[1] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _savingsData = [];
        _withdrawalRequests = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _showTransactionDialog(
      Map<String, dynamic> account, String transactionType) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => SavingsTransactionDialog(
        account: account,
        transactionType: transactionType,
      ),
    );

    // If transaction was successful, refresh the data
    if (result == true) {
      _loadSavingsData();
    }
  }

  Future<void> _showUSSDDepositDialog(Map<String, dynamic> account) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => USSDDepositDialog(
        account: account,
      ),
    );

    // If transaction was successful, refresh the data
    if (result == true) {
      _loadSavingsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Savings',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSavingsData,
              child: _savingsData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No savings accounts found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You don\'t have any savings accounts yet.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Withdrawal Requests Card
                          WithdrawalRequestsCard(
                              withdrawalRequests: _withdrawalRequests),

                          Text(
                            'Savings Accounts (${_savingsData.length})',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._savingsData
                              .map((account) => _buildSavingsCard(account)),
                        ],
                      ),
                    ),
            ),
    );
  }

  Widget _buildSavingsCard(Map<String, dynamic> account) {
    final balance = double.tryParse(account['balance']?.toString() ?? '0') ?? 0;
    final accountName = account['account_name'] as String? ?? 'Savings Account';
    final accountNumber = account['account_number'] as String? ?? '';
    final vikobaName = account['vikoba_name'] as String? ?? '';
    final accountType = account['account_type'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  accountName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  accountType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _personalService.formatCurrency(balance),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (accountNumber.isNotEmpty) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Number',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        accountNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (vikobaName.isNotEmpty) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vikoba',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        vikobaName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showUSSDDepositDialog(account),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Deposit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      _showTransactionDialog(account, 'withdrawal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConst.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Withdraw'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
