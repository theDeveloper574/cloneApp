import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'package:maanaap/widgets/chat_list_wid.dart';
class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
            (context, index) {
          return ChatListAndCallWidget(
            onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (_)=>const SingleChatView()));
              Navigator.of(context, rootNavigator: true).pushNamed(RouteName.singleChatView);
              // Navigator.pushNamed(context,RouteName.singleChatView);
            },
            userName: "Shani",
            iconWidget: const Icon(Icons.done_all,color: Colors.blue,size: 18,),
            msgOrCallTime: "hey noman",
            widget: Text(
              "12:13",
              style: GoogleFonts.asap(),
            ),
          );
        },
      ),
    );
  }
}