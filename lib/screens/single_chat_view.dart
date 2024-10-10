import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maanaap/controllers/messages_controllers.dart';
import 'package:maanaap/controllers/sign_up_controller.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'package:maanaap/utils/utils.dart';
import 'package:maanaap/widgets/play_audio_recorder_widget.dart';
import 'package:maanaap/widgets/show_profile_img_wid.dart';

import '../controllers/services/database_collection.dart';
import '../model/chat_room_model.dart';
import '../model/message_model.dart';
import '../widgets/show_emoji_keyboard.dart';
import '../widgets/show_image_container_wid.dart';
import '../widgets/text_field_signle_chat_widget.dart';

class SingleChatView extends StatefulWidget {
  final String userName;
  final String userID;
  final String profileUrl;
  final ChatRoomModel? chatRoom;
  final String showStatus;
  const SingleChatView(
      {super.key,
      required this.userName,
      required this.userID,
      required this.profileUrl,
      required this.chatRoom,
      required this.showStatus});

  @override
  State<SingleChatView> createState() => _SingleChatViewState();
}

class _SingleChatViewState extends State<SingleChatView> {
  TextEditingController message = TextEditingController();
  MessageControllers imageCon = Get.put(MessageControllers());
  SignUpController imgPth = Get.put(SignUpController());

  // final audioPlayer = AudioPlayer();
  ScrollController controller = ScrollController();
  bool isPlaying = false;
  final messages = [
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    'Lorem Ipsum is simply dummy text of the printing and typesetting industrysadfksanfdknsakfdnlsakflfnlasnd',
    'This is a relatively longer line of text.',
    'Hi!',
    'This is a short message.',
    'This is a relatively longer line of text.',
    'Hi!',
  ];

