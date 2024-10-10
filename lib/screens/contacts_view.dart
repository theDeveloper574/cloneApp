import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maanaap/controllers/get_method_controllers.dart';
import 'package:maanaap/model/chat_room_model.dart';
import 'package:maanaap/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/contacts_model.dart';
import '../res/colors.dart';
import '../widgets/call_info_detail_wid.dart';
import 'new_chat_view.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  ScrollController controller = ScrollController();
  ScrollController controller2 = ScrollController();
  GetMethodController getMethod = Get.put(GetMethodController());
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
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.33,
            child: StreamBuilder(
              stream: getMethod.usersSnapshot(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("wait...."));
                } else if (snapshot.hasError) {
                  Text(snapshot.error.toString());
                } else {
                  List<UserModel> list = snapshot.data!.docs
                      .map((e) => UserModel.fromDocumentSnapshot(e))
                      .toList();
                  return ListView.builder(
                    itemCount: list.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, int index) {
                      var data = list[index];
                      return CallInfoDetailAndProfileWidget(
                        onListTap: () async {
                          ChatRoomModel? chatRoomMod =
                              await getChatRoomModel(data.userId);
                          if (chatRoomMod != null) {
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NewChatView(
                                    userID: data.userId,
                                    userName: data.name,
                                    profileUrl: data.imageUrl,
                                    chatRoom: chatRoomMod,
                                  ),
                                ),
                              );
                            }
                          }
                          // Navigator.pushNamed(context, RouteName.newChatView);
                        },
                        videoCallWid: AppUtils.sizedBox(0.0, 0.0),
                        audioCallWid: AppUtils.sizedBox(0.0, 0.0),
                        imageProvider: Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(data.imageUrl),
                          ),
                        ),
                        about: data.about,
                        nameTitle: data.name,
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getContact(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return ListView.builder(
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: 12,
                    itemBuilder: (context, int index) {
                      return AppUtils.showShimmer();
                    },
                  );
                } else {
                  return ListView.separated(
                    controller: controller,
                    // shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = snapshot.data[index];
                      Color color = colors[index % colors.length];
                      return AppUtils.showMobileContactUtils(
                          // phoneNum: '',
                          onInvite: () async {
                            await launch(
                                "sms:${contact.phones[0].number.toString().substring(1)}?body=Let's chat on MaanApp! It's a fast, simple, and secure app we can use to message and Bob call each other for free.");
                          },
                          name: contact.displayName.toString().substring(0, 1),
                          contactDisplayName: contact.displayName,
                          phoneNum: contact.phones.isEmpty
                              ? ""
                              : contact.phones[0].number,
                          profileColor: color.withOpacity(0.75));
                    },
                    separatorBuilder: (context, int index) {
                      return Divider(
                        indent: 80,
                        height: 0.0,
                        thickness: 0.4,
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
      return await FastContacts.getAllContacts();
    }
    return [];
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(var length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  ///creating chat model
  Future<ChatRoomModel?> getChatRoomModel(String id) async {
    ChatRoomModel? chatRoom;
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var chatRoomId = getRandomString(10);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .where("participants.$uid", isEqualTo: true)
        .where("participants.$id", isEqualTo: true)
        .get();
    if (snapshot.docs.length > 0) {
      // if (kDebugMode) {
      //   print('already exits');
      // }
      var docData = snapshot.docs[0].data();
      ChatRoomModel chatRoomModel =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = chatRoomModel;
    } else {
      ChatRoomModel chatRoomModel = ChatRoomModel(
          chatRoomId: chatRoomId,
          participants: {
            uid.toString(): true,
            id.toString(): true,
          },
          lastMessage: "",
          chatTime: DateTime.now(),
          users: [uid.toString(), id.toString()]);
      await FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomId)
          .set(chatRoomModel.toMap());
      chatRoom = chatRoomModel;
      // if (kDebugMode) {
      //   print("chat room created success");
      // }
    }
    return chatRoom;
  }
}
