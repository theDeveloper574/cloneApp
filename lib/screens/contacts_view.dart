import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:maanaap/utils/utils.dart';
import 'package:maanaap/widgets/call_info_detail_wid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res/colors.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  ScrollController controller = ScrollController();
  ScrollController controller2 = ScrollController();
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    AppColors.orangeColor,
    AppColors.buttonColor,
    Colors.purple,
    AppColors.defaultColor,
    Colors.lightBlueAccent,
    AppColors.blueColor,
    Colors.deepOrange,
    AppColors.darkGreen,
  ];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   getContact();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Contacts"),
      ),
      body: Column(
        children: [
          ListView.builder(
            controller: controller2,
            itemCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, int index) {
              return CallInfoDetailAndProfileWidget(
                onListTap: () {
                  // Navigator.pushNamed(context, RouteName.myProfileView);
                },
                videoCallWid: AppUtils.sizedBox(0.0, 0.0),
                audioCallWid: AppUtils.sizedBox(0.0, 0.0),
                imageProvider: Image.asset('asset/signup.png'),
                about: 'Hello there how are you!!!',
                nameTitle: 'My profile',
              );
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: getContact(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return ListView.builder(
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: 12,
                    itemBuilder: (context, int index) {
                      return AppUtils.showShimmer();
                    },
                  );
                } else {
                  return ListView.separated(
                    // physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    // shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = snapshot.data[index];
                      Color color = colors[index % colors.length];
                      return AppUtils.showMobileContactUtils(
                          onInvite: () async {
                            await launch(
                                "sms:+92${contact.phones.first.toString().substring(1)}?body=Let's chat on MaanApp! It's a fast, simple, and secure app we can use to message and Bob call each other for free.");
                          },
                          name: contact.displayName.toString().substring(0, 1),
                          contactDisplayName: contact.displayName,
                          phoneNum: contact.phones == null
                              ? ""
                              : contact.phones[0],
                          profileColor: color.withOpacity(0.75));
                    },
                    separatorBuilder: (context, int index) {
                      return Divider(
                        indent: 80,
                        height: 0.0,
                        thickness: 1.1,
                        color: AppColors.defaultColor.withOpacity(0.2),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  ///get users contact list and and get user permission
  Future<List<Contact>> getContact() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      return await FastContacts.allContacts;
    }
    return [];
  }
}
