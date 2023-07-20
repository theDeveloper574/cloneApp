import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:maanaap/controllers/get_method_controllers.dart';
import 'package:maanaap/controllers/services/database_collection.dart';
import 'package:maanaap/controllers/sign_up_controller.dart';
import 'package:maanaap/main.dart';
import 'package:maanaap/model/userModel.dart';
import 'package:maanaap/res/colors.dart';
import 'package:maanaap/utils/routes/routes_name.dart';
import 'package:maanaap/utils/utils.dart';
import 'package:maanaap/widgets/call_info_detail_wid.dart';
import 'package:maanaap/widgets/circle_image_widget.dart';
import 'package:maanaap/widgets/show_profile_img_wid.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  GetMethodController pathVal = GetMethodController();
  SignUpController pathCon = SignUpController();

  // TextEditingController nameEdit = TextEditingController();

  @override
  void initState() {
    pathVal.getCurrentUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Obx(() {
            return StreamBuilder<DocumentSnapshot>(
              stream: pathVal.userDataSnapshot(pathVal.uid.value),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AppUtils.sizedBox(0.0, 0.0);
                } else if (snapshot.hasError) {
                  return const Text('loading ....');
                } else {
                  UserModel user = UserModel.fromFirestore(snapshot.data);
                  return Center(
                    child: Column(
                      children: [
                        AppUtils.sizedBox(70.0, 0.0),
                        Hero(
                          tag: "show-profile-picture",
                          child: CircleImageWidget(
                            onProfileChangeTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShowProfileImgWid(
                                    image: user.imageUrl,
                                  ),
                                ),
                              );
                            },
                            onImageChangeTap: () {
                              Get.defaultDialog(
                                  buttonColor: AppColors.defaultColor,
                                  title: 'Get Image From',
                                  middleText: 'Camera OR Gallery',
                                  textConfirm: 'Gallery',
                                  confirmTextColor: Colors.white,
                                  textCancel: 'Camera',
                                  cancelTextColor: AppColors.defaultColor,
                                  onCancel: () async {
                                    print('pick image from camera');
                                    // Navigator.pop(context);
                                    await pathCon.pickImageCam();

                                    ///set profile storage
                                    UploadTask uploadTask = changeProfileImgRef
                                        .putFile(File(pathCon.imagePath.value));
                                    await Future.value(uploadTask);
                                    var profileUrl = await changeProfileImgRef
                                        .getDownloadURL();
                                    pathVal.updateCurrentData(
                                        userId: user.userId,
                                        updateField: {
                                          "profileUrl": profileUrl
                                        });
                                  },
                                  onConfirm: () async {
                                    print('pick image from gallery');
                                    Navigator.pop(context);
                                    await pathCon.pickImageGall();

                                    ///set profile storage
                                    UploadTask uploadTask = changeProfileImgRef
                                        .putFile(File(pathCon.imagePath.value));
                                    await Future.value(uploadTask);
                                    var profileUrl = await changeProfileImgRef
                                        .getDownloadURL();
                                    pathVal.updateCurrentData(
                                        userId: user.userId,
                                        updateField: {
                                          "profileUrl": profileUrl
                                        });
                                  });
                            },
                            imageProvider:
                                user.imageUrl == null || user.imageUrl.isEmpty
                                    ? AssetImage('asset/loader_image.gif')
                                    : CachedNetworkImageProvider(user.imageUrl) as ImageProvider,
                          ),
                        ),
                        AppUtils.sizedBox(40.0, 0.0),
                        ProfileWidget(
                          imageProvider: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Icon(Icons.person),
                          ),
                          onListTap: () {
                            AppUtils.setBottomSheet(
                                maxLength: 15,
                                context: context,
                                addText: "Enter your name",
                                initialVal: user.name,
                                onChanged: (val) {
                                  // print(val);
                                  pathVal.textFieldVal.value = val;
                                },
                                onSave: () {
                                  if (pathVal.textFieldVal.value == null ||
                                      pathVal.textFieldVal.value.isEmpty) {
                                    flutterToast(
                                        message: "Name can't be empty");
                                  } else if (pathVal.textFieldVal.value.length <
                                      4) {
                                    flutterToast(
                                        message: "Name can't be less than 4");
                                  } else {
                                    print(pathVal.textFieldVal.value);
                                    pathVal.updateCurrentData(
                                        userId: user.userId,
                                        updateField: {
                                          "name": pathVal.textFieldVal.value
                                        });
                                    Navigator.pop(context);
                                  }
                                });
                          },
                          nameTitle: "Name",
                          about: user.name,
                          audioCallWid: Icon(
                            Icons.edit,
                            color: AppColors.defaultColor,
                            size: 22,
                          ),
                          videoCallWid: AppUtils.sizedBox(0.0, 0.0),
                        ),
                        ProfileWidget(
                          imageProvider: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Icon(Icons.warning),
                          ),
                          onListTap: () {
                            AppUtils.setBottomSheet(
                                maxLength: 40,
                                context: context,
                                addText: "Add about",
                                initialVal: user.about,
                                onChanged: (val) {
                                  pathVal.textFieldVal.value = val;
                                },
                                onSave: () {
                                  print(pathVal.textFieldVal.value);
                                  pathVal.updateCurrentData(
                                      userId: user.userId,
                                      updateField: {
                                        "about": pathVal.textFieldVal.value
                                      });
                                  Navigator.pop(context);
                                });
                          },
                          nameTitle: "About",
                          about: user.about,
                          audioCallWid: Icon(
                            Icons.edit,
                            color: AppColors.defaultColor,
                            size: 22,
                          ),
                          videoCallWid: AppUtils.sizedBox(0.0, 0.0),
                        ),
                        ProfileWidget(
                          imageProvider: const Padding(
                            padding: EdgeInsets.only(top: 22.0),
                            child: Icon(Icons.phone),
                          ),
                          onListTap: () {},
                          nameTitle: "Phone",
                          about: "+92 304 5070559",
                          audioCallWid: AppUtils.sizedBox(0.0, 0.0),
                          videoCallWid: AppUtils.sizedBox(0.0, 0.0),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          })
        ],
      ),
    );
  }
}
