import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maanaap/controllers/services/firebase_helper_method.dart';
import 'package:maanaap/model/chat_room_model.dart';
import 'package:maanaap/screens/single_chat_view.dart';

import '../model/user_data_model.dart';
import '../utils/utils.dart';
import '../widgets/chat_list_wid.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chatRooms")
                .where('users',
                    arrayContains: FirebaseAuth.instance.currentUser!.uid)
                .orderBy("chatTime")
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot snapshotQu = snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshotQu.docs.length,
                    itemBuilder: (context, index) {
                      var uid = FirebaseAuth.instance.currentUser!.uid;
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          snapshotQu.docs[index].data()
                              as Map<String, dynamic>);
                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;
                      List<String> participantKey = participants.keys.toList();
                      participantKey.remove(uid);
                      return FutureBuilder(
                        future:
                            FirebaseHelper.getUserModById(participantKey[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserDataModel userDataModel =
                                  userData.data as UserDataModel;
                              return ChatListAndCallWidget(
                                imageProfile: userDataModel.imageUrl.toString(),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SingleChatView(
                                        showStatus:
                                            userDataModel.chatStatus.toString(),
                                        userName: userDataModel.name.toString(),
                                        userID: userDataModel.userId.toString(),
                                        profileUrl:
                                            userDataModel.imageUrl.toString(),
                                        chatRoom: chatRoomModel,
                                      ),
                                    ),
                                  );
                                },
                                userName: userDataModel.name.toString(),
                                iconWidget: (chatRoomModel.lastMessage == "")
                                    ? const Text("")
                                    : const Icon(
                                        Icons.done_all,
                                        color: Colors.blue,
                                        size: 12.0,
                                      ),
                                msgOrCallTime: (chatRoomModel.lastMessage == "")
                                    ? "Say! Hi to your New Friend"
                                    : chatRoomModel.lastMessage.toString(),
                                widget: Text(
                                  (chatRoomModel.lastMessage == "")
                                      ? ""
                                      : AppUtils.firebaseTimestampSingleMsg(
                                          chatRoomModel.chatTime!,
                                        ),
                                  style: GoogleFonts.asap(fontSize: 10),
                                ),
                              );
                            }
                          } else {
                            return const SizedBox();
                          }
                          return const SizedBox();
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child:
                        Text("An error occurred! NO Internet Connection Found"),
                  );
                } else {
                  return const Center(child: Text("NO CHATS FOUND"));
                }
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
