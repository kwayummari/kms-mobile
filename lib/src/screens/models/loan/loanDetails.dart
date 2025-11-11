import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/gateway/personal-services.dart';
import 'package:intl/intl.dart';

class LoanDetails extends StatefulWidget {
  final Map<String, dynamic> loan;

  const LoanDetails({super.key, required this.loan});

  @override
  State<LoanDetails> createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
  final PersonalService _personalService = PersonalService();
  List<dynamic> _repayments = [];
  bool _isLoadingRepayments = true;

  @override
  void initState() {
    super.initState();
    _loadRepayments();
  }

  Future<void> _loadRepayments() async {
    setState(() => _isLoadingRepayments = true);
    try {
      // TODO: Implement repayment fetching when API is available
      // final repayments = await _personalService.getLoanRepayments(context, widget.loan['loan_id']);
      setState(() {
        _repayments = []; // Placeholder for now
        _isLoadingRepayments = false;
      });
    } catch (e) {
      setState(() {
        _repayments = [];
        _isLoadingRepayments = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;
    final totalAmount =
        double.tryParse(loan['total_amount']?.toString() ?? '0') ?? 0;
    final principalAmount =
        double.tryParse(loan['principal_amount']?.toString() ?? '0') ?? 0;
    final interestAmount =
        double.tryParse(loan['interest_amount']?.toString() ?? '0') ?? 0;
    final processingFee =
        double.tryParse(loan['processing_fee']?.toString() ?? '0') ?? 0;
    final status = loan['status'] as String? ?? '';
    final productName = loan['product_name'] as String? ?? 'Loan';
    final vikobaName = loan['vikoba_name'] as String? ?? '';
    final termMonths = loan['term_months'] as int? ?? 0;
    final interestRate =
        double.tryParse(loan['interest_rate']?.toString() ?? '0') ?? 0;
    final applicationDate = loan['application_date'] != null
        ? DateTime.tryParse(loan['application_date'].toString())
        : null;
    final expectedEndDate = loan['expected_end_date'] != null
        ? DateTime.tryParse(loan['expected_end_date'].toString())
        : null;

    Color statusColor = Colors.blue;
    if (status == 'active') {
      statusColor = Colors.green;
    } else if (status == 'overdue') {
      statusColor = Colors.red;
    } else if (status == 'pending') {
      statusColor = Colors.orange;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Loan Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loan Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
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
                  const SizedBox(height: 16),
                  Text(
                    _personalService.formatCurrency(totalAmount),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (vikobaName.isNotEmpty) ...[
                    _buildInfoRow('Vikoba', vikobaName),
                    const SizedBox(height: 12),
                  ],
                  _buildInfoRow('Term', '$termMonths months'),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                      'Interest Rate', '${interestRate.toStringAsFixed(1)}%'),
                  if (applicationDate != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow('Application Date',
                        DateFormat('MMM dd, yyyy').format(applicationDate)),
                  ],
                  if (expectedEndDate != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow('Expected End Date',
                        DateFormat('MMM dd, yyyy').format(expectedEndDate)),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Loan Breakdown Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                  const Text(
                    'Loan Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBreakdownRow('Principal Amount',
                      _personalService.formatCurrency(principalAmount)),
                  const SizedBox(height: 12),
                  _buildBreakdownRow('Interest Amount',
                      _personalService.formatCurrency(interestAmount)),
                  if (processingFee > 0) ...[
                    const SizedBox(height: 12),
                    _buildBreakdownRow('Processing Fee',
                        _personalService.formatCurrency(processingFee)),
                  ],
                  const Divider(height: 24),
                  _buildBreakdownRow('Total Amount',
                      _personalService.formatCurrency(totalAmount),
                      isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Repayments Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                      const Text(
                        'Repayment History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (_isLoadingRepayments)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_repayments.isEmpty && !_isLoadingRepayments)
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No repayments yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Repayment history will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._repayments
                        .map((repayment) => _buildRepaymentItem(repayment)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black87 : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppConst.primary : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRepaymentItem(Map<String, dynamic> repayment) {
    final amount = double.tryParse(repayment['amount']?.toString() ?? '0') ?? 0;
    final date = repayment['payment_date'] != null
        ? DateTime.tryParse(repayment['payment_date'].toString())
        : null;
    final status = repayment['status'] as String? ?? '';

    Color statusColor = Colors.green;
    if (status == 'pending') {
      statusColor = Colors.orange;
    } else if (status == 'failed') {
      statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _personalService.formatCurrency(amount),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (date != null)
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
