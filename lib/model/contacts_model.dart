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
  // Add more fields as needed

  UserModel(
      {required this.name,
      required this.email,
      required this.password,
      required this.imageUrl,
      required this.about,
      required this.chatId,
      required this.userId,
      required this.isBlock});

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        name: data['name'] ?? '',
        password: data['password'] ?? '',
        email: data['email'] ?? '',
        isBlock: data['isBlock'] ?? '',
        userId: data['userId'] ?? '',
        chatId: data['chatId'] ?? '',
        about: data['about'] ?? '',
        imageUrl: data['profileUrl'] ?? '');
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "password": password,
      "email": email,
      "isBlock": isBlock,
      "userId": userId,
      "chatId": chatId,
      "about": about,
      "profileUrl": imageUrl
    };
  }
}
