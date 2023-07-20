

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:maanaap/screens/sign_up_view.dart';


///firebase profile storage
firebase_storage.Reference profileImgRef =
firebase_storage.FirebaseStorage.instance.ref('profileImage / $imagePostId');
///firebase change profile image
firebase_storage.Reference changeProfileImgRef =
firebase_storage.FirebaseStorage.instance.ref('newProfileImage / $imagePostId');
///current user doc id
final docId = FirebaseAuth.instance.currentUser!.uid;

///database for user profile
final userDatabase = FirebaseFirestore.instance.collection('usersProfile');
