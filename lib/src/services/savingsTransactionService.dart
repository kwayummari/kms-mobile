import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kms/src/api/apis.dart';
import 'package:intl/intl.dart';

class SavingsTransactionService {
  final Api _api = Api();

  /// Format currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_TZ',
      symbol: 'TZS ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Make a deposit to savings account via USSD
  Future<Map<String, dynamic>?> makeDepositViaUSSD(
    BuildContext context, {
    required int accountId,
    required double amount,
    required String phoneNumber,
    String? description,
  }) async {
    try {
      final data = {
        'account_id': accountId,
        'amount': amount,
        'phone_number': phoneNumber,
        'transaction_type': 'deposit',
        'description': description ?? 'Savings Deposit',
      };

      // Call the KMS backend which will integrate with Daladala Smart backend
      final response = await _api.post(context, 'savings/deposit-ussd', data);
      if (response != null && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
      return null;
    } catch (e) {
      print('Error making USSD deposit: $e');
      return null;
    }
  }

  /// Make a deposit to savings account (legacy method for non-USSD)
  Future<Map<String, dynamic>?> makeDeposit(
    BuildContext context, {
    required int accountId,
    required double amount,
    String? description,
  }) async {
    try {
      final data = {
        'account_id': accountId,
        'amount': amount,
        'transaction_type': 'deposit',
        'description': description ?? 'Deposit',
      };

      final response = await _api.post(context, 'savings/transactions', data);
      if (response != null && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
      return null;
    } catch (e) {
      print('Error making deposit: $e');
      return null;
    }
  }

  /// Make a withdrawal request from savings account
  Future<Map<String, dynamic>?> makeWithdrawalRequest(
    BuildContext context, {
    required int accountId,
    required double amount,
    String? description,
  }) async {
    try {
      final data = {
        'account_id': accountId,
        'amount': amount,
        'transaction_type': 'withdrawal_request',
        'description': description ?? 'Withdrawal Request',
      };

      final response =
          await _api.post(context, 'savings/withdrawal-request', data);
      if (response != null && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
      return null;
    } catch (e) {
      print('Error making withdrawal request: $e');
      return null;
    }
  }

  /// Make a withdrawal from savings account (legacy method for admin use)
  Future<Map<String, dynamic>?> makeWithdrawal(
    BuildContext context, {
    required int accountId,
    required double amount,
    String? description,
  }) async {
    try {
      final data = {
        'account_id': accountId,
        'amount': amount,
        'transaction_type': 'withdrawal',
        'description': description ?? 'Withdrawal',
      };

      final response = await _api.post(context, 'savings/transactions', data);
      if (response != null && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
      return null;
    } catch (e) {
      print('Error making withdrawal: $e');
      return null;
    }
  }

  /// Get transaction history for a savings account
  Future<List<dynamic>?> getTransactionHistory(
    BuildContext context, {
    required int accountId,
  }) async {
    try {
      final response =
          await _api.get(context, 'savings/transactions/account/$accountId');
      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching transaction history: $e');
      return null;
    }
  }

  /// Validate transaction amount
  Map<String, String> validateTransaction({
    required double amount,
    required double currentBalance,
    required String transactionType,
  }) {
    Map<String, String> errors = {};

    if (amount <= 0) {
      errors['amount'] = 'Amount must be greater than 0';
    }

    if (transactionType == 'withdrawal' && amount > currentBalance) {
      errors['amount'] =
          'Insufficient balance. Available: ${formatCurrency(currentBalance)}';
    }

    if (amount < 1000) {
      errors['amount'] =
          'Minimum transaction amount is ${formatCurrency(1000)}';
    }

    if (amount > 10000000) {
      errors['amount'] =
          'Maximum transaction amount is ${formatCurrency(10000000)}';
    }

    return errors;
  }
}
