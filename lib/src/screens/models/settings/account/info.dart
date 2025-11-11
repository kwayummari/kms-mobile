// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:kms/src/gateway/profile-service.dart';
import 'package:kms/src/utils/app_const.dart';
import 'package:kms/src/widgets/app_base_screen.dart';
import 'package:kms/src/widgets/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class info extends StatefulWidget {
  const info({super.key});

  @override
  State<info> createState() => _infoState();
}

class _infoState extends State<info> {
  List data = [];
  void fetchData() async {
    ProfileService profileService = ProfileService();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var id = sharedPreferences.getString('id');
    final datas = await profileService.profile(context, id!);
    setState(() {
      data = datas['user'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseScreen(
      isFlexible: false,
      showAppBar: true,
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.white),
          children: <TextSpan>[
            TextSpan(
              text: 'Your account',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: AppConst.black),
            ),
            TextSpan(
              text: data.isNotEmpty
                  ? '\n@${data[0]['fullname'].toString()}'
                  : 'Loading',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: AppConst.primary),
            ),
          ],
        ),
      ),
      bgcolor: AppConst.white,
      appBarBgColor: AppConst.white,
      iconColor: AppConst.black,
      isvisible: false,
      backgroundImage: false,
      backgroundAuth: false,
      padding: EdgeInsets.all(0),
      child: data.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) => usernameChange()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 20, top: 20),
                    child: Row(
                      children: [
                        AppText(
                          txt: 'Full Name',
                          size: 15,
                          weight: FontWeight.bold,
                        ),
                        Spacer(),
                        AppText(
                          txt: '@${data[0]['fullname']}',
                          size: 15,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => changePhonenumber(
                    //           phone: data[0]['phone'],
                    //         )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        AppText(
                          txt: 'Phone',
                          size: 15,
                          weight: FontWeight.bold,
                        ),
                        Spacer(),
                        AppText(
                          txt: data[0]['phone'],
                          size: 15,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => changePhonenumber(
                    //           phone: data[0]['phone'],
                    //         )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        AppText(
                          txt: 'Email',
                          size: 15,
                          weight: FontWeight.bold,
                        ),
                        Spacer(),
                        AppText(
                          txt: data[0]['email'],
                          size: 15,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => changePhonenumber(
                    //           phone: data[0]['phone'],
                    //         )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        AppText(
                          txt: 'Role',
                          size: 15,
                          weight: FontWeight.bold,
                        ),
                        Spacer(),
                        AppText(
                          txt: data[0]['roleName'],
                          size: 15,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => changePhonenumber(
                    //           phone: data[0]['phone'],
                    //         )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        AppText(
                          txt: 'Company',
                          size: 15,
                          weight: FontWeight.bold,
                        ),
                        Spacer(),
                        AppText(
                          txt: data[0]['companyName'],
                          size: 15,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => changePhonenumber(
                    //           phone: data[0]['phone'],
                    //         )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Row(
                      children: [
                        AppText(
                          txt: 'Branch',
                          size: 15,
                          weight: FontWeight.bold,
                        ),
                        Spacer(),
                        AppText(
                          txt: data[0]['branchName'],
                          size: 15,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      AppText(
                        txt: 'Country',
                        size: 15,
                        weight: FontWeight.bold,
                      ),
                      Spacer(),
                      AppText(
                        txt: 'Tanzania',
                        size: 15,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 15,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Uri.parse('https://flutter.dev'),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Select the country you live in. ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Learn more',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
