import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/gateway/personal-services.dart';
import 'package:kms/src/utils/routes/route-names.dart';
import 'package:kms/src/widgets/ussdDepositDialog.dart';
import 'package:kms/src/widgets/savingsTransactionDialog.dart';
import 'package:kms/src/widgets/sharesTransactionDialog.dart';
import 'package:kms/src/widgets/loanCalculatorDialog.dart';
import 'package:kms/src/widgets/dividendsDialog.dart';

class FinanceHub extends StatefulWidget {
  const FinanceHub({Key? key}) : super(key: key);

  @override
  State<FinanceHub> createState() => _FinanceHubState();
}

class _FinanceHubState extends State<FinanceHub>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PersonalService _personalService = PersonalService();

  // Data state
  List<dynamic>? _savingsData;
  List<dynamic>? _loansData;
  List<dynamic>? _sharesData;
  bool _isLoadingSavings = true;
  bool _isLoadingLoans = true;
  bool _isLoadingShares = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      _loadSavingsData(),
      _loadLoansData(),
      _loadSharesData(),
    ]);
  }

  Future<void> _loadSavingsData() async {
    setState(() => _isLoadingSavings = true);
    final data = await _personalService.getSavingsData(context);
    setState(() {
      _savingsData = data;
      _isLoadingSavings = false;
    });
  }

  Future<void> _loadLoansData() async {
    setState(() => _isLoadingLoans = true);
    final data = await _personalService.getLoansData(context);
    setState(() {
      _loansData = data;
      _isLoadingLoans = false;
    });
  }

  Future<void> _loadSharesData() async {
    setState(() => _isLoadingShares = true);
    final data = await _personalService.getSharesData(context);
    setState(() {
      _sharesData = data;
      _isLoadingShares = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Handle USSD Deposit
  void _showUSSDDepositDialog() {
    // Get the first savings account for deposit
    if (_savingsData != null && _savingsData!.isNotEmpty) {
      final account = _savingsData!.first;
      showDialog(
        context: context,
        builder: (context) => USSDDepositDialog(account: account),
      ).then((result) {
        if (result == true) {
          // Refresh savings data if deposit was successful
          _loadSavingsData();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No savings accounts found. Please create a savings account first.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Handle Withdrawal Request
  void _showWithdrawalDialog() {
    // Get the first savings account for withdrawal
    if (_savingsData != null && _savingsData!.isNotEmpty) {
      final account = _savingsData!.first;
      showDialog(
        context: context,
        builder: (context) => SavingsTransactionDialog(
          account: account,
          transactionType: 'withdrawal',
        ),
      ).then((result) {
        if (result == true) {
          // Refresh savings data if withdrawal request was successful
          _loadSavingsData();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No savings accounts found. Please create a savings account first.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Handle Goals
  void _showGoalsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.flag_outlined,
                  color: Colors.purple, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Savings Goals'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Savings Goals feature is coming soon!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'With this feature, you will be able to:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• Set savings targets'),
            const Text('• Track progress towards goals'),
            const Text('• Get notifications when goals are achieved'),
            const Text('• Visualize your savings journey'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  // Handle Buy Shares
  void _showBuySharesDialog() {
    if (_sharesData != null && _sharesData!.isNotEmpty) {
      final shareData = _sharesData!.first;
      showDialog(
        context: context,
        builder: (context) => SharesTransactionDialog(
          shareData: shareData,
          transactionType: 'buy',
        ),
      ).then((result) {
        if (result == true) {
          // Refresh shares data if purchase was successful
          _loadSharesData();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('No shares found. Please join a Vikoba with shares first.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Handle Sell Shares
  void _showSellSharesDialog() {
    if (_sharesData != null && _sharesData!.isNotEmpty) {
      final shareData = _sharesData!.first;
      showDialog(
        context: context,
        builder: (context) => SharesTransactionDialog(
          shareData: shareData,
          transactionType: 'sell',
        ),
      ).then((result) {
        if (result == true) {
          // Refresh shares data if sell request was successful
          _loadSharesData();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('No shares found. Please join a Vikoba with shares first.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Handle Loan Calculator
  void _showLoanCalculatorDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoanCalculatorPage(),
      ),
    );
  }

  // Handle Dividends
  void _showDividendsDialog() {
    if (_sharesData != null && _sharesData!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => DividendsDialog(sharesData: _sharesData!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No shares found. Please join a Vikoba with shares first.'),
          backgroundColor: Colors.orange,
        ),
      );
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
          'Finance Hub',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConst.primary,
          labelColor: AppConst.primary,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.account_balance_wallet, size: 20),
              text: 'Savings',
            ),
            Tab(
              icon: Icon(Icons.credit_card, size: 20),
              text: 'Loans',
            ),
            Tab(
              icon: Icon(Icons.pie_chart, size: 20),
              text: 'Shares',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSavingsTab(),
          _buildLoansTab(),
          _buildSharesTab(),
        ],
      ),
    );
  }

  Widget _buildSavingsTab() {
    if (_isLoadingSavings) {
      return const Center(child: CircularProgressIndicator());
    }

    final totalSavings = _savingsData?.fold<double>(0, (sum, account) {
          return sum +
              (double.tryParse(account['balance']?.toString() ?? '0') ?? 0);
        }) ??
        0.0;

    final savingsCount = _savingsData?.length ?? 0;

    return RefreshIndicator(
      onRefresh: _loadSavingsData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Savings Overview Card
            _buildOverviewCard(
              'Total Savings',
              _personalService.formatCurrency(totalSavings),
              Icons.account_balance_wallet,
              Colors.green,
              'Accounts: $savingsCount',
              'Interest Rate: 5% p.a.',
            ),
            const SizedBox(height: 24),

            // Savings Accounts List
            if (_savingsData != null && _savingsData!.isNotEmpty) ...[
              const Text(
                'Savings Accounts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ..._savingsData!
                  .map((account) => _buildSavingsAccountCard(account)),
              const SizedBox(height: 24),
            ],

            // Quick Actions
            _buildQuickActions([
              _buildActionItem('Deposit', Icons.add_circle_outline,
                  Colors.green, _showUSSDDepositDialog),
              _buildActionItem('Withdraw', Icons.remove_circle_outline,
                  Colors.orange, _showWithdrawalDialog),
              _buildActionItem('History', Icons.history, Colors.blue, () {
                Navigator.pushNamed(context, RouteNames.savings);
              }),
              _buildActionItem('Goals', Icons.flag_outlined, Colors.purple,
                  _showGoalsDialog),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildLoansTab() {
    if (_isLoadingLoans) {
      return const Center(child: CircularProgressIndicator());
    }

    final activeLoans = _loansData
            ?.where((loan) =>
                loan['status'] == 'active' || loan['status'] == 'disbursed')
            .toList() ??
        [];

    final totalLoanAmount = activeLoans.fold<double>(0, (sum, loan) {
      return sum +
          (double.tryParse(loan['total_amount']?.toString() ?? '0') ?? 0);
    });

    final loansCount = activeLoans.length;

    return RefreshIndicator(
      onRefresh: _loadLoansData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loans Overview Card
            _buildOverviewCard(
              'Active Loans',
              _personalService.formatCurrency(totalLoanAmount),
              Icons.credit_card,
              Colors.orange,
              'Loans: $loansCount',
              'Interest Rate: 12% p.a.',
            ),
            const SizedBox(height: 24),

            // Active Loans List
            if (activeLoans.isNotEmpty) ...[
              const Text(
                'Active Loans',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...activeLoans.map((loan) => _buildLoanCard(loan)),
              const SizedBox(height: 24),
            ],

            // Quick Actions
            _buildQuickActions([
              _buildActionItem(
                  'Apply Loan', Icons.add_circle_outline, Colors.green, () {
                Navigator.pushNamed(context, RouteNames.loanApplication);
              }),
              _buildActionItem('Make Payment', Icons.payment, Colors.blue, () {
                Navigator.pushNamed(context, RouteNames.loan);
              }),
              _buildActionItem('History', Icons.history, Colors.purple, () {
                Navigator.pushNamed(context, RouteNames.loan);
              }),
              _buildActionItem('Calculator', Icons.calculate, Colors.orange,
                  _showLoanCalculatorDialog),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSharesTab() {
    if (_isLoadingShares) {
      return const Center(child: CircularProgressIndicator());
    }

    final totalSharesValue = _sharesData?.fold<double>(0, (sum, share) {
          return sum +
              (double.tryParse(
                      share['total_shares_value']?.toString() ?? '0') ??
                  0);
        }) ??
        0.0;

    final totalShares = _sharesData?.fold<int>(0, (sum, share) {
          return sum +
              (int.tryParse(share['shares_owned']?.toString() ?? '0') ?? 0);
        }) ??
        0;

    return RefreshIndicator(
      onRefresh: _loadSharesData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shares Overview Card
            _buildOverviewCard(
              'Shares Portfolio',
              _personalService.formatCurrency(totalSharesValue),
              Icons.pie_chart,
              Colors.blue,
              'Total Shares: $totalShares',
              'Portfolio Value',
            ),
            const SizedBox(height: 24),

            // Shares List
            if (_sharesData != null && _sharesData!.isNotEmpty) ...[
              const Text(
                'Share Holdings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ..._sharesData!.map((share) => _buildShareCard(share)),
              const SizedBox(height: 24),
            ],

            // Quick Actions
            _buildQuickActions([
              _buildActionItem('Buy Shares', Icons.add_circle_outline,
                  Colors.green, _showBuySharesDialog),
              _buildActionItem('Sell Shares', Icons.remove_circle_outline,
                  Colors.red, _showSellSharesDialog),
              _buildActionItem('Dividends', Icons.trending_up, Colors.blue, _showDividendsDialog),
              _buildActionItem('History', Icons.history, Colors.purple, () {
                Navigator.pushNamed(context, RouteNames.shares);
              }),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String amount, IconData icon,
      Color color, String subtitle1, String subtitle2) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(subtitle1, Colors.white70),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildStatItem(subtitle2, Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String text, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuickActions(List<Widget> actions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: actions[0]),
            const SizedBox(width: 12),
            Expanded(child: actions[1]),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: actions[2]),
            const SizedBox(width: 12),
            Expanded(child: actions[3]),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(String title, IconData icon, Color color,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap ??
          () {
            // Default action - show coming soon message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title feature coming soon!'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsAccountCard(Map<String, dynamic> account) {
    final balance = double.tryParse(account['balance']?.toString() ?? '0') ?? 0;
    final accountName = account['account_name'] as String? ?? 'Savings Account';
    final accountNumber = account['account_number'] as String? ?? '';
    final vikobaName = account['vikoba_name'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                  'Active',
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
          const SizedBox(height: 4),
          if (accountNumber.isNotEmpty)
            Text(
              'Account: $accountNumber',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          if (vikobaName.isNotEmpty)
            Text(
              'Vikoba: $vikobaName',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoanCard(Map<String, dynamic> loan) {
    final totalAmount =
        double.tryParse(loan['total_amount']?.toString() ?? '0') ?? 0;
    final principalAmount =
        double.tryParse(loan['principal_amount']?.toString() ?? '0') ?? 0;
    final loanId = loan['loan_id'] as String? ?? '';
    final status = loan['status'] as String? ?? '';
    final productName = loan['product_name'] as String? ?? '';
    final vikobaName = loan['vikoba_name'] as String? ?? '';

    Color statusColor = Colors.blue;
    if (status == 'active') {
      statusColor = Colors.green;
    } else if (status == 'overdue') {
      statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                  productName,
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
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _personalService.formatCurrency(totalAmount),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Principal: ${_personalService.formatCurrency(principalAmount)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          if (loanId.isNotEmpty)
            Text(
              'Loan ID: $loanId',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          if (vikobaName.isNotEmpty)
            Text(
              'Vikoba: $vikobaName',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Text(
            vikobaName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
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
          const SizedBox(height: 4),
          Text(
            'Shares: $sharesOwned',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Price per share: ${_personalService.formatCurrency(shareValuePerUnit)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
