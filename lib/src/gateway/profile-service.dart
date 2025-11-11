import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kms/src/api/apis.dart';

class ProfileService {
  Api api = Api();

  /// Get user profile by ID
  Future profile(BuildContext context, String id) async {
    Map<String, dynamic> data = {
      'id': id.toString(),
    };
    final response = await api.post(context, 'getUserById', data);
    final datas = jsonDecode(response.body);
    return datas;
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile(
    BuildContext context, {
    required String fullName,
    required String email,
    required String phone,
  }) async {
    try {
      Map<String, dynamic> data = {
        'full_name': fullName,
        'email': email,
        'phone': phone,
      };

      final response = await api.put('auth/profile', data);
      return response;
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  /// Change user password
  Future<Map<String, dynamic>> changePassword(
    BuildContext context, {
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      Map<String, dynamic> data = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };

      final response = await api.post(context, 'auth/change-password', data);
      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }
}
