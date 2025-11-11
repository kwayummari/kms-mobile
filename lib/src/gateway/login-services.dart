import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/apis.dart';
import '../provider/login-provider.dart';
import '../utils/routes/route-names.dart';
import '../widgets/app_snackbar.dart';

class loginService {
  final Api api = Api();

  Future<void> login(
      BuildContext context, String username, String password) async {
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);

    try {
      Map<String, dynamic> data = {
        'username': username,
        'password': password,
      };

      final response = await api.post(context, 'auth/login', data);
      final newResponse = jsonDecode(response.body);
      print('Login response: $newResponse');

      if (response.statusCode == 200 && newResponse['success'] == true) {
        myProvider.updateLoging(!myProvider.myLoging);

        AppSnackbar(
          isError: false,
          response: newResponse['message'] ?? 'Login successful',
        ).show(context);

        // Save user data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('token', newResponse['token']);
        await prefs.setString('id', newResponse['data']['user_id'].toString());
        await prefs.setString('full_name', newResponse['data']['full_name']);
        await prefs.setString('email', newResponse['data']['email'] ?? '');
        await prefs.setString('phone', newResponse['data']['phone']);

        // Save role information if available
        if (newResponse['data']['roles'] != null &&
            newResponse['data']['roles'].isNotEmpty) {
          await prefs.setString(
              'role_id', newResponse['data']['roles'][0]['role_id'].toString());
          await prefs.setString(
              'role_name', newResponse['data']['roles'][0]['role_name']);
        }

        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.bottomNavigationBar,
          (_) => false,
        );
      } else {
        myProvider.updateLoging(!myProvider.myLoging);
        AppSnackbar(
          isError: true,
          response: newResponse['message'] ?? 'Login failed. Please try again.',
        ).show(context);
      }
    } catch (e) {
      myProvider.updateLoging(!myProvider.myLoging);
      print('Login error: $e');
      AppSnackbar(
        isError: true,
        response: 'Network error. Please check your connection and try again.',
      ).show(context);
    }
  }
}
