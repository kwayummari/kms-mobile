import 'package:flutter/material.dart';
import 'package:kms/src/gateway/personal-services.dart';
import 'package:kms/src/widgets/sharesTransactionDialog.dart';

class AllShares extends StatefulWidget {
  const AllShares({super.key});

  @override
  State<AllShares> createState() => _AllSharesState();
}

class _AllSharesState extends State<AllShares> {
  List<dynamic> _sharesData = [];
  bool _isLoading = true;
  final PersonalService _personalService = PersonalService();

  @override
  void initState() {
    super.initState();
    _loadSharesData();
  }

  Future<void> _loadSharesData() async {
    setState(() => _isLoading = true);

    try {
      final sharesData = await _personalService.getSharesData(context);
      setState(() {
        _sharesData = sharesData ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _sharesData = [];
        _isLoading = false;
      });
    }
  }

  void _showBuySharesDialog(Map<String, dynamic> shareData) {
    showDialog(
      context: context,
      builder: (context) => SharesTransactionDialog(
        shareData: shareData,
        transactionType: 'buy',
      ),
    ).then((result) {
      if (result == true) {
        // Refresh data if transaction was successful
        _loadSharesData();
      }
    });
  }

  void _showSellSharesDialog(Map<String, dynamic> shareData) {
    showDialog(
      context: context,
      builder: (context) => SharesTransactionDialog(
        shareData: shareData,
        transactionType: 'sell',
      ),
    ).then((result) {
      if (result == true) {
        // Refresh data if transaction was successful
        _loadSharesData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Shares',
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
              onRefresh: _loadSharesData,
              child: _sharesData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pie_chart_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No shares found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You don\'t have any shares yet.',
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
                          Text(
                            'Share Holdings (${_sharesData.length})',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._sharesData.map((share) => _buildShareCard(share)),
                        ],
                      ),
                    ),
            ),
    );
  }

  Widget _buildShareCard(Map<String, dynamic> share) {
    final sharesOwned =
        int.tryParse(share['shares_owned']?.toString() ?? '0') ?? 0;
    final totalValue =
        double.tryParse(share['total_shares_value']?.toString() ?? '0') ?? 0;
    final shareValuePerUnit =
        double.tryParse(share['share_value_per_unit']?.toString() ?? '0') ?? 0;
    final vikobaName = share['vikoba_name'] as String? ?? '';
    final membershipNumber = share['membership_number'] as String? ?? '';

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
                  vikobaName,
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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${sharesOwned} SHARES',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _personalService.formatCurrency(totalValue),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shares Owned',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      sharesOwned.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price per Share',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _personalService.formatCurrency(shareValuePerUnit),
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
          ),
          if (membershipNumber.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Membership: $membershipNumber',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showBuySharesDialog(share),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Buy Shares'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showSellSharesDialog(share),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Sell Shares'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
