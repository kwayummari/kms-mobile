import 'package:flutter/material.dart';
import 'package:kms/src/gateway/profile-service.dart';
import 'package:kms/src/screens/models/settings/account/info.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/widgets/app_base_screen.dart';
import 'package:kms/src/widgets/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class account extends StatefulWidget {
  const account({super.key});

  @override
  State<account> createState() => _accountState();
}

class _accountState extends State<account> {
  var data;
  var fullname;
  var roles;
  @override
  void initState() {
    getName();
    fetchData();
    super.initState();
  }

  Future<String> getName() async {
    ProfileService profileService = ProfileService();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var name = sharedPreferences.getString('fullname');
    var role = sharedPreferences.getString('rolesName');
    var id = sharedPreferences.getString('id');
    final datas = await profileService.profile(context, id!);
    setState(() {
      fullname = name.toString();
      roles = role.toString();
      data = datas['user'];
    });
    return name.toString();
  }

  void fetchData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var name = sharedPreferences.getString('fullname');
    setState(() {
      fullname = name.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseScreen(
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: 'Your account',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
            ),
            TextSpan(
              text: '\n@${fullname}',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      isFlexible: false,
      showAppBar: true,
      bgcolor: AppConst.white,
      appBarBgColor: AppConst.white,
      iconColor: AppConst.black,
      isvisible: false,
      backgroundImage: false,
      backgroundAuth: false,
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Title(
              color: Colors.white,
              child: AppText(
                txt:
                    'See information about your account,download an archive of your data, or learn about your account deactivation options.',
                size: 14,
                align: TextAlign.center,
              )),
          SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => info())),
            leading: Icon(Icons.person),
            title: AppText(
              txt: 'Account information',
              size: 15,
              weight: FontWeight.bold,
            ),
            subtitle: AppText(
                txt:
                    'See your account information like your phone number and email address.',
                size: 14),
          ),
          SizedBox(
            height: 15,
          ),
          ListTile(
            onTap: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => changePassword()));
            },
            leading: Icon(Icons.key),
            title: AppText(
              txt: 'Change your password',
              size: 15,
              weight: FontWeight.bold,
            ),
            subtitle:
                AppText(txt: 'change your password at any time', size: 14),
          ),
          SizedBox(
            height: 15,
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => account())),
            leading: Icon(Icons.download),
            title: AppText(
              txt: 'Download an archive of your data',
              size: 15,
              weight: FontWeight.bold,
            ),
            subtitle: AppText(
                txt:
                    'Get insights into the type of information stored for your account.',
                size: 14),
          ),
          SizedBox(
            height: 15,
          ),
          ListTile(
            onTap: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => deactivateAccount()));
            },
            leading: Icon(Icons.heart_broken),
            title: AppText(
              txt: 'Deactivate your account',
              size: 15,
              weight: FontWeight.bold,
            ),
            subtitle: AppText(
                txt: 'Find out how you can deactivate your account.', size: 14),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
