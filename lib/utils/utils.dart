import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/widgets/play_audio_recorder_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static const imageHolder =
      "https://images.pexels.com/photos/17077796/pexels-photo-17077796/free-photo-of-palazzo-pesaro-papafava-in-venice.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load";

  //set sizebox
  static Widget sizedBox(double h, double w) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  //set text field decoration and bottom sheet set
  static Widget bottomText({required Function() onTap, required String text}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
            color: AppColors.defaultColor,
            fontSize: 16,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  static Future setBottomSheet({
    required String addText,
    required String initialVal,
    required BuildContext context,
    required int maxLength,
    required Function() onSave,
    required Function(String)? onChanged,
  }) {
    return Get.bottomSheet(
      SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppUtils.sizedBox(20.0, 0.0),
              Text(
                addText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextFormField(
                initialValue: initialVal,
                onChanged: onChanged,
                // controller: nameEdit,
                autofocus: true,
                maxLength: maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: AppColors.defaultColor,
                decoration: AppUtils.bottomSheetDecoration(),
              ),
              AppUtils.sizedBox(8.0, 0.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppUtils.bottomText(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: 'cancel'),
                  AppUtils.sizedBox(0.0, 20),
                  AppUtils.bottomText(onTap: onSave, text: 'save'),
                ],
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  //
  static InputDecoration decoration(
      {required String hintTe, required Widget widget}) {
    return InputDecoration(
        hintText: hintTe,
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
            borderRadius: BorderRadius.circular(10)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
            borderRadius: BorderRadius.circular(10)),
        suffix: widget);
  }

  ///text field decoration for send image container
  static InputDecoration sendImageDecoration() {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      hintText: "Add a caption...",
      hintStyle: const TextStyle(color: Colors.white),
      isDense: true,
      filled: true,
      fillColor: AppColors.defaultColor,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(22)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(22)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(22)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(22)),
      // suffix:
    );
  }

  static InputDecoration bottomSheetDecoration() {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.2, color: AppColors.defaultColor)),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.2, color: AppColors.defaultColor)),
    );
  }

  //set focus of the app
  ///code for focus field
  // static fieldFocusChange(
  //     BuildContext context, FocusNode current, FocusNode next) {
  //   current.unfocus();
  //   FocusScope.of(context).requestFocus(next);
  // }

  //show flush bar
  ///show flush bar for flutter
  static showFlushBar(BuildContext context, String message) {
    Flushbar(
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(20),
      backgroundGradient: LinearGradient(
        colors: [
          AppColors.defaultColor,
          AppColors.defaultColor.withOpacity(0.7),
          AppColors.defaultColor.withOpacity(0.5),
        ],
        stops: const [0.4, 0.7, 1],
      ),
      boxShadows: const [
        BoxShadow(
          color: Colors.white,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      icon: const Icon(
        Icons.warning,
        color: Colors.red,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(14),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      message: message,
      messageSize: 17,
    ).show(context);
  }

  //show shimmer widget
  static Widget showShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      enabled: true,
      highlightColor: Colors.grey.withOpacity(0.4),
      child: ListTile(
        onTap: () {
          // print('okay good');
          // navigatorPop(context: context);
        },
        leading: CircleAvatar(
          // backgroundColor: Colors.grey,
          radius: 22,
          child: Text(
            "",
            style: TextStyle(fontSize: 22, color: Colors.grey.withOpacity(0.4)),
          ),
          // backgroundImage: contact.,
        ),
        title: Text(
          "loading...",
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.grey.withOpacity(0.4)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
          child: Text(
            "loading...",
            style: TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.4)),
          ),
        ),
      ),
    );
  }

  //single chat app bar
  static AppBar appBar(
      {required context,
      required Function() profileTap,
      required Function() onCallTap,
      required Function() onVideoTap,
      required Widget onUpMenuBut,
      required String image,
      required String userName,
      required String showStatus}) {
    return AppBar(
      toolbarHeight: 56,
      elevation: 0.0,
      // Set this height
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.sliderOneColor,

      ///show data for users
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppUtils.sizedBox(0.0, 4),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          AppUtils.sizedBox(0.0, 8),
          CircleAvatar(
            radius: 20,
            // backgroundColor: HexColor(widget.chatColor).withOpacity(0.9),
            // backgroundColor: HexColor(widget.chatColor).withOpacity(0.9),
            child: Hero(
              tag: 'chat-list-profile',
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(image),
                // backgroundImage: AssetImage('asset/signup.png'),
              ),
            ),
          ),
          AppUtils.sizedBox(0.0, 10),
          Expanded(
            child: InkWell(
              onTap: profileTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///username
                  Text(
                    userName,
                    style: GoogleFonts.roboto(
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  AppUtils.sizedBox(5.0, 0.0),
                  Text(showStatus,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        overflow: TextOverflow.clip,
                      )),
                ],
              ),
            ),
          )
        ],
      ),

      ///show data for calls
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: onCallTap,
                child: const Icon(Icons.call_outlined, color: Colors.black)),
            AppUtils.sizedBox(0.0, 12.0),
            InkWell(
                onTap: onVideoTap,
                child:
                    const Icon(Icons.videocam_outlined, color: Colors.black)),
            AppUtils.sizedBox(0.0, 0.0),
            onUpMenuBut,
          ],
        )
      ],
    );
  }

  //text field for write message
  static InputDecoration decorationMessage(String hintTe) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      hintText: hintTe,
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.3), width: 1.2),
          borderRadius: BorderRadius.circular(20)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.3), width: 1.2),
          borderRadius: BorderRadius.circular(20)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.3), width: 1.2),
          borderRadius: BorderRadius.circular(20)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.defaultColor.withOpacity(0.3), width: 1.2),
          borderRadius: BorderRadius.circular(20)),
    );
  }

  //launch number for text message
  static Future<bool> showNumberLaunch() async {
    return await launch(
        enableJavaScript: false,
        enableDomStorage: false,
        statusBarBrightness: Brightness.light,
        forceSafariVC: false,
        forceWebView: false,
        universalLinksOnly: false,
        "sms:+923054904522?body=Let's chat on WhatsApp! It's a fast, simple, and secure app we can use to message and Bob call each other for free. Get it at $launch{https://whatsapp.com/dl/code=kUengDWSCj}");
  }

  static Widget showMobileContactUtils(
      {required Function() onInvite,
      required Color profileColor,
      required String name,
      required String contactDisplayName,
      required String phoneNum}) {
    return ListTile(
      onTap: onInvite,
      leading: CircleAvatar(
        backgroundColor: profileColor,
        radius: 22,
        child: Text(
          name,
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ),
        // backgroundImage: contact.,
      ),
      title: Text(
        contactDisplayName,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: Text(
          phoneNum,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      trailing: Text(
        "Invite",
        style: TextStyle(
            color: AppColors.defaultColor,
            // fontStyle: FontStyle.italic,
            fontSize: 12),
      ),
    );
  }

  //show chat box
  static Widget chatBox(
      {required BuildContext context,
      required Decoration decoration,
      required String message,
      required Color msgTextColor,
      required String messageTim,
      required Color msgTimColor,
      required Widget sentOrNot}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontFamily: "popins",
                      color: msgTextColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, right: 4.0, left: 4.0),
                  child: Text(
                    messageTim,
                    style: TextStyle(color: msgTimColor, fontSize: 10),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 2.0, right: 4.0, left: 2.0),
                  child: sentOrNot,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //show voice box
  static Widget voiceBox({
    required BuildContext context,
    required Color boxColor,
    required MainAxisAlignment rowAlignment,
    required Function() onPlayTap,
    required IconData icon,
    required double max,
    required double val,
    required Function(double getFutval) onSliderCh,
    required String seekTime,
    required String voiceTime,
  }) {
    return Container(
      height: 74,
      width: MediaQuery.of(context).size.width / 1.5,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      // padding: EdgeInsets.symmetric(vertical: 10),
      // width: ,
      margin: const EdgeInsets.symmetric(vertical: 4),
      // color: Colors.black,
      child: Row(
        mainAxisAlignment: rowAlignment,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 12),
              child: IconButton(
                  iconSize: 35,
                  onPressed: onPlayTap,
                  icon: Icon(icon),
                  color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 2.6,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                        value: val,
                        inactiveColor: Colors.grey.withOpacity(0.4),
                        min: 0.0,
                        max: max,
                        onChanged: onSliderCh),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        seekTime,
                        style: const TextStyle(
                            color: Color(0xffA8A196), fontSize: 12),
                      ),
                      // Text(
                      //   formatTime(duration),
                      //   style: const TextStyle(color: Colors.white),
                      // )
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, top: 0.0, bottom: 0.0),
                        child: Text(
                          voiceTime,
                          style: const TextStyle(
                              color: Color(0xffA8A196), fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //show fake image loader
  static Widget imageLoader(String imagePath) {
    return Container(
      height: 300,
      width: 210,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.defaultColor, width: 4.8),
          // color: Colors.red,
          borderRadius: BorderRadius.circular(10),
          color: AppColors.defaultColor.withOpacity(0.3),
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: FileImage(
                File(imagePath),
              ),
              fit: BoxFit.fitWidth)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.8,
            child: CircularProgressIndicator(
              color: AppColors.whiteColor,
            ),
          ),
          AppUtils.sizedBox(4.0, 0.0),
          Text(
            "Uploading...",
            style: TextStyle(color: AppColors.whiteColor),
          )
        ],
      ),
    );
  }

  //show fake voice loader
  static Widget voiceLoader({required BuildContext context}) {
    return Container(
      height: 74,
      width: MediaQuery.of(context).size.width / 1.5,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      // padding: EdgeInsets.symmetric(vertical: 10),
      // width: ,
      margin: const EdgeInsets.symmetric(vertical: 4),
      // color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Transform.scale(
              scale: 0.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CircularProgressIndicator(
                  color: AppColors.defaultColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 2.6,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                        inactiveColor: Colors.grey.withOpacity(0.4),
                        min: 0,
                        max: 0.0,
                        value: 0.0,
                        onChanged: (val) {}),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "",
                        style:
                            TextStyle(color: Color(0xffA8A196), fontSize: 12),
                      ),
                      // Text(
                      //   formatTime(duration),
                      //   style: const TextStyle(color: Colors.white),
                      // )
                      Padding(
                        padding:
                            EdgeInsets.only(right: 10.0, top: 0.0, bottom: 0.0),
                        child: Text(
                          "00:00",
                          style:
                              TextStyle(color: Color(0xffA8A196), fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //message end code
  static Future<void> messageEndScroll(ScrollController controller) {
    return controller.animateTo(
      controller.position.maxScrollExtent * 1.2,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }

  ///format date and time
  static String formatFirebaseTimestamp(Timestamp timestamp) {
    try {
      DateTime now = DateTime.now();
      DateTime dateTime = timestamp.toDate();

      // Calculate the difference in days
      int differenceInDays = now.difference(dateTime).inDays;

      String formattedDateTime;
      if (differenceInDays == 0) {
        // Display time in AM/PM format
        // formattedDateTime = DateFormat.jm().format(dateTime);
        formattedDateTime = DateFormat.jm().format(dateTime);
      } else if (differenceInDays == 1) {
        // formattedDateTime = 'Yesterday at ${DateFormat.jm().format(dateTime)}';
        formattedDateTime = 'Yesterday';
      } else if (differenceInDays < 7) {
        // Display "X days ago" format
        // formattedDateTime =
        //     '$differenceInDays days ago at ${DateFormat.jm().format(dateTime)}';
        formattedDateTime = '$differenceInDays days ago';
      } else {
        // Display the date in "dd/MM/yyyy" format for dates more than 7 days ago
        formattedDateTime = DateFormat('dd/MM/yyyy').format(dateTime);
      }

      return formattedDateTime;
    } catch (e) {
      if (kDebugMode) {
        print("Error formatting date and time: $e");
      }
      return 'Error formatting date and time';
    }
  }

  static String firebaseTimestampSingleMsg(DateTime timestamp) {
    try {
      DateTime now = DateTime.now();
      DateTime dateTime = timestamp;

      // Calculate the difference in days
      int differenceInDays = now.difference(dateTime).inDays;

      String formattedDateTime;
      if (differenceInDays == 0) {
        // Display time in AM/PM format
        // formattedDateTime = DateFormat.jm().format(dateTime);
        formattedDateTime = DateFormat.jm().format(dateTime);
      } else if (differenceInDays == 1) {
        // formattedDateTime = 'Yesterday at ${DateFormat.jm().format(dateTime)}';
        formattedDateTime = 'Yesterday';
      } else if (differenceInDays < 7) {
        // Display "X days ago" format
        // formattedDateTime =
        //     '$differenceInDays days ago at ${DateFormat.jm().format(dateTime)}';
        formattedDateTime = '$differenceInDays days ago';
      } else {
        // Display the date in "dd/MM/yyyy" format for dates more than 7 days ago
        // formattedDateTime = DateFormat('dd/MM/yyyy').format(dateTime);
        formattedDateTime = '$differenceInDays D';
      }
      return formattedDateTime;
    } catch (e) {
      if (kDebugMode) {
        print("Error formatting date and time: $e");
      }
      return 'Error formatting date and time';
    }
  }

  ///set method for audio player new screen
  static Widget showAudioScreen(BuildContext context, String url) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.09,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: AudioPlayerScreen(
        source: url,
      ),
    );
  }

  ///set time
  static String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final senonds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      senonds,
    ].join(':');
  }

  ///scroll to end
  void scrollToEnd(ScrollController controller) {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}
//get phone contact code
// return ListTile(
//   onTap: () async {
//     // print(contact.id);
//     await launch(
//         "sms:+92${contact.phones.first.toString().substring(1)}?body=Let's chat on MaanApp! It's a fast, simple, and secure app we can use to message and Bob call each other for free.");
//   },
//   leading: CircleAvatar(
//     backgroundColor: color.withOpacity(0.75),
//     radius: 22,
//     child: Text(
//       contact.displayName.toString().substring(0, 1),
//       style: const TextStyle(
//           fontSize: 22, color: Colors.white),
//     ),
//     // backgroundImage: contact.,
//   ),
//   title: Text(
//     contact.displayName,
//     style: const TextStyle(fontWeight: FontWeight.w500),
//   ),
//   subtitle: Padding(
//     padding: const EdgeInsets.symmetric(
//         vertical: 8.0, horizontal: 4),
//     child: Text(
//       contact.phones[0],
//       style: const TextStyle(fontSize: 14),
//     ),
//   ),
//   trailing: Text(
//     "Invite",
//     style: TextStyle(
//         color: AppColors.defaultColor,
//         // fontStyle: FontStyle.italic,
//         fontSize: 16),
//   ),
// );

//voice message chat
// Container(
//   height: 74,
//   width: MediaQuery.of(context).size.width / 1.5,
//   decoration: BoxDecoration(
//       color: index % 2 == 0
//           ? AppColors.whiteColor
//           : AppColors.defaultColor,
//       borderRadius: BorderRadius.circular(15)),
//   // padding: EdgeInsets.symmetric(vertical: 10),
//   // width: ,
//   margin: const EdgeInsets.symmetric(vertical: 4),
//   // color: Colors.black,
//   child: Row(
//     mainAxisAlignment: index % 2 == 0
//         ? MainAxisAlignment.end
//         : MainAxisAlignment.start,
//     children: [
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.only(right: 10,bottom: 12),
//           child: IconButton(
//               iconSize: 35,
//               onPressed: () async {
//                 if (isPlaying) {
//                   await audioPlayer.pause();
//                 } else {
//                   await audioPlayer.resume();
//                 }
//               },
//               icon: Icon(isPlaying
//                   ? Icons.pause
//                   : Icons.play_arrow),
//               color: Colors.grey),
//         ),
//       ),
//       Expanded(
//         flex: 5,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment:
//               CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: SliderTheme(
//                 data: const SliderThemeData(
//                   trackHeight: 2.6,
//                   thumbShape: RoundSliderThumbShape(
//                       enabledThumbRadius: 6),
//                 ),
//                 child: Slider(
//                     inactiveColor:
//                         Colors.grey.withOpacity(0.4),
//                     min: 0,
//                     max: duration.inSeconds.toDouble(),
//                     value:
//                         position.inSeconds.toDouble(),
//                     onChanged: (val) async {
//                       final position = Duration(
//                           seconds: val.toInt());
//                       await audioPlayer.seek(position);
//                       ///if audio player paused
//                       await audioPlayer.resume();
//                     }),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 20,right: 20),
//               child: Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween,
//                 children:  [
//                   Text(formatTime(position),
//                     style: const TextStyle(
//                         color: Color(0xffA8A196),
//                         fontSize: 12),
//                   ),
//                   // Text(
//                   //   formatTime(duration),
//                   //   style: const TextStyle(color: Colors.white),
//                   // )
//                  const Padding(
//                     padding:
//                         EdgeInsets.only(right: 10.0,top: 0.0,bottom: 0.0),
//                     child: Text(
//                       '9:13 AM',
//                       style: TextStyle(
//                           color: Color(0xffA8A196),
//                           fontSize: 12),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// ),
var img =
    "https://firebasestorage.googleapis.com/v0/b/workapp-d4e73.appspot.com/o/profileImage%20%2F%20871e0ed6-b4b5-486c-8a43-9e936e6c8555?alt=media&token=d0883967-97ae-4d6d-ae1d-ebc2a1a810f3";
