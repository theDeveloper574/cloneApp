import 'package:flutter/material.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'package:maanaap/widgets/chat_list_wid.dart';

class CallView extends StatelessWidget {
  const CallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
            (context, index) {
          return ChatListAndCallWidget(
            iconWidget:const Icon(Icons.call_received,color: Colors.red,size: 18,),
            msgOrCallTime: "49 minutes ago",
            userName: "Tasawer",
            onTap: (){
              Navigator.of(context,rootNavigator: true).pushNamed(RouteName.callInfoView);
              // Navigator.pushNamed(context, RouteName.callInfoView);
            },
            widget: Icon(Icons.phone,color: AppColors.defaultColor,),
          );
        },
      ),
    );
  }
}