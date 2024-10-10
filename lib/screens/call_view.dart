import 'package:flutter/material.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'package:maanaap/widgets/chat_list_wid.dart';

class CallView extends StatelessWidget {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) {
          return ChatListAndCallWidget(
            imageProfile:
                'https://firebasestorage.googleapis.com/v0/b/workapp-d4e73.appspot.com/o/newProfileImage%20%2F%20aeba8699-7602-4b75-b517-f0ddaa99c8f2?alt=media&token=5bb647cd-6ab4-4c8e-8d87-1f3734028610',
            iconWidget: const Icon(
              Icons.call_received,
              color: Colors.red,
              size: 18,
            ),
            msgOrCallTime: "49 minutes ago",
            userName: "Tasawer",
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(RouteName.callInfoView);
              // Navigator.pushNamed(context, RouteName.callInfoView);
            },
            widget: Icon(
              Icons.phone,
              color: AppColors.defaultColor,
            ),
          );
        },
      ),
    );
  }
}
