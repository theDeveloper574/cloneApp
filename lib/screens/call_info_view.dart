



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'package:maanaap/utils/utils.dart';
import 'package:maanaap/widgets/call_info_detail_wid.dart';

class CallInfoView extends StatefulWidget {
  const CallInfoView({Key? key}) : super(key: key);

  @override
  State<CallInfoView> createState() => _CallInfoViewState();
}

class _CallInfoViewState extends State<CallInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Call info"),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pushNamedAndRemoveUntil(context, RouteName.home, (route) => false);
            },
              child: const Icon(Icons.chat)),
          AppUtils.sizedBox(0.0, 10.0),
          PopupMenuButton(
            padding: EdgeInsets.zero,
            constraints:const BoxConstraints.expand(width: 190,height: 110),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Remove from call log"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Block"),
                  ),
                ];
              },
              onSelected: (val) {
                // if(val=="1"){
                FocusManager.instance.primaryFocus!.unfocus();
                // }
              }),
          AppUtils.sizedBox(0.0, 2.0),
        ],
      ),
      body: Column(
        children: [
          CallInfoDetailAndProfileWidget(
            onListTap: (){},
            nameTitle: "Nauman",
            about: "Hello, I'm using MaanApp",
            imageProvider:const CircleAvatar(
              backgroundImage: AssetImage("asset/signup.png"),
              radius: 24,
            ),
            audioCallWid:  Icon(
              Icons.phone,
              color: AppColors.defaultColor,
            ),
            videoCallWid: Icon(
              Icons.video_camera_back,
              color: AppColors.defaultColor,
            ),
          ),
          Divider(indent: 80,height: 0.0,color: AppColors.defaultColor.withOpacity(0.2),thickness: 0.8,),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.call_made,color: AppColors.defaultColor,),
            ),
            title: const Text("Outgoing",style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54
            ),),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.call,size: 18,),
                AppUtils.sizedBox(0.0, 12.0),
                const Text("5:34 pm")
              ],
            ),
            trailing: const Text("Not answered",style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black45
            ),),
          )
        ],
      ),
    );
  }
}
