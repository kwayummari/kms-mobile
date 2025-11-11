import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/gateway/loan-application-services.dart';
import 'package:kms/src/gateway/personal-services.dart';

class LoanApplication extends StatefulWidget {
  const LoanApplication({super.key});

  @override
  State<LoanApplication> createState() => _LoanApplicationState();
}

class _LoanApplicationState extends State<LoanApplication> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Services
  final LoanApplicationService _loanService = LoanApplicationService();
  final PersonalService _personalService = PersonalService();

  // Form data
  Map<String, dynamic>? _borrowingCapacityData;
  List<dynamic> _loanProducts = [];
  Map<String, dynamic>? _selectedMembership;
  Map<String, dynamic>? _selectedProduct;
  double _principalAmount = 0.0;
  int _termMonths = 1;
  String _purpose = '';

  // Form controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _termController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBorrowingCapacity();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _loadBorrowingCapacity() async {
    setState(() => _isLoading = true);

    try {
      // Get user's memberships first
      final dashboardData = await _personalService.getDashboardData(context);
      if (dashboardData != null && dashboardData['memberships'] != null) {
        final memberships = dashboardData['memberships'] as List<dynamic>;
        if (memberships.isNotEmpty) {
          // Use the first membership for now (user can select later)
          final membership = memberships.first;
          final membershipId = membership['membership_id'] as int;

          final capacityData =
              await _loanService.getBorrowingCapacity(context, membershipId);
          if (capacityData != null) {
            setState(() {
              _borrowingCapacityData = capacityData;
              _selectedMembership = capacityData['membership'];
              _loanProducts = capacityData['available_products'] ?? [];
            });
          }
        }
      }
    } catch (e) {
      print('Error loading borrowing capacity: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _nextStep(int currentStep) {
    if (currentStep < steps.length - 1) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _previousStep(int currentStep) {
    if (currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _stepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  // Helper method to safely convert to double
  double _safeToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Future<void> _submitApplication() async {
    if (_selectedMembership == null || _selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _loanService.submitLoanApplication(
        context,
        membershipId: _selectedMembership!['membership_id'],
        productId: _selectedProduct!['product_id'],
        principalAmount: _principalAmount,
        termMonths: _termMonths,
        purpose: _purpose.isNotEmpty ? _purpose : null,
      );

      if (result != null && result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Loan application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['message'] ?? 'Failed to submit application'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error submitting application'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Step> get steps => [
        Step(
          title: const Text('Borrowing Capacity'),
          content: _buildBorrowingCapacityStep(),
          isActive: _currentStep == 0,
        ),
        Step(
          title: const Text('Select Product'),
          content: _buildProductSelectionStep(),
          isActive: _currentStep == 1,
        ),
        Step(
          title: const Text('Loan Details'),
          content: _buildLoanDetailsStep(),
          isActive: _currentStep == 2,
        ),
        Step(
          title: const Text('Review & Submit'),
          content: _buildReviewStep(),
          isActive: _currentStep == 3,
        ),
      ];

  Widget _buildBorrowingCapacityStep() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_borrowingCapacityData == null) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Unable to load borrowing capacity'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBorrowingCapacity,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final savingsAndShares = _borrowingCapacityData!['savings_and_shares'];
    final borrowingCapacity = _borrowingCapacityData!['borrowing_capacity'];
    final activeLoans =
        _borrowingCapacityData!['active_loans'] as List<dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Membership Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Vikoba',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConst.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedMembership?['vikoba_name'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Membership: ${_selectedMembership?['membership_number'] ?? 'N/A'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Savings and Shares Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Savings & Shares',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConst.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('Total Savings:'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          _loanService.formatCurrency(
                              _safeToDouble(savingsAndShares['total_savings'])),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('Total Shares Quantity:'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${savingsAndShares['total_shares_quantity'] ?? 0} shares',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('Total Shares Value:'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          _loanService.formatCurrency(_safeToDouble(
                              savingsAndShares['total_shares_value'])),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Combined Total:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _loanService.formatCurrency(
                            _safeToDouble(savingsAndShares['combined_total'])),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppConst.primary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Borrowing Capacity
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Borrowing Capacity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConst.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'You can borrow up to:',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _loanService.formatCurrency(_safeToDouble(
                              borrowingCapacity['available_capacity'])),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Based on ${borrowingCapacity['multiplier_used']}x your savings & shares',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (activeLoans.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Active Loans (${activeLoans.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...activeLoans.map((loan) => ListTile(
                          title: Text(_loanService.formatCurrency(
                              _safeToDouble(loan['principal_amount']))),
                          subtitle: Text('Status: ${loan['status']}'),
                          trailing: Text(_loanService.formatCurrency(
                              _safeToDouble(loan['total_amount']))),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSelectionStep() {
    if (_loanProducts.isEmpty) {
      return const Center(
        child: Text('No loan products available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Loan Product',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConst.primary,
            ),
          ),
          const SizedBox(height: 16),
          ..._loanProducts.map((product) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: RadioListTile<Map<String, dynamic>>(
                  title: Text(
                    product['product_name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Interest Rate: ${_loanService.formatPercentage(_safeToDouble(product['interest_rate']))}'),
                      Text(
                          'Term Range: ${product['minimum_term']} - ${product['maximum_term']} months'),
                      Text(
                          'Amount Range: ${_loanService.formatCurrency(_safeToDouble(product['minimum_amount']))} - ${_loanService.formatCurrency(_safeToDouble(product['maximum_amount']))}'),
                    ],
                  ),
                  value: product,
                  groupValue: _selectedProduct,
                  onChanged: (value) {
                    setState(() {
                      _selectedProduct = value;
                      _termController.text =
                          product['recommended_term'].toString();
                    });
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildLoanDetailsStep() {
    if (_selectedProduct == null) {
      return const Center(
        child: Text('Please select a loan product first'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConst.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Amount Input
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Loan Amount (TZS)',
              hintText: 'Enter amount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              helperText:
                  'Range: ${_loanService.formatCurrency(_safeToDouble(_selectedProduct!['minimum_amount']))} - ${_loanService.formatCurrency(_safeToDouble(_selectedProduct!['maximum_amount']))}',
            ),
            onChanged: (value) {
              _principalAmount = double.tryParse(value) ?? 0.0;
            },
          ),

          const SizedBox(height: 24),

          // Term Input
          TextFormField(
            controller: _termController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Term (Months)',
              hintText: 'Enter term in months',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              helperText:
                  'Range: ${_selectedProduct!['minimum_term']} - ${_selectedProduct!['maximum_term']} months',
            ),
            onChanged: (value) {
              _termMonths = int.tryParse(value) ?? 1;
            },
          ),

          const SizedBox(height: 24),

          // Purpose Input
          TextFormField(
            controller: _purposeController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Loan Purpose (Optional)',
              hintText: 'Describe what you need the loan for...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              _purpose = value;
            },
          ),

          const SizedBox(height: 24),

          // Loan Calculation Preview
          if (_principalAmount > 0 && _termMonths > 0) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConst.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildLoanCalculation(),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildLoanCalculation() {
    final calculation = _loanService.calculateLoanDetails(
      principalAmount: _principalAmount,
      interestRate: _safeToDouble(_selectedProduct!['interest_rate']),
      termMonths: _termMonths,
    );

    return [
      _buildCalculationRow(
          'Principal Amount', _loanService.formatCurrency(_principalAmount)),
      _buildCalculationRow(
          'Interest Rate',
          _loanService.formatPercentage(
              _safeToDouble(_selectedProduct!['interest_rate']))),
      _buildCalculationRow('Term', '$_termMonths months'),
      _buildCalculationRow(
          'Interest Amount',
          _loanService
              .formatCurrency(_safeToDouble(calculation['interest_amount']))),
      _buildCalculationRow(
          'Total Amount',
          _loanService
              .formatCurrency(_safeToDouble(calculation['total_amount'])),
          isTotal: true),
      _buildCalculationRow(
          'Monthly Payment',
          _loanService
              .formatCurrency(_safeToDouble(calculation['monthly_payment'])),
          isTotal: true),
    ];
  }

  Widget _buildCalculationRow(String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppConst.primary : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppConst.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    if (_selectedProduct == null) {
      return const Center(
        child: Text('Please complete all previous steps'),
      );
    }

    final calculation = _loanService.calculateLoanDetails(
      principalAmount: _principalAmount,
      interestRate: _safeToDouble(_selectedProduct!['interest_rate']),
      termMonths: _termMonths,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Application',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConst.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Application Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application Summary',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCalculationRow(
                      'Vikoba', _selectedMembership?['vikoba_name'] ?? 'N/A'),
                  _buildCalculationRow(
                      'Product', _selectedProduct!['product_name']),
                  _buildCalculationRow(
                      'Amount', _loanService.formatCurrency(_principalAmount)),
                  _buildCalculationRow('Term', '$_termMonths months'),
                  if (_purpose.isNotEmpty)
                    _buildCalculationRow('Purpose', _purpose),
                  const Divider(),
                  _buildCalculationRow(
                      'Interest Rate',
                      _loanService.formatPercentage(
                          _safeToDouble(_selectedProduct!['interest_rate']))),
                  _buildCalculationRow(
                      'Interest Amount',
                      _loanService.formatCurrency(
                          _safeToDouble(calculation['interest_amount']))),
                  _buildCalculationRow(
                      'Total Amount',
                      _loanService.formatCurrency(
                          _safeToDouble(calculation['total_amount'])),
                      isTotal: true),
                  _buildCalculationRow(
                      'Monthly Payment',
                      _loanService.formatCurrency(
                          _safeToDouble(calculation['monthly_payment'])),
                      isTotal: true),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitApplication,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConst.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Submit Application',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Apply for Loan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading && _borrowingCapacityData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Stepper(
                    currentStep: _currentStep,
                    onStepContinue: _currentStep < steps.length - 1
                        ? () => _nextStep(_currentStep)
                        : null,
                    onStepCancel: _currentStep > 0
                        ? () => _previousStep(_currentStep)
                        : null,
                    onStepTapped: _stepTapped,
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            if (details.stepIndex > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: details.onStepCancel,
                                  child: const Text('Previous'),
                                ),
                              ),
                            if (details.stepIndex > 0)
                              const SizedBox(width: 16),
                            if (details.stepIndex < steps.length - 1)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConst.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Next'),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    steps: steps,
                  ),
                ),
              ],
            ),
    );
  }
}
