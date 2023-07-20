import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String imageUrl;
  final String about;
  final String chatId;
  final String userId;
  final bool isBlock;

  UserModel(
      {required this.name,
      required this.email,
      required this.password,
      required this.imageUrl,
      required this.about,
      required this.chatId,
      required this.userId,
        required this.isBlock
      });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    dynamic data = doc.data();
    return UserModel(
        name: data['name']??"",
        email: data['email']??"",
        password: data['password']??"",
        imageUrl: data['profileUrl']??"",
        about: data['about']??"",
        chatId: data['chatId']??"",
      userId: data['userId']??"",
      isBlock: data['isBlock']??""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'profileUrl': imageUrl,
      'about': about,
      'chatId': chatId,
      'userId': userId,
      'isBlock':isBlock
    };
  }
}
