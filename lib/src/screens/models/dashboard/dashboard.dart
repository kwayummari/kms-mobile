import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/gateway/personal-services.dart';
import 'package:kms/src/utils/routes/route-names.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _userName = '';
  String _userRole = '';
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  final PersonalService _personalService = PersonalService();

  // Vikoba switcher state
  List<dynamic> _memberships = [];
  Map<String, dynamic>? _selectedMembership;
  String _selectedVikobaId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadDashboardData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('full_name') ?? 'User';
      _userRole = prefs.getString('role_name') ?? 'Member';
    });
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    // Pass selected membership ID if available
    final data = await _personalService.getDashboardData(
      context,
      membershipId: _selectedVikobaId.isNotEmpty ? _selectedVikobaId : null,
    );

    setState(() {
      _dashboardData = data;
      _memberships = data?['memberships'] as List? ?? [];

      // Load selected Vikoba from SharedPreferences or select first one (only on initial load)
      if (_selectedMembership == null) {
        _loadSelectedVikoba();
      }

      _isLoading = false;
    });
  }

  Future<void> _loadSelectedVikoba() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVikobaId = prefs.getString('selected_vikoba_id');

    if (savedVikobaId != null && _memberships.isNotEmpty) {
      // Find the saved Vikoba in memberships
      final savedMembership = _memberships.firstWhere(
        (membership) => membership['membership_id'].toString() == savedVikobaId,
        orElse: () => _memberships.first,
      );
      _selectedMembership = savedMembership;
      _selectedVikobaId = savedVikobaId;
    } else if (_memberships.isNotEmpty) {
      // Select first membership by default
      _selectedMembership = _memberships.first;
      _selectedVikobaId = _memberships.first['membership_id'].toString();
      await _saveSelectedVikoba(_selectedVikobaId);
    }
  }

  Future<void> _saveSelectedVikoba(String vikobaId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_vikoba_id', vikobaId);
  }

  Future<void> _onVikobaChanged(Map<String, dynamic> selectedMembership) async {
    setState(() {
      _selectedMembership = selectedMembership;
      _selectedVikobaId = selectedMembership['membership_id'].toString();
    });

    // Save selection
    await _saveSelectedVikoba(_selectedVikobaId);

    // Reload data for the selected Vikoba
    await _loadDashboardData();
  }

  Future<void> _refreshData() async {
    await _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 32),

                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  // Quick Stats
                  _buildQuickStats(),
                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildQuickActions(),
                  const SizedBox(height: 24),

                  // Recent Activity
                  _buildRecentActivity(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Vikoba Switcher
            if (_memberships.length > 1) _buildVikobaSwitcher(),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppConst.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _userRole,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppConst.primary,
            ),
          ),
        ),
        // Selected Vikoba Info
        if (_selectedMembership != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConst.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_balance,
                    color: AppConst.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedMembership!['vikoba_name'] ?? 'Vikoba',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Membership: ${_selectedMembership!['membership_number'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_memberships.length > 1)
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVikobaSwitcher() {
    return PopupMenuButton<Map<String, dynamic>>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConst.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.swap_horiz,
          color: AppConst.primary,
          size: 20,
        ),
      ),
      onSelected: _onVikobaChanged,
      itemBuilder: (context) {
        return _memberships.map((membership) {
          final isSelected =
              _selectedVikobaId == membership['membership_id'].toString();
          return PopupMenuItem<Map<String, dynamic>>(
            value: membership,
            child: Row(
              children: [
                Icon(
                  Icons.account_balance,
                  color: isSelected ? AppConst.primary : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        membership['vikoba_name'] ?? 'Vikoba',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? AppConst.primary : Colors.black87,
                        ),
                      ),
                      Text(
                        'Membership: ${membership['membership_number'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: AppConst.primary,
                    size: 16,
                  ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildQuickStats() {
    final data = _dashboardData;
    final totalSavings = data?['totalSavings'] ?? 0;
    final totalLoans = data?['totalLoans'] ?? 0;
    final totalShares = data?['totalShares'] ?? 0;
    final memberships = data?['memberships'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildStatCard(
                    'Total Savings',
                    _personalService.formatCurrency(totalSavings),
                    Icons.account_balance_wallet,
                    Colors.green)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildStatCard(
                    'Active Loans',
                    _personalService.formatCurrency(totalLoans),
                    Icons.credit_card,
                    Colors.orange)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildStatCard(
                    'Shares Value',
                    _personalService.formatCurrency(totalShares),
                    Icons.pie_chart,
                    Colors.blue)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildStatCard(
                    'Memberships',
                    memberships.length.toString(),
                    Icons.groups,
                    Colors.purple)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
            Expanded(
                child: _buildActionCard('Make Payment', Icons.payment, () {
              Navigator.pushNamed(context, RouteNames.loan);
            })),
            const SizedBox(width: 12),
            Expanded(
                child: _buildActionCard('Apply Loan', Icons.credit_card, () {
              Navigator.pushNamed(context, RouteNames.loanApplication);
            })),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildActionCard(
                    'View Savings', Icons.account_balance_wallet, () {
              Navigator.pushNamed(context, RouteNames.savings);
            })),
            const SizedBox(width: 12),
            Expanded(
                child: _buildActionCard('View Shares', Icons.pie_chart, () {
              Navigator.pushNamed(context, RouteNames.shares);
            })),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
                color: AppConst.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppConst.primary,
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

  Widget _buildRecentActivity() {
    final data = _dashboardData;
    final recentTransactions = data?['recentTransactions'] as List? ?? [];
    final upcomingPayments = data?['upcomingPayments'] as List? ?? [];
    final notifications = data?['notifications'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            children: [
              if (recentTransactions.isEmpty && notifications.isEmpty)
                _buildActivityItem('Welcome to Kikoba Management System',
                    'Just now', Icons.info_outline, Colors.blue)
              else ...[
                ...recentTransactions
                    .take(3)
                    .map((transaction) => _buildTransactionItem(transaction)),
                if (recentTransactions.isNotEmpty && notifications.isNotEmpty)
                  const Divider(height: 24),
                ...notifications.take(2).map(
                    (notification) => _buildNotificationItem(notification)),
              ],
              if (upcomingPayments.isNotEmpty) ...[
                const Divider(height: 24),
                const Text(
                  'Upcoming Payments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ...upcomingPayments
                    .take(2)
                    .map((payment) => _buildPaymentItem(payment)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      String title, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final type = transaction['type'] as String? ?? 'deposit';
    final amount = transaction['amount'] as dynamic ?? 0;
    final date = transaction['date'] as String? ?? '';
    final description = transaction['description'] as String? ?? 'Transaction';
    final vikobaName = transaction['vikoba_name'] as String? ?? '';

    IconData icon;
    Color color;
    String prefix = '';

    switch (type.toLowerCase()) {
      case 'deposit':
        icon = Icons.arrow_downward;
        color = Colors.green;
        prefix = '+';
        break;
      case 'withdrawal':
        icon = Icons.arrow_upward;
        color = Colors.red;
        prefix = '-';
        break;
      default:
        icon = Icons.swap_horiz;
        color = Colors.blue;
        prefix = '';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (vikobaName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    vikobaName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  _personalService.formatDateTime(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$prefix${_personalService.formatCurrency(amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final title = notification['title'] as String? ?? 'Notification';
    final message = notification['message'] as String? ?? '';
    final date = notification['created_at'] as String? ?? '';
    final isRead = notification['is_read'] as bool? ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isRead
                  ? Colors.grey.withOpacity(0.1)
                  : AppConst.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isRead ? Icons.notifications_none : Icons.notifications,
              color: isRead ? Colors.grey : AppConst.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                    color: isRead ? Colors.grey[600] : Colors.black87,
                  ),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  _personalService.formatDateTime(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(Map<String, dynamic> payment) {
    final dueDate = payment['due_date'] as String? ?? '';
    final amount = payment['expected_amount'] as dynamic ?? 0;
    final productName = payment['product_name'] as String? ?? '';

    final daysUntilDue = _getDaysUntilDue(dueDate);
    final isOverdue = daysUntilDue < 0;
    final isDueSoon = daysUntilDue <= 3 && daysUntilDue >= 0;

    Color color = Colors.blue;
    if (isOverdue) {
      color = Colors.red;
    } else if (isDueSoon) {
      color = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.payment,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Due: ${_personalService.formatDate(dueDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _personalService.formatCurrency(amount),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                isOverdue
                    ? 'Overdue ${daysUntilDue.abs()}d'
                    : isDueSoon
                        ? 'Due in $daysUntilDue days'
                        : 'Due in $daysUntilDue days',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getDaysUntilDue(String dateString) {
    if (dateString.isEmpty) return 0;
    try {
      final dueDate = DateTime.parse(dateString);
      final now = DateTime.now();
      return dueDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }
}
