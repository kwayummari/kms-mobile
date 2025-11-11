import 'dart:convert';
import 'package:kms/src/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanApplicationService {
  final Api _api = Api();

  /// Get borrowing capacity for a specific membership
  Future<Map<String, dynamic>?> getBorrowingCapacity(
      BuildContext context, int membershipId) async {
    try {
      final response =
          await _api.get(context, 'personal/borrowing-capacity/$membershipId');
      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching borrowing capacity: $e');
      return null;
    }
  }

  /// Get available loan products for a vikoba
  Future<List<dynamic>?> getLoanProducts(
      BuildContext context, int vikobaId) async {
    try {
      final response =
          await _api.get(context, 'loans/products/vikoba/$vikobaId');
      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching loan products: $e');
      return null;
    }
  }

  /// Submit loan application
  Future<Map<String, dynamic>?> submitLoanApplication(
    BuildContext context, {
    required int membershipId,
    required int productId,
    required double principalAmount,
    required int termMonths,
    String? purpose,
  }) async {
    try {
      final data = {
        'membership_id': membershipId,
        'product_id': productId,
        'principal_amount': principalAmount,
        'term_months': termMonths,
        if (purpose != null && purpose.isNotEmpty) 'purpose': purpose,
      };

      final response = await _api.post(context, 'personal/apply-loan', data);
      if (response != null && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
      return null;
    } catch (e) {
      print('Error submitting loan application: $e');
      return null;
    }
  }

  /// Format currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_TZ',
      symbol: 'TZS ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format percentage
  String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Calculate loan details (interest, total amount, etc.)
  Map<String, double> calculateLoanDetails({
    required double principalAmount,
    required double interestRate,
    required int termMonths,
    double processingFee = 0.0,
  }) {
    // Calculate interest (assuming flat rate)
    final interestAmount = (principalAmount * interestRate / 100) * termMonths;

    // Calculate total amount
    final totalAmount = principalAmount + interestAmount + processingFee;

    // Calculate monthly payment
    final monthlyPayment = totalAmount / termMonths;

    return {
      'interest_amount': interestAmount,
      'total_amount': totalAmount,
      'monthly_payment': monthlyPayment,
      'processing_fee': processingFee,
    };
  }

  /// Validate loan application data
  Map<String, String> validateLoanApplication({
    required int membershipId,
    required int productId,
    required double principalAmount,
    required int termMonths,
    required double minAmount,
    required double maxAmount,
    required int minTerm,
    required int maxTerm,
  }) {
    Map<String, String> errors = {};

    if (membershipId <= 0) {
      errors['membership_id'] = 'Please select a valid membership';
    }

    if (productId <= 0) {
      errors['product_id'] = 'Please select a loan product';
    }

    if (principalAmount <= 0) {
      errors['principal_amount'] = 'Principal amount must be greater than 0';
    } else if (principalAmount < minAmount) {
      errors['principal_amount'] =
          'Amount must be at least ${formatCurrency(minAmount)}';
    } else if (principalAmount > maxAmount) {
      errors['principal_amount'] =
          'Amount cannot exceed ${formatCurrency(maxAmount)}';
    }

    if (termMonths <= 0) {
      errors['term_months'] = 'Term must be at least 1 month';
    } else if (termMonths < minTerm) {
      errors['term_months'] = 'Term must be at least $minTerm months';
    } else if (termMonths > maxTerm) {
      errors['term_months'] = 'Term cannot exceed $maxTerm months';
    }

    return errors;
  }
}
