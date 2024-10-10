import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maanaap/controllers/get_method_controllers.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'package:maanaap/utils/utils.dart';
import 'package:maanaap/widgets/call_info_detail_wid.dart';

import '../controllers/services/firebase_helper_method.dart';

class HomeSettingsView extends StatelessWidget {
  HomeSettingsView({super.key});
  GetMethodController getMethodController = GetMethodController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          CallInfoDetailAndProfileWidget(
            onListTap: () {
              Navigator.pushNamed(context, RouteName.myProfileView);
            },
            videoCallWid: AppUtils.sizedBox(0.0, 0.0),
            audioCallWid: AppUtils.sizedBox(0.0, 0.0),
            imageProvider: Hero(
              tag: "my-profile",
              child: Image.asset('asset/signup.png'),
            ),
            about: 'Hello there how are you!!!',
            nameTitle: 'My profile',
          ),
          const Divider(),
          InkWell(
              onTap: () async {
                await FirebaseHelper.setStatus(
                    "offline", FirebaseAuth.instance.currentUser!.uid);
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.logIn, (route) => false);
                });
              },
              child: const Text("Sign Out"))
        ],
      ),
    );
  }
}
