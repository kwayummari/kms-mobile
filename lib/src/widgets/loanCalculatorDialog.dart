import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';

class LoanCalculatorDialog extends StatefulWidget {
  const LoanCalculatorDialog({super.key});

  @override
  State<LoanCalculatorDialog> createState() => _LoanCalculatorDialogState();
}

class LoanCalculatorPage extends StatefulWidget {
  const LoanCalculatorPage({super.key});

  @override
  State<LoanCalculatorPage> createState() => _LoanCalculatorPageState();
}

class _LoanCalculatorDialogState extends State<LoanCalculatorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _termController = TextEditingController();
  final _interestRateController = TextEditingController();

  double _monthlyPayment = 0.0;
  double _totalPayment = 0.0;
  double _totalInterest = 0.0;
  bool _isCalculated = false;

  @override
  void dispose() {
    _principalController.dispose();
    _termController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  void _calculateLoan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final principal = double.tryParse(_principalController.text) ?? 0;
    final termMonths = int.tryParse(_termController.text) ?? 1;
    final annualRate = double.tryParse(_interestRateController.text) ?? 0;

    if (principal <= 0 || termMonths <= 0 || annualRate < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid values'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Calculate monthly interest rate
    final monthlyRate = annualRate / 100 / 12;

    // Calculate monthly payment using loan formula
    double monthlyPayment;
    if (monthlyRate == 0) {
      // No interest case
      monthlyPayment = principal / termMonths;
    } else {
      // With interest
      monthlyPayment = principal *
          (monthlyRate * pow(1 + monthlyRate, termMonths)) /
          (pow(1 + monthlyRate, termMonths) - 1);
    }

    final totalPayment = monthlyPayment * termMonths;
    final totalInterest = totalPayment - principal;

    setState(() {
      _monthlyPayment = monthlyPayment;
      _totalPayment = totalPayment;
      _totalInterest = totalInterest;
      _isCalculated = true;
    });
  }

  void _resetCalculator() {
    setState(() {
      _principalController.clear();
      _termController.clear();
      _interestRateController.clear();
      _monthlyPayment = 0.0;
      _totalPayment = 0.0;
      _totalInterest = 0.0;
      _isCalculated = false;
    });
  }

  String _formatCurrency(double amount) {
    return 'TZS ${amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConst.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.calculate,
                          color: AppConst.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: const Text(
                        'Loan Calculator',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Form Fields
                TextFormField(
                  controller: _principalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Loan Amount (TZS)',
                    hintText: 'Enter loan amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon:
                        const Icon(Icons.monetization_on, color: Colors.green),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter loan amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _termController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Term (Months)',
                          hintText: 'e.g., 12',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.calendar_month,
                              color: Colors.blue),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter term';
                          }
                          final term = int.tryParse(value);
                          if (term == null || term <= 0) {
                            return 'Invalid term';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _interestRateController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Interest Rate (%)',
                          hintText: 'e.g., 12.0',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon:
                              const Icon(Icons.percent, color: Colors.orange),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter rate';
                          }
                          final rate = double.tryParse(value);
                          if (rate == null || rate < 0) {
                            return 'Invalid rate';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Calculate Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _calculateLoan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConst.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Calculate Loan',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Results
                if (_isCalculated) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppConst.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppConst.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loan Calculation Results',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConst.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultRow('Monthly Payment',
                            _formatCurrency(_monthlyPayment), Colors.green),
                        const SizedBox(height: 12),
                        _buildResultRow('Total Payment',
                            _formatCurrency(_totalPayment), Colors.blue),
                        const SizedBox(height: 12),
                        _buildResultRow('Total Interest',
                            _formatCurrency(_totalInterest), Colors.orange),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Breakdown:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  '• Principal: ${_formatCurrency(double.tryParse(_principalController.text) ?? 0)}'),
                              Text(
                                  '• Interest: ${_formatCurrency(_totalInterest)}'),
                              Text('• Term: ${_termController.text} months'),
                              Text(
                                  '• Rate: ${_interestRateController.text}% per annum'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reset Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _resetCalculator,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConst.primary,
                        side: BorderSide(color: AppConst.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Reset Calculator',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _LoanCalculatorPageState extends State<LoanCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _termController = TextEditingController();
  final _interestRateController = TextEditingController();

  double _monthlyPayment = 0.0;
  double _totalPayment = 0.0;
  double _totalInterest = 0.0;
  bool _isCalculated = false;

  @override
  void dispose() {
    _principalController.dispose();
    _termController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  void _calculateLoan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final principal = double.tryParse(_principalController.text) ?? 0;
    final termMonths = int.tryParse(_termController.text) ?? 1;
    final annualRate = double.tryParse(_interestRateController.text) ?? 0;

    if (principal <= 0 || termMonths <= 0 || annualRate < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid values'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Calculate monthly interest rate
    final monthlyRate = annualRate / 100 / 12;

    // Calculate monthly payment using loan formula
    double monthlyPayment;
    if (monthlyRate == 0) {
      // No interest case
      monthlyPayment = principal / termMonths;
    } else {
      // With interest
      monthlyPayment = principal *
          (monthlyRate * pow(1 + monthlyRate, termMonths)) /
          (pow(1 + monthlyRate, termMonths) - 1);
    }

    final totalPayment = monthlyPayment * termMonths;
    final totalInterest = totalPayment - principal;

    setState(() {
      _monthlyPayment = monthlyPayment;
      _totalPayment = totalPayment;
      _totalInterest = totalInterest;
      _isCalculated = true;
    });
  }

  void _resetCalculator() {
    setState(() {
      _principalController.clear();
      _termController.clear();
      _interestRateController.clear();
      _monthlyPayment = 0.0;
      _totalPayment = 0.0;
      _totalInterest = 0.0;
      _isCalculated = false;
    });
  }

  String _formatCurrency(double amount) {
    return 'TZS ${amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConst.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.calculate, color: AppConst.primary, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Loan Calculator',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConst.primary,
                      AppConst.primary.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppConst.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calculate Your Loan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your loan details to see monthly payments and total cost',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                      'Loan Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Loan Amount
                    TextFormField(
                      controller: _principalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Loan Amount (TZS)',
                        hintText: 'Enter loan amount (e.g., 1000000)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.monetization_on,
                            color: Colors.green),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter loan amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Term (Months)
                    TextFormField(
                      controller: _termController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Term (Months)',
                        hintText:
                            'Enter loan term in months (e.g., 12, 24, 36)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.calendar_month,
                            color: Colors.blue),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter loan term';
                        }
                        final term = int.tryParse(value);
                        if (term == null || term <= 0) {
                          return 'Please enter a valid term (positive number)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Interest Rate
                    TextFormField(
                      controller: _interestRateController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Interest Rate (%)',
                        hintText:
                            'Enter annual interest rate (e.g., 12.0, 15.5)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon:
                            const Icon(Icons.percent, color: Colors.orange),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter interest rate';
                        }
                        final rate = double.tryParse(value);
                        if (rate == null || rate < 0) {
                          return 'Please enter a valid interest rate (0 or positive number)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Calculate Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateLoan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConst.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Calculate Loan',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Results
              if (_isCalculated) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppConst.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.calculate,
                                color: AppConst.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Calculation Results',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppConst.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildResultRow('Monthly Pay',
                          _formatCurrency(_monthlyPayment), Colors.green),
                      const SizedBox(height: 16),
                      _buildResultRow('Total Payment',
                          _formatCurrency(_totalPayment), Colors.blue),
                      const SizedBox(height: 16),
                      _buildResultRow('Total Interest',
                          _formatCurrency(_totalInterest), Colors.orange),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Breakdown:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildBreakdownRow(
                                'Principal',
                                _formatCurrency(double.tryParse(
                                        _principalController.text) ??
                                    0)),
                            _buildBreakdownRow(
                                'Interest', _formatCurrency(_totalInterest)),
                            _buildBreakdownRow(
                                'Term', '${_termController.text} months'),
                            _buildBreakdownRow('Rate',
                                '${_interestRateController.text}% per annum'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Reset Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _resetCalculator,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConst.primary,
                      side: BorderSide(color: AppConst.primary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reset Calculator',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
