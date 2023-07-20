import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maanaap/controllers/services/database_collection.dart';
import 'package:maanaap/model/userModel.dart';

class GetMethodController extends GetxController {
  // RxString name = "".obs;
  // RxString profileUrl = "".obs;
  RxString uid = "".obs;
  RxString textFieldVal ="".obs;
  // UserModel? userModel;

  Future getCurrentUserId()async{
    final User user = FirebaseAuth.instance.currentUser!;
     uid.value = user.uid.toString();
    print(uid);
    update();
  }
  Stream<DocumentSnapshot> userDataSnapshot(String docId){
    return FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(docId)
        .snapshots();
  }

  ///update data users and others funcation
  Future updateCurrentData({required Map<String,dynamic> updateField,required String userId})async{
    await FirebaseFirestore.instance.collection('usersProfile').doc(userId).update(updateField);
    // update();
  }
}
