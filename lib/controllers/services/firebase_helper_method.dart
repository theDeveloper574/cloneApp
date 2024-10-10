import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maanaap/model/user_data_model.dart';

class FirebaseHelper {
  static Future<UserDataModel?> getUserModById(String uid) async {
    UserDataModel? userDataModel;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(uid)
        .get();
    if (snapshot.data() != null) {
      userDataModel =
          UserDataModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return userDataModel;
  }

  static Future setStatus(String status, String uid) async {
    await FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(uid)
        .update({"status": status});
  }
}
