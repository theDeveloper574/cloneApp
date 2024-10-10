import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:maanaap/screens/sign_up_view.dart';

///firebase storage profile storage
firebase_storage.Reference profileImgRef = firebase_storage
    .FirebaseStorage.instance
    .ref('profileImage / $imagePostId');

///firebase storage change profile image
firebase_storage.Reference changeProfileImgRef = firebase_storage
    .FirebaseStorage.instance
    .ref('newProfileImage / $imagePostId');

///firebase storage send chat images
firebase_storage.Reference chatImages = firebase_storage
    .FirebaseStorage.instance
    .ref('chatImages / ${DateTime.now().toIso8601String()}');

///voice urls images

firebase_storage.Reference chatVoices = firebase_storage
    .FirebaseStorage.instance
    .ref('chatVoices / ${DateTime.now().toIso8601String()}');

///current user doc id
final docId = FirebaseAuth.instance.currentUser!.uid;

///database collection for user profile
final userDatabase = FirebaseFirestore.instance.collection('usersProfile');

///database collection chat screen
final chatImage = FirebaseFirestore.instance.collection('usersProfile');
