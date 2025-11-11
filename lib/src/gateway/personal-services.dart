import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:kms/src/api/apis.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PersonalService {
  final Api api = Api();

  /// Get personal dashboard data
  Future<Map<String, dynamic>?> getDashboardData(BuildContext context,
      {String? membershipId}) async {
    try {
      String endpoint = 'personal/dashboard';
      if (membershipId != null && membershipId.isNotEmpty) {
        endpoint += '?membership_id=$membershipId';
      }

      final response = await api.get(context, endpoint);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'];
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Failed to fetch dashboard data',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print('Dashboard data error: $e');
      Fluttertoast.showToast(
        msg: 'Network error. Please check your connection.',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  /// Get personal savings data
  Future<List<dynamic>?> getSavingsData(BuildContext context) async {
    try {
      final response = await api.get(context, 'personal/savings');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'];
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Failed to fetch savings data',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print('Savings data error: $e');
      Fluttertoast.showToast(
        msg: 'Network error. Please check your connection.',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  /// Get personal loans data
  Future<List<dynamic>?> getLoansData(BuildContext context) async {
    try {
      final response = await api.get(context, 'personal/loans');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'];
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Failed to fetch loans data',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print('Loans data error: $e');
      Fluttertoast.showToast(
        msg: 'Network error. Please check your connection.',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  /// Get personal shares data
  Future<List<dynamic>?> getSharesData(BuildContext context) async {
    try {
      final response = await api.get(context, 'personal/shares');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['data'];
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Failed to fetch shares data',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print('Shares data error: $e');
      Fluttertoast.showToast(
        msg: 'Network error. Please check your connection.',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  /// Format currency amount
  String formatCurrency(dynamic amount) {
    if (amount == null) return 'TZS 0.00';
    final num = double.tryParse(amount.toString()) ?? 0.0;
    return 'TZS ${num.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  /// Format date
  String formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  /// Get withdrawal requests for user
  Future<List<dynamic>?> getWithdrawalRequests(BuildContext context) async {
    try {
      print('Fetching withdrawal requests...');
      final response = await api.get(context, 'personal/withdrawal-requests');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print(
            'Withdrawal requests fetched successfully: ${responseData['data']}');
        return responseData['data'];
      } else {
        print('API error: ${responseData['message']}');
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Failed to fetch withdrawal requests',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print('Withdrawal requests error: $e');
      Fluttertoast.showToast(
        msg: 'Network error: $e',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  /// Format date with time
  String formatDateTime(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  /// Buy shares via USSD payment
  Future<bool> buySharesViaUSSD(
    BuildContext context, {
    required int membershipId,
    required int sharesQuantity,
    String? description,
    required String phoneNumber,
  }) async {
    try {
      final response = await api.post(context, 'savings/buy-shares', {
        'membership_id': membershipId,
        'shares_quantity': sharesQuantity,
        'description': description,
        'phone_number': phoneNumber,
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Shares purchase initiated successfully');
        return true;
      } else {
        print('Shares purchase failed: ${responseData['message']}');
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Failed to initiate share purchase',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Shares purchase error: $e');
      Fluttertoast.showToast(
        msg: 'Network error. Please check your connection.',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  /// Create sell shares request
  Future<bool> sellSharesRequest(
    BuildContext context, {
    required int membershipId,
    required int sharesQuantity,
    String? description,
  }) async {
    try {
      final response = await api.post(context, 'savings/sell-shares-request', {
        'membership_id': membershipId,
        'shares_quantity': sharesQuantity,
        'description': description,
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Sell shares request submitted successfully');
        return true;
      } else {
        print('Sell shares request failed: ${responseData['message']}');
        Fluttertoast.showToast(
          msg:
              responseData['message'] ?? 'Failed to submit sell shares request',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Sell shares request error: $e');
      Fluttertoast.showToast(
        msg: 'Network error. Please check your connection.',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
}
