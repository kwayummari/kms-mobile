import 'package:kms/src/screens/models/bottomNavigationBar/bottomNavigationBar.dart';
import 'package:kms/src/screens/models/dashboard/dashboard.dart';
import 'package:kms/src/screens/models/loan/allLoans.dart';
import 'package:kms/src/screens/models/loan/loanApplication.dart';
import 'package:kms/src/screens/models/profile/profile.dart';
import 'package:kms/src/screens/models/savings/allSavings.dart';
import 'package:kms/src/screens/models/shares/allShares.dart';
import 'package:kms/src/screens/models/userList/user.dart';
import 'package:kms/src/utils/routes/route-names.dart';
import 'package:flutter/material.dart';
import 'package:kms/src/screens/authentication/login.dart';
import 'package:kms/src/screens/authentication/registration.dart';
import 'package:kms/src/screens/splash/splash.dart';

final Map<String, WidgetBuilder> routes = {
  RouteNames.login: (context) => const Login(),
  RouteNames.registration: (context) => const Registration(),
  RouteNames.splash: (context) => const Splash(),
  RouteNames.dashboard: (context) => const Dashboard(),
  RouteNames.profile: (context) => const Profile(),
  RouteNames.bottomNavigationBar: (context) => const BottomNavigation(),
  RouteNames.loanApplication: (context) => const LoanApplication(),
  RouteNames.user: (context) => const UserList(),
  RouteNames.loan: (context) => const AllLoans(),
  RouteNames.savings: (context) => const AllSavings(),
  RouteNames.shares: (context) => const AllShares(),
};
