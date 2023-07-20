import 'package:flutter/material.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import '../res/colors.dart';
import '../utils/utils.dart';

// class TextFieldSingleChatWidget extends StatelessWidget {
//   final TextEditingController controller;
//   final Function() onSend;
//   const TextFieldSingleChatWidget ({Key? key,required this.controller,required this.onSend}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       color: AppColors.sliderOneColor,
//       child: Row(
//         children: [
//           AppUtils.sizedBox(0.0, 6),
//           Expanded(
//               child: TextFormField(
//                 controller: controller,
//                 cursorColor: AppColors.defaultColor,
//                 decoration: AppUtils.decorationMessage("write message..."),
//               )),
//           AppUtils.sizedBox(0.0, 8),
//           CircleAvatar(
//             backgroundColor: AppColors.defaultColor,
//             child: IconButton(
//               onPressed:onSend,
//               icon: const Icon(Icons.send,color: Colors.white,),
//             ),
//           ),
//           AppUtils.sizedBox(0.0, 8),
//         ],
//       ),
//     );
//   }
// }

class ContainerTextFieldClassWid extends StatelessWidget {
  final TextEditingController controller;

  const ContainerTextFieldClassWid({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      // height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: Colors.white)),
                child: Column(
                  children: [
                    // if(isReplying) buildReply(chatRoomProvider),
                    TextFormField(
                      onTap: () {
                        // if (isEmoji) {
                        //   setState(() {
                        //     isEmoji = !isEmoji;
                        //   });
                        // }
                      },
                      // onChanged: (val) =>
                      //     setState(() {
                      //       val = msgCon.text.trim();
                      //     }),
                      controller: controller,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      maxLines: 3,
                      minLines: 1,
                      cursorColor: Colors.grey,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Type message here',
                        hintStyle: const TextStyle(color: Colors.grey),
                        // border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.09),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.09))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.09))),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        suffixIcon: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  // setState(() {
                                  FocusScope.of(context).unfocus();
                                  // value.chekEmo();
                                  // isEmoji = !isEmoji;
                                  // });
                                },
                              ),
                            ],
                          ),
                        ),
                        prefixIcon: IconButton(
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.amber,
                          ),
                          onPressed: () async {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          controller.text.isNotEmpty
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 16.0,
                    ),
                    SocialMediaRecorder(
                      // counterBackGroundColor: Colors.red,
                      cancelTextBackGroundColor: Colors.white,
                      counterTextStyle: const TextStyle(color: Colors.red),
                      recordIcon: const Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                      backGroundColor: AppColors.defaultColor,
                      recordIconWhenLockBackGroundColor: AppColors.defaultColor,
                      recordIconBackGroundColor: AppColors.whiteColor,
                      cancelTextStyle: const TextStyle(color: Colors.grey),
                      slideToCancelTextStyle:
                          const TextStyle(color: Colors.white, fontSize: 16.0),
                      radius: BorderRadius.circular(50.0),
                      sendRequestFunction: (soundFile) async {
                        // ref.watch(handleAud).path = soundFile.path.toString();
                        // await chatRoomProvider.postVoiceMessage(length, soundFile, authProvider);
                      },
                      encode: AudioEncoderType.AAC,
                    ),
                  ],
                ),
          controller.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MaterialButton(
                    minWidth: 20.0,
                    height: 40.0,
                    onPressed: () async {},
                    shape: const CircleBorder(),
                    color: AppColors.defaultColor,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              : const Text(""),
        ],
      ),
    );
  }
}
