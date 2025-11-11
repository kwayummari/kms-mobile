import 'package:flutter/material.dart';
import 'package:kms/src/services/savingsTransactionService.dart';
import 'package:kms/src/utils/app_const.dart';

class SavingsTransactionDialog extends StatefulWidget {
  final Map<String, dynamic> account;
  final String transactionType; // 'deposit' or 'withdrawal'

  const SavingsTransactionDialog({
    super.key,
    required this.account,
    required this.transactionType,
  });

  @override
  State<SavingsTransactionDialog> createState() =>
      _SavingsTransactionDialogState();
}

class _SavingsTransactionDialogState extends State<SavingsTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final SavingsTransactionService _transactionService =
      SavingsTransactionService();

  bool _isLoading = false;
  String? _amountError;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text.trim();
      final accountId = widget.account['account_id'] as int;

      Map<String, dynamic>? result;

      if (widget.transactionType == 'deposit') {
        result = await _transactionService.makeDeposit(
          context,
          accountId: accountId,
          amount: amount,
          description: description.isEmpty ? null : description,
        );
      } else {
        result = await _transactionService.makeWithdrawalRequest(
          context,
          accountId: accountId,
          amount: amount,
          description: description.isEmpty ? null : description,
        );
      }

      setState(() => _isLoading = false);

      if (result != null && result['success'] == true) {
        if (mounted) {
          Navigator.of(context).pop(true); // Return true to indicate success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.transactionType == 'deposit'
                  ? 'Deposit successful!'
                  : 'Withdrawal request submitted successfully!'),
              backgroundColor: widget.transactionType == 'deposit'
                  ? Colors.green
                  : Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.transactionType == 'deposit'
                  ? 'Deposit failed. Please try again.'
                  : 'Withdrawal request failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountName =
        widget.account['account_name'] as String? ?? 'Savings Account';
    final currentBalance =
        double.tryParse(widget.account['balance']?.toString() ?? '0') ?? 0;
    final isWithdrawal = widget.transactionType == 'withdrawal';
    final title = isWithdrawal ? 'Withdraw from' : 'Deposit to';
    final buttonText = isWithdrawal ? 'Request' : 'Deposit';
    final buttonColor = isWithdrawal ? AppConst.primary : Colors.green;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                        color: buttonColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isWithdrawal
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: buttonColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$title $accountName',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Current Balance: ${_transactionService.formatCurrency(currentBalance)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: Colors.grey[600],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Amount Input
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (TZS)',
                    hintText: 'Enter amount',
                    prefixText: 'TZS ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: _amountError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }

                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Please enter a valid amount';
                    }

                    // Validate amount based on transaction type
                    final errors = _transactionService.validateTransaction(
                      amount: amount,
                      currentBalance: currentBalance,
                      transactionType: widget.transactionType,
                    );

                    if (errors.containsKey('amount')) {
                      return errors['amount'];
                    }

                    return null;
                  },
                  onChanged: (value) {
                    setState(() => _amountError = null);
                  },
                ),

                const SizedBox(height: 16),

                // Information card for withdrawal requests
                if (isWithdrawal)
                  Card(
                    color: Colors.orange.shade50,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Withdrawal requests require approval from your Vikoba administrators.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Description Input
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 2,
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(buttonText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
