import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maanaap/model/message_model.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'package:maanaap/utils/utils.dart';

import '../controllers/messages_controllers.dart';
import '../controllers/sign_up_controller.dart';
import '../model/chat_room_model.dart';
import '../widgets/text_field_signle_chat_widget.dart';

class NewChatView extends StatefulWidget {
  final String userName;
  final String userID;
  final String profileUrl;
  final ChatRoomModel? chatRoom;
  const NewChatView(
      {super.key,
      required this.userName,
      required this.userID,
      required this.profileUrl,
      required this.chatRoom});

  @override
  State<NewChatView> createState() => _NewChatViewState();
}

class _NewChatViewState extends State<NewChatView> {
  bool isPlaying = false;

  MessageControllers imageCon = Get.put(MessageControllers());

  SignUpController imgPth = Get.put(SignUpController());

  TextEditingController message = TextEditingController();
  bool isEmoji = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      appBar: AppUtils.appBar(
          showStatus: "Offline",
          userName: widget.userName,
          image: widget.profileUrl,
          context: context,
          profileTap: () {
            Navigator.pushNamed(context, RouteName.userProfileView);
          },
          onCallTap: () {},
          onVideoTap: () {},
          onUpMenuBut: PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Settings"),
                  ),
                ];
              },
              onSelected: (val) {
                // if(val=="1"){
                FocusManager.instance.primaryFocus!.unfocus();
                // }
              })),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatRooms")
                  .doc(widget.chatRoom!.chatRoomId)
                  .collection('messages')
                  .orderBy("creation", descending: true)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                    var uid = FirebaseAuth.instance.currentUser!.uid;
                    return ListView.builder(
                      reverse: true,
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        MessageModel messageMod = MessageModel.fromMap(
                            dataSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: (messageMod.sender == uid)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: (messageMod.sender == uid)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  AppUtils.chatBox(
                                      context: context,
                                      decoration: (messageMod.sender == uid)
                                          ? BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.defaultColor
                                                    .withOpacity(0.01),
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    spreadRadius: 0.01,
                                                    blurRadius: 0.01,
                                                    blurStyle: BlurStyle.solid)
                                              ],
                                              color: Colors.white,
                                              // border: Border.all(
                                              //   color: Colors.grey,
                                              // ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            )
                                          : BoxDecoration(
                                              color: AppColors.defaultColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                      message: messageMod.text.toString(),
                                      // messageTim: "12:11",
                                      // messageTim: '',
                                      messageTim:
                                          AppUtils.firebaseTimestampSingleMsg(
                                              messageMod.creation!),
                                      msgTextColor: (messageMod.sender == uid)
                                          ? AppColors.defaultColor
                                          : Colors.white,
                                      msgTimColor: (messageMod.sender == uid)
                                          ? AppColors.defaultColor
                                          : Colors.white,
                                      sentOrNot: (messageMod.sender == uid)
                                          ? const Icon(
                                              Icons.done_all_sharp,
                                              color: Colors.blue,
                                              size: 12,
                                            )
                                          : AppUtils.sizedBox(0.0, 0.0)),
                                  AppUtils.sizedBox(2.0, 0.0),

                                  ///voice message box
                                  // AppUtils.voiceBox(
                                  //     context: context,
                                  //     boxColor: index % 2 == 0
                                  //         ? AppColors.defaultColor
                                  //         : Colors.white,
                                  //     rowAlignment: index % 2 == 0
                                  //         ? MainAxisAlignment.end
                                  //         : MainAxisAlignment.start,
                                  //     onPlayTap: () async {
                                  //       if (isPlaying) {
                                  //         await audioPlayer.pause();
                                  //       } else {
                                  //         await audioPlayer.resume();
                                  //       }
                                  //     },
                                  //     icon:
                                  //         isPlaying ? Icons.pause : Icons.play_arrow,
                                  //     max:
                                  //         double.parse(duration.inSeconds.toString()),
                                  //     val: position.inSeconds.toDouble(),
                                  //     onSliderCh: (val) async {
                                  //       final position =
                                  //           Duration(seconds: val.toInt());
                                  //       await audioPlayer.seek(position);
                                  //
                                  //       ///if audio player paused
                                  //       await audioPlayer.resume();
                                  //     },
                                  //     seekTime: formatTime(position),
                                  //     voiceTime: "12:45"),
                                  // showVoiceTab(),
                                  // AppUtils.sizedBox(2.0, 0.0),

                                  ///show image box
                                  // text['text'] == null ||
                                  //         text['text'].isEmpty ||
                                  //         text['audio_file'] == null ||
                                  //         text['audio_file'].isEmpty ||
                                  //         text['media_text'] == null ||
                                  //         text['media_text'].isEmpty
                                  //     ? const SizedBox()
                                  //     : ShowImageContainerWid(
                                  //         imageHol: text['media'],
                                  //         imageTap: () {
                                  //           Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //               builder: (_) =>
                                  //                   ShowProfileImgWid(
                                  //                 image: text['media'],
                                  //               ),
                                  //             ),
                                  //           );
                                  //         },
                                  //         color: text['is_me'] == true
                                  //             ? Colors.white
                                  //             : AppColors.defaultColor),

                                  ///show fake image if uploading
                                  AppUtils.sizedBox(4.0, 0.0),
                                  index == snapshot.data!.docs.length - 1
                                      ? Obx(() {
                                          return imageCon.isImgSend.value
                                              ? AppUtils.imageLoader(
                                                  imageCon.imgPath.value)
                                              : AppUtils.sizedBox(0.0, 0.0);
                                        })
                                      : AppUtils.sizedBox(0.0, 0.0),
                                  index == snapshot.data!.docs.length - 1
                                      ? Obx(() {
                                          return imageCon.isVoiceSend.value
                                              ? AppUtils.voiceLoader(
                                                  context: context)
                                              : AppUtils.sizedBox(0.0, 0.0);
                                        })
                                      : AppUtils.sizedBox(0.0, 0.0),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      // separatorBuilder: (BuildContext context, int index) {
                      //   var text = snapshot.data.docs[index];
                      //   return Center(
                      //     child: Text(
                      //       AppUtils.formatFirebaseTimestamp(text["timestamp"]),
                      //     ),
                      //   );
                      // },
                    );
                  } else if (snapshot.hasError) {
                    const Center(
                      child: Text(
                          "An error occurred! Please Check Your Internet Connection."),
                    );
                  } else {
                    const Center(
                      child: Text("NO CHAT FOUND"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const SizedBox();
                //   if (!snapshot.hasData) {
                //     return const Text("Loading");
                //   }
                //   return ListView.builder(
                //     itemCount: snapshot.data.docs.length,
                //     itemBuilder: (context, index) {
                //       var text = snapshot.data.docs[index];
                //       // print(object)
                //       return Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 6.0),
                //         child: Flex(
                //           direction: Axis.horizontal,
                //           mainAxisAlignment: text['is_me'] == true
                //               ? MainAxisAlignment.start
                //               : MainAxisAlignment.end,
                //           children: <Widget>[
                //             Column(
                //               crossAxisAlignment: text['is_me'] == true
                //                   ? CrossAxisAlignment.start
                //                   : CrossAxisAlignment.end,
                //               children: [
                //                 AppUtils.chatBox(
                //                   context: context,
                //                   decoration: text['is_me'] == true
                //                       ? BoxDecoration(
                //                           border: Border.all(
                //                             color: AppColors.defaultColor
                //                                 .withOpacity(0.1),
                //                           ),
                //                           boxShadow: const [
                //                             BoxShadow(
                //                                 color: Colors.black12,
                //                                 spreadRadius: 0.01,
                //                                 blurRadius: 0.01,
                //                                 blurStyle: BlurStyle.solid)
                //                           ],
                //                           color: Colors.white,
                //                           // border: Border.all(
                //                           //   color: Colors.grey,
                //                           // ),
                //                           borderRadius: const BorderRadius.all(
                //                             Radius.circular(14.0),
                //                           ),
                //                         )
                //                       : BoxDecoration(
                //                           color: AppColors.defaultColor,
                //                           borderRadius: const BorderRadius.all(
                //                             Radius.circular(14.0),
                //                           ),
                //                         ),
                //                   message: text['text'],
                //                   // messageTim: "12:11",
                //                   messageTim: AppUtils.firebaseTimestampSingleMsg(
                //                       text['timestamp']),
                //                   msgTextColor: text['is_me'] == true
                //                       ? AppColors.defaultColor
                //                       : Colors.white,
                //                   msgTimColor: text['is_me'] == true
                //                       ? AppColors.defaultColor
                //                       : Colors.white,
                //                   sentOrNot: text['is_me'] == true
                //                       ? AppUtils.sizedBox(0.0, 0.0)
                //                       : const Icon(
                //                           Icons.done_all_sharp,
                //                           color: Colors.blue,
                //                           size: 14,
                //                         ),
                //                 ),
                //                 AppUtils.sizedBox(2.0, 0.0),
                //
                //                 ///voice message box
                //                 // AppUtils.voiceBox(
                //                 //     context: context,
                //                 //     boxColor: index % 2 == 0
                //                 //         ? AppColors.defaultColor
                //                 //         : Colors.white,
                //                 //     rowAlignment: index % 2 == 0
                //                 //         ? MainAxisAlignment.end
                //                 //         : MainAxisAlignment.start,
                //                 //     onPlayTap: () async {
                //                 //       if (isPlaying) {
                //                 //         await audioPlayer.pause();
                //                 //       } else {
                //                 //         await audioPlayer.resume();
                //                 //       }
                //                 //     },
                //                 //     icon:
                //                 //         isPlaying ? Icons.pause : Icons.play_arrow,
                //                 //     max:
                //                 //         double.parse(duration.inSeconds.toString()),
                //                 //     val: position.inSeconds.toDouble(),
                //                 //     onSliderCh: (val) async {
                //                 //       final position =
                //                 //           Duration(seconds: val.toInt());
                //                 //       await audioPlayer.seek(position);
                //                 //
                //                 //       ///if audio player paused
                //                 //       await audioPlayer.resume();
                //                 //     },
                //                 //     seekTime: formatTime(position),
                //                 //     voiceTime: "12:45"),
                //                 // showVoiceTab(),
                //                 // AppUtils.sizedBox(2.0, 0.0),
                //
                //                 ///show image box
                //                 text['text'] == null ||
                //                         text['text'].isEmpty ||
                //                         text['audio_file'] == null ||
                //                         text['audio_file'].isEmpty ||
                //                         text['media_text'] == null ||
                //                         text['media_text'].isEmpty
                //                     ? const SizedBox()
                //                     : ShowImageContainerWid(
                //                         imageHol: text['media'],
                //                         imageTap: () {
                //                           Navigator.push(
                //                             context,
                //                             MaterialPageRoute(
                //                               builder: (_) => ShowProfileImgWid(
                //                                 image: text['media'],
                //                               ),
                //                             ),
                //                           );
                //                         },
                //                         color: text['is_me'] == true
                //                             ? Colors.white
                //                             : AppColors.defaultColor),
                //
                //                 ///show fake image if uploading
                //                 AppUtils.sizedBox(4.0, 0.0),
                //                 index == snapshot.data.docs.length - 1
                //                     ? Obx(() {
                //                         return imageCon.isImgSend.value
                //                             ? AppUtils.imageLoader(
                //                                 imageCon.imgPath.value)
                //                             : AppUtils.sizedBox(0.0, 0.0);
                //                       })
                //                     : AppUtils.sizedBox(0.0, 0.0),
                //                 index == snapshot.data.docs.length - 1
                //                     ? Obx(() {
                //                         return imageCon.isVoiceSend.value
                //                             ? AppUtils.voiceLoader(
                //                                 context: context)
                //                             : AppUtils.sizedBox(0.0, 0.0);
                //                       })
                //                     : AppUtils.sizedBox(0.0, 0.0),
                //               ],
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //     // separatorBuilder: (BuildContext context, int index) {
                //     //   var text = snapshot.data.docs[index];
                //     //   return Center(
                //     //     child: Text(
                //     //       AppUtils.formatFirebaseTimestamp(text["timestamp"]),
                //     //     ),
                //     //   );
                //     // },
                //   );
                // },
              },
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: 5,
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: const EdgeInsets.all(6.0),
          //         child: Flex(
          //           direction: Axis.horizontal,
          //           mainAxisAlignment: index % 2 == 0
          //               ? MainAxisAlignment.start
          //               : MainAxisAlignment.end,
          //           children: <Widget>[
          //             Column(
          //               crossAxisAlignment: index % 2 == 0
          //                   ? CrossAxisAlignment.start
          //                   : CrossAxisAlignment.end,
          //               children: [
          //                 ///chat box
          //                 AppUtils.chatBox(
          //                   context: context,
          //                   decoration: index % 2 == 0
          //                       ? BoxDecoration(
          //                           border: Border.all(
          //                               color: AppColors.defaultColor
          //                                   .withOpacity(0.1)),
          //                           boxShadow: const [
          //                             BoxShadow(
          //                                 color: Colors.black12,
          //                                 spreadRadius: 0.01,
          //                                 blurRadius: 0.01,
          //                                 blurStyle: BlurStyle.solid)
          //                           ],
          //                           color: Colors.white,
          //                           // border: Border.all(
          //                           //   color: Colors.grey,
          //                           // ),
          //                           borderRadius: const BorderRadius.all(
          //                             Radius.circular(14.0),
          //                           ),
          //                         )
          //                       : BoxDecoration(
          //                           color: AppColors.defaultColor,
          //                           borderRadius: const BorderRadius.all(
          //                             Radius.circular(14.0),
          //                           ),
          //                         ),
          //                   message: 'Hey',
          //                   messageTim: "12:11",
          //                   msgTextColor: index % 2 == 0
          //                       ? AppColors.defaultColor
          //                       : Colors.white,
          //                   msgTimColor: index % 2 == 0
          //                       ? AppColors.defaultColor
          //                       : Colors.white,
          //                   sentOrNot: index % 2 == 0
          //                       ? AppUtils.sizedBox(0.0, 0.0)
          //                       : const Icon(
          //                           Icons.done_all_sharp,
          //                           color: Colors.blue,
          //                           size: 14,
          //                         ),
          //                 ),
          //                 AppUtils.sizedBox(2.0, 0.0),
          //
          //                 ///voice message box
          //                 // AppUtils.voiceBox(
          //                 //     context: context,
          //                 //     boxColor: index % 2 == 0
          //                 //         ? AppColors.defaultColor
          //                 //         : Colors.white,
          //                 //     rowAlignment: index % 2 == 0
          //                 //         ? MainAxisAlignment.end
          //                 //         : MainAxisAlignment.start,
          //                 //     onPlayTap: () async {
          //                 //       // if (isPlaying) {
          //                 //       //   await audioPlayer.pause();
          //                 //       // } else {
          //                 //       //   await audioPlayer.resume();
          //                 //       // }
          //                 //     },
          //                 //     icon: isPlaying ? Icons.pause : Icons.play_arrow,
          //                 //     max: double.parse(duration.inSeconds.toString()),
          //                 //     val: position.inSeconds.toDouble(),
          //                 //     onSliderCh: (val) async {
          //                 //       final position = Duration(seconds: val.toInt());
          //                 //       await audioPlayer.seek(position);
          //                 //
          //                 //       ///if audio player paused
          //                 //       await audioPlayer.resume();
          //                 //     },
          //                 //     seekTime: formatTime(position),
          //                 //     voiceTime: "12:45"),
          //                 AppUtils.sizedBox(2.0, 0.0),
          //
          //                 ///show image box
          //                 // ShowImageContainerWid(
          //                 //     imageHol: AppUtils.imageHolder,
          //                 //     imageTap: () {
          //                 //       Navigator.push(
          //                 //         context,
          //                 //         MaterialPageRoute(
          //                 //           builder: (_) => ShowProfileImgWid(
          //                 //             image: AppUtils.imageHolder,
          //                 //           ),
          //                 //         ),
          //                 //       );
          //                 //     },
          //                 //     color: index % 2 == 0
          //                 //         ? Colors.white
          //                 //         : AppColors.defaultColor),
          //
          //                 ///show fake image if uploading
          //                 // AppUtils.sizedBox(4.0, 0.0),
          //                 // index == index.length - 1
          //                 //     ? Obx(() {
          //                 //   return imageCon.isImgSend.value
          //                 //       ? AppUtils.imageLoader(
          //                 //       imageCon.imgPath.value)
          //                 //       : AppUtils.sizedBox(0.0, 0.0);
          //                 // })
          //                 //     : AppUtils.sizedBox(0.0, 0.0),
          //                 // index == messages.length - 1
          //                 //     ? Obx(() {
          //                 //   return imageCon.isVoiceSend.value
          //                 //       ? AppUtils.voiceLoader(context: context)
          //                 //       : AppUtils.sizedBox(0.0, 0.0);
          //                 // })
          //                 //     : AppUtils.sizedBox(0.0, 0.0),
          //               ],
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),

          ///set image and audio container for show uploading

          ///text field box
          ContainerTextFieldClassWid(
            controller: message,
            onSendTap: () {},
            attachFile: () {},
            emojiPickWid: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                imageCon.setEmoji();
              },
              child: Obx(() {
                return Icon(
                  imageCon.isEmojiChk.value
                      ? Icons.keyboard
                      : Icons.emoji_emotions,
                  color: Colors.amber,
                );
              }),
            ),
            onFieldTap: () {},
            sendRequestFunction: (File file, soundFile) async {
              await imageCon.setVoiceMessage(file.path.toString());
            },
          ),
          // ContainerTextFieldClassWid(
          //     onFieldTap: () {
          //       if (isEmoji) {
          //         setState(() {
          //           isEmoji = !isEmoji;
          //         });
          //       }
          //     },
          //     attachFile: () {
          //       // imageCon.pickImageGall(context);
          //       // messageEndScroll();
          //       // AppUtils.messageEndScroll(controller);
          //     },
          //     onVal: (val) {
          //       setState(() {
          //         val = message.text.trim();
          //       });
          //     },
          //     controller: message,
          //     onSendTap: () async {
          //       sendMessage();
          //       // await sendMesg(
          //       //     mediaText: '',
          //       //     media: '',
          //       //     isME: true,
          //       //     text: message.text.toString(),
          //       //     name: widget.userName);
          //       // await sendMessage("243114", message.text.trim());
          //       // AppUtils.messageEndScroll(controller);
          //       // print(message.text.trim());
          //       // setState(() {
          //       //   messages.add(message.text.trim());
          //       //   // scrollToEnd();
          //       //
          //       //
          //       // });
          //       // scrollToEnd();
          //       // messageEndScroll();
          //       message.clear();
          //     },
          //     emojiPickWid: GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           FocusScope.of(context).unfocus();
          //           isEmoji = !isEmoji;
          //         });
          //       },
          //       child: Icon(
          //         isEmoji ? Icons.keyboard : Icons.emoji_emotions,
          //         color: Colors.amber,
          //       ),
          //     )),

          ///show emoji keyboard
          Obx(() {
            return imageCon.isEmojiChk.value
                ? showEmojiBoard()
                : AppUtils.sizedBox(0.0, 0.0);
          })
          // if (imageCon.isEmojiChk.value) showEmojiBoard(),
        ],
      ),
    );
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

  ///send message text to the user
  void sendMessage() {
    String msg = message.text.trim();
    var msgID = getRandomString(4);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    message.clear();
    if (msg != "") {
      MessageModel messageModel = MessageModel(
          messageId: msgID,
          sender: uid,
          text: msg,
          seen: false,
          creation: DateTime.now(),
          image: "",
          voice: "",
          imageText: "");
      FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(widget.chatRoom!.chatRoomId)
          .collection("messages")
          .doc(messageModel.messageId.toString())
          .set(messageModel.toMap());
      widget.chatRoom!.lastMessage = msg;
      widget.chatRoom!.chatTime = DateTime.now();
      FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(widget.chatRoom!.chatRoomId)
          .set(widget.chatRoom!.toMap());
    }
  }

  ///show emoji keyboard
  Widget showEmojiBoard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.32,
      child: EmojiPicker(
        textEditingController: message,
        // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
          columns: 7,
          emojiSizeMax: 32 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.30
                  : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
        ),
      ),
    );
  }
}
