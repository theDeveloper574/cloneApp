import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maanaap/controllers/services/database_collection.dart';
import 'package:maanaap/model/userModel.dart';
import 'package:maanaap/utils/utils.dart';
import '../utils/routes/routes_name.dart';

class SignUpController extends GetxController {
  // XFile? image;
  RxString imagePath = "".obs;
  RxBool isLogInSeen = true.obs;
  RxBool isSignUPSeen = true.obs;
  // XFile? img;
  RxBool isLoad = false.obs;
  RxBool isLogin = false.obs;

  bool get loading => isLoad.value;

  bool get login => isLogin.value;
  final _firebaseStorage = FirebaseStorage.instance;

  //firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //show password for login
  void isLoginShow(){
    isLogInSeen.value =! isLogInSeen.value;
    print(isLogInSeen.value);
    update();
  }
  //show password for sign up
  void isSignUpShow(){
    isSignUPSeen.value =! isSignUPSeen.value;
    print(isLogInSeen.value);
    update();
  }
  ///image pick from gallery
  Future pickImageGall() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      imagePath.value = img.path.toString();
      print('image path');
      print('image path');
      print('image path');
      print(imagePath.toString());
      print('image path');
      print('image path');
      print('image path');
    } else {
      print('no image selected');
      // AppUtils.showFlushBar(context, message,FlushbarPosition.Top);
    }
  }

  ///image pick from camera
  Future pickImageCam() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    if (img != null) {
      imagePath.value = img.path.toString();
      print('image path');
      print('image path');
      print('image path');
      print(imagePath.toString());
      print('image path');
      print('image path');
      print('image path');
    } else {
      print('no image selected');
    }
  }

  ///sign up user from firebase
  ///load button for sign up
  setLoading(bool value) {
    isLoad.value = value;
    update();
  }

  ///load button for login
  setLogInLoad(bool value) {
    isLogin.value = value;
    update();
  }

  ///create user with email and password
  Future setUser(
      {required String email,
      required String password,
      required BuildContext context,
      required String name,
      required String chatId}) async {
    try {
      setLoading(true);
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.home, (route) => false);

      ///set profile storage
      UploadTask uploadTask = profileImgRef.putFile(File(imagePath.value));
      await Future.value(uploadTask);

      ///image profile url
      var profileUrl = await profileImgRef.getDownloadURL();

      ///set user profile model
      UserModel user = UserModel(
          name: name,
          email: email,
          password: password,
          imageUrl: profileUrl,
          userId: docId,
          about: "Hey there! I am using MaanApp.",
          chatId: chatId,
        isBlock: false
      );
      ///upload to database
      await userDatabase.doc(docId).set(user.toMap());
      await setLoading(false);
    } on FirebaseException catch (e) {
      setLoading(false);
      AppUtils.showFlushBar(context, e.message.toString());
      // print(e.message.toString());
    }
  }

  ///sign in user with email and password
  Future signInUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      setLogInLoad(true);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.home, (route) => false);
      setLogInLoad(false);
    } on FirebaseException catch (e) {
      setLogInLoad(false);
      AppUtils.showFlushBar(context, e.message.toString());
      // print(e.message.toString());
    }
  }
}
//Stream<QuerySnapshot> userSnapshot =
//     FirebaseFirestore.instance.collection('users').snapshots();
//
// userSnapshot.listen((snapshot) {
//   List<User> users = snapshot.docs
//       .map((doc) => User.fromFirestore(doc))
//       .toList();
//
//   // Do something with the retrieved users
// });
