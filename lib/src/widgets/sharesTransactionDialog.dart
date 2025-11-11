import 'package:flutter/material.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/gateway/personal-services.dart';

class SharesTransactionDialog extends StatefulWidget {
  final Map<String, dynamic> shareData;
  final String transactionType; // 'buy' or 'sell'

  const SharesTransactionDialog({
    super.key,
    required this.shareData,
    required this.transactionType,
  });

  @override
  State<SharesTransactionDialog> createState() =>
      _SharesTransactionDialogState();
}

class _SharesTransactionDialogState extends State<SharesTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _sharesQuantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final PersonalService _personalService = PersonalService();
  bool _isLoading = false;

  double get shareValuePerUnit =>
      double.tryParse(
          widget.shareData['share_value_per_unit']?.toString() ?? '0') ??
      0;

  int get currentSharesOwned =>
      int.tryParse(widget.shareData['shares_owned']?.toString() ?? '0') ?? 0;

  @override
  void dispose() {
    _sharesQuantityController.dispose();
    _descriptionController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  double get calculatedAmount {
    final quantity = int.tryParse(_sharesQuantityController.text) ?? 0;
    return quantity * shareValuePerUnit;
  }

  Future<void> _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final quantity = int.parse(_sharesQuantityController.text);
      final description = _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : '${widget.transactionType.toUpperCase()} ${quantity} shares';

      bool success;
      String message;

      if (widget.transactionType == 'buy') {
        success = await _personalService.buySharesViaUSSD(
          context,
          membershipId: widget.shareData['membership_id'],
          sharesQuantity: quantity,
          description: description,
          phoneNumber: _phoneNumberController.text,
        );
        message = success
            ? 'USSD payment initiated for share purchase. Check your phone for payment prompt.'
            : 'Failed to initiate share purchase. Please try again.';
      } else {
        success = await _personalService.sellSharesRequest(
          context,
          membershipId: widget.shareData['membership_id'],
          sharesQuantity: quantity,
          description: description,
        );
        message = success
            ? 'Sell shares request submitted successfully. Waiting for approval.'
            : 'Failed to submit sell shares request. Please try again.';
      }

      if (success) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBuy = widget.transactionType == 'buy';
    final buttonText = isBuy ? 'Buy via USSD' : 'Request Sale';
    final buttonColor = isBuy ? Colors.green : Colors.orange;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      isBuy ? Icons.shopping_cart : Icons.sell,
                      color: buttonColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${isBuy ? 'Buy' : 'Sell'} Shares',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Share Info Card
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
                      Text(
                        widget.shareData['vikoba_name'] ?? 'Unknown Vikoba',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Shares:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${currentSharesOwned} shares',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price per Share:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _personalService.formatCurrency(shareValuePerUnit),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppConst.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Shares Quantity Input
                TextFormField(
                  controller: _sharesQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of Shares',
                    hintText: 'Enter quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of shares';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Please enter a valid number';
                    }
                    if (!isBuy && quantity > currentSharesOwned) {
                      return 'Cannot sell more shares than you own';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {}); // Trigger rebuild to update amount
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number Input (for USSD payments)
                if (widget.transactionType == 'buy')
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter phone number for USSD payment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: widget.transactionType == 'buy'
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required for USSD payment';
                            }
                            if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          }
                        : null,
                  ),
                if (widget.transactionType == 'buy') const SizedBox(height: 16),

                // Description Input
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Add a note about this transaction',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),

                // Amount Calculation
                if (_sharesQuantityController.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppConst.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppConst.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          _personalService.formatCurrency(calculatedAmount),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConst.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // Info Card for Sell Requests
                if (!isBuy)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.orange[700], size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Sell requests require approval from your Vikoba administrators.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
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