  // Duration duration = Duration.zero;
  // Duration position = Duration.zero;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
  }

  // Duration? audioDuration;
  String url =
      'https://firebasestorage.googleapis.com/v0/b/workapp-d4e73.appspot.com/o/Main%20Woh%20Chaand%20-%20Teraa%20Surroor%20-%20Darshan%20Raval%20-%20ClickMaza.com.mp3?alt=media&token=dab88f8e-d967-4645-a5d4-a39167dc1f44';

  @override
  void dispose() {
    // TODO: implement dispose
    // audioPlayer.dispose();
    super.dispose();
  }

  // bool isEmoji = false;

  @override
  Widget build(BuildContext context) {
    // print('build called');
    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      appBar: AppUtils.appBar(
        showStatus: widget.showStatus.toString(),
        image: widget.profileUrl,
        userName: widget.userName,
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
            }),
      ),
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
                                  (messageMod.image == null ||
                                              messageMod.image!.isEmpty) &&
                                          (messageMod.voice == null ||
                                              messageMod.voice!.isEmpty)
                                      ? textBox(messageMod, uid)
                                      : messageMod.image!.isNotEmpty
                                          ? ShowImageContainerWid(
                                              imageHol: messageMod.image!,
                                              imageTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ShowProfileImgWid(
                                                      image: messageMod.image!,
                                                    ),
                                                  ),
                                                );
                                              },
                                              color: AppColors.defaultColor)
                                          : messageMod.voice!.isNotEmpty
                                              ? showVoiceTab(messageMod.voice!)
                                              : const SizedBox(),
                                  // AppUtils.sizedBox(4.0, 0.0),

                                  // AppUtils.sizedBox(4.0, 0.0),

                                  ///show fake image if uploading
                                  AppUtils.sizedBox(4.0, 0.0),
                                  if (index == 0)
                                    Obx(() {
                                      return imageCon.isImgSend.value
                                          ? AppUtils.imageLoader(
                                              imageCon.imgPath.value)
                                          : AppUtils.sizedBox(0.0, 0.0);
                                    }),
                                  if (index == 0)
                                    Obx(() {
                                      return imageCon.isVoiceSend.value
                                          ? AppUtils.voiceLoader(
                                              context: context)
                                          : AppUtils.sizedBox(0.0, 0.0);
                                    }),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
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
              },
            ),
          ),

          ///text field box
          ContainerTextFieldClassWid(
            controller: message,
            onSendTap: () {
              sendMessage();
            },
            attachFile: () {
              imageCon.imgPath.value = '';
              imageCon.pickImageGall(context, () {
                Navigator.pop(context);
                imageCon.sendImageMessage();
                Future.delayed(const Duration(), () async {
                  UploadTask uploadTask =
                      chatImages.putFile(File(imageCon.imgPath.value));
                  TaskSnapshot snapshot = await uploadTask;
                  var profileDown = await snapshot.ref.getDownloadURL();
                  sendImage(profileDown);
                  imageCon.setSendImg(false);
                });
              });
            },
            emojiPickWid: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                imageCon.openTap();
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
            onFieldTap: () {
              imageCon.setEmoji();
            },
            sendRequestFunction: (File file, soundFile) async {
              await imageCon.setVoiceMessage(file.path.toString());
              Future.delayed(const Duration(), () async {
                UploadTask uploadTask = chatVoices.putFile(File(file.path));
                TaskSnapshot snapshot = await uploadTask;
                var profileDown = await snapshot.ref.getDownloadURL();
                sendVoice(profileDown);
                imageCon.setSendVoice(false);
              });
            },
          ),

          ///show emoji keyboard
          Obx(() {
            return imageCon.isEmojiChk.value
                ? ShowEmojiKeyBoard(
                    controller: message,
                  )
                : AppUtils.sizedBox(0.0, 0.0);
          })
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

  ///send voice chat
  void sendVoice(String voicePath) {
    var msgID = getRandomString(4);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    MessageModel messageModel = MessageModel(
        messageId: msgID,
        sender: uid,
        text: "",
        seen: false,
        creation: DateTime.now(),
        image: "",
        voice: voicePath,
        imageText: "");
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(widget.chatRoom!.chatRoomId)
        .collection("messages")
        .doc(messageModel.messageId.toString())
        .set(messageModel.toMap());
    widget.chatRoom!.lastMessage = "voice";
    widget.chatRoom!.chatTime = DateTime.now();
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(widget.chatRoom!.chatRoomId)
        .set(widget.chatRoom!.toMap());
  }

  ///send image
  void sendImage(String imagePath) {
    var msgID = getRandomString(4);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    MessageModel messageModel = MessageModel(
        messageId: msgID,
        sender: uid,
        text: "",
        seen: false,
        creation: DateTime.now(),
        image: imagePath,
        voice: "",
        imageText: "");
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(widget.chatRoom!.chatRoomId)
        .collection("messages")
        .doc(messageModel.messageId.toString())
        .set(messageModel.toMap());
    widget.chatRoom!.lastMessage = "image";
    widget.chatRoom!.chatTime = DateTime.now();
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(widget.chatRoom!.chatRoomId)
        .set(widget.chatRoom!.toMap());
  }

  ///show voice button
  Widget showVoiceTab(String url) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.097,
      width: MediaQuery.of(context).size.width / 1.5,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: AudioPlayerScreen(
        source: url,
      ),
    );
  }

  ///chat text box
  Widget textBox(MessageModel messageMod, String uid) {
    return AppUtils.chatBox(
        context: context,
        decoration: (messageMod.sender == uid)
            ? BoxDecoration(
                border: Border.all(
                  color: AppColors.defaultColor.withOpacity(0.01),
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
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              )
            : BoxDecoration(
                color: AppColors.defaultColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
        message: messageMod.text.toString(),
        messageTim: AppUtils.firebaseTimestampSingleMsg(messageMod.creation!),
        msgTextColor:
            (messageMod.sender == uid) ? AppColors.defaultColor : Colors.white,
        msgTimColor:
            (messageMod.sender == uid) ? AppColors.defaultColor : Colors.white,
        sentOrNot: (messageMod.sender == uid)
            ? const Icon(
                Icons.done_all_sharp,
                color: Colors.blue,
                size: 12,
              )
            : AppUtils.sizedBox(0.0, 0.0));
  }
}
