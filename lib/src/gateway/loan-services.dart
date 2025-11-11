import 'package:kms/src/api/apis.dart';
import 'package:kms/src/gateway/personal-services.dart';
import 'package:flutter/material.dart';

class loanService {
  Api api = Api();
  final PersonalService _personalService = PersonalService();

  // Get personal loans data using the new API
  Future<Map<String, dynamic>?> getPersonalLoans(BuildContext context) async {
    try {
      final loansData = await _personalService.getLoansData(context);
      return {
        'success': true,
        'data': loansData ?? [],
        'count': loansData?.length ?? 0
      };
    } catch (e) {
      print('Error fetching loans: $e');
      return {
        'success': false,
        'data': [],
        'count': 0,
        'message': 'Failed to fetch loans data'
      };
    }
  }

  // Legacy method for backward compatibility
  Future loans(BuildContext context, String id) async {
    return await getPersonalLoans(context);
  }
}
