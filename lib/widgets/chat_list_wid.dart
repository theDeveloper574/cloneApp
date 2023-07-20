import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maanaap/screens/single_chat_view.dart';
import 'package:maanaap/utils/utils.dart';

import '../res/colors.dart';
import '../utils/routes/routes_name.dart';

class ChatListAndCallWidget extends StatelessWidget {
  final Function() onTap;
  final Widget iconWidget;
  final String msgOrCallTime;
  final String userName;
  final Widget widget;

  const ChatListAndCallWidget(
      {Key? key,
        required this.iconWidget,
      required this.onTap,
      required this.msgOrCallTime,
      required this.userName,
        required this.widget
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.defaultColor,
        backgroundImage: const AssetImage('asset/signup.png'),
        radius: 24,
        // backgroundImage: contact.,
      ),
      title: Text(userName,
        style: GoogleFonts.roboto(
            textStyle: const TextStyle(fontWeight: FontWeight.w500)),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            AppUtils.sizedBox(0.0, 4.0),
            Text(
              msgOrCallTime,
              style: TextStyle(fontSize: 16, color: AppColors.greyColor,),
            ),
          ],
        ),
      ),
      trailing: widget,
    );
  }
}
