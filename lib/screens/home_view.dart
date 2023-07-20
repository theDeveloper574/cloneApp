// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:maanaap/res/colors.dart';
// import 'package:maanaap/utils/routes/routes_name.dart';
// import 'package:maanaap/widgets/chat_list_wid.dart';
//
// class HomeView extends StatefulWidget {
//   const HomeView({Key? key}) : super(key: key);
//
//   @override
//   State<HomeView> createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title:const Text("Maan App"),
//       ),
//       body: ListView.builder(
//         itemCount: 12,
//         itemBuilder: (context,int index){
//           return ChatListWidget(
//             onTap: (){
//               Navigator.pushNamed(context, RouteName.singleChat);
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.defaultColor,
//         onPressed: (){
//           Navigator.pushNamed(context, RouteName.contact);
//         },
//         child:const Icon(Icons.add),
//       ),
//     );
//   }
// }

///whatsp like UI
import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/screens/call_view.dart';
import 'package:maanaap/screens/camera_view.dart';
import 'package:maanaap/screens/status_view.dart';
import 'package:maanaap/utils/utils.dart';
import 'package:maanaap/widgets/chat_list_wid.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/routes/routes_name.dart';
import 'chat_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    // FocusManager.instance.primaryFocus!.unfocus();
    // TODO: implement initState
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController!.addListener(() => _handleTabIndex());

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController!.addListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: const Text("MaanApp"),
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  floating: true,
                  backgroundColor: AppColors.defaultColor,
                  // backgroundColor: Color.fromARGB(255, 4, 94, 84),
                  actions: [
                    const Icon(Icons.search, size: 28, color: Colors.white),
                    const SizedBox(width: 10),
                    PopupMenuButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
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
                          if (val == 1) {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(RouteName.homeSettingsView);
                          }
                        }),
                  ],
                  elevation: 0.0,
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: WhatsappTabs(50.0, _tabController!),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: const [
                CustomScrollView(
                  slivers: [CameraView()],
                ),
                CustomScrollView(
                  slivers: [ChatView()],
                ),
                CustomScrollView(
                  slivers: [StatusView()],
                ),
                CustomScrollView(
                  slivers: [CallView()],
                ),
              ],
            ),
          ),
          floatingActionButton: _tabController!.index == 1
              ? FloatingActionButton(
                  backgroundColor: AppColors.defaultColor,
                  onPressed: () async {
                    // await FirebaseAuth.instance.signOut().then((value) {
                    //   Navigator.pushNamedAndRemoveUntil(context, RouteName.signUp, (route) => false);
                    // });
                   // await getContact();
                    Navigator.pushNamed(context, RouteName.contact);
                  },
                  child: const Icon(Icons.add),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
  Future<List<Contact>> getContact() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      return await FastContacts.allContacts;
    }
    return [];
  }
}

class WhatsappTabs extends SliverPersistentHeaderDelegate {
  final double size;
  TabController controller;

  WhatsappTabs(this.size, this.controller);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.defaultColor,
      // color: const Color.fromARGB(255, 4, 94, 84),
      height: size,
      child: TabBar(
        controller: controller,
        indicatorWeight: 3,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        // isScrollable: true,
        tabs: const <Widget>[
          Tab(icon: Icon(Icons.camera_alt)),
          Tab(text: "Chats"),
          Tab(text: "Status"),
          Tab(text: "Calls"),
        ],
      ),
    );
  }

  @override
  double get maxExtent => size;

  @override
  double get minExtent => size;

  @override
  bool shouldRebuild(WhatsappTabs oldDelegate) {
    return oldDelegate.size != size;
  }
}
