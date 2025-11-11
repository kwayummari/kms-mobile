import 'dart:convert';

import 'package:kms/src/api/apis.dart';
import 'package:kms/src/provider/login-provider.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/utils/routes/route-names.dart';
import 'package:kms/src/widgets/app_snackbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class registrationService {
  static String baseUrl = dotenv.env['API_SERVER'] ?? 'http://noapi';
  Api api = Api();

  Future<void> registration(
      BuildContext context,
      String username,
      String password,
      String rpassword,
      String fullname,
      String email,
      String phone) async {
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.updateLoging(!myProvider.myLoging);
    if (password.toString() == rpassword.toString()) {
      Map<String, dynamic> data = {
        'username': username.toString(),
        'password': password.toString(),
        'full_name': fullname.toString(),
        'email': email.toString().isEmpty ? null : email.toString(),
        'phone': phone.toString(),
      };
      final response = await api.post(context, 'auth/register', data);
      final newResponse = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        myProvider.updateLoging(!myProvider.myLoging);
        Fluttertoast.showToast(
          msg: newResponse['message'] ?? 'Account created successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppConst.primary,
          textColor: Colors.white,
          fontSize: 15.0,
        );
        Navigator.pushNamed(context, RouteNames.login);
      } else {
        myProvider.updateLoging(!myProvider.myLoging);
        AppSnackbar(
          isError: true,
          response: newResponse['message'] ??
              'Registration failed. Please try again.',
        ).show(context);
      }
    } else {
      myProvider.updateLoging(!myProvider.myLoging);
      AppSnackbar(
        isError: true,
        response: 'Passwords do not match!',
      ).show(context);
    }
  }
}
