class ChatRoomModel {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? chatTime;
  List<dynamic>? users;

  ChatRoomModel(
      {this.chatRoomId,
      this.participants,
      this.lastMessage,
      this.chatTime,
      this.users});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map['chatroomid'];
    participants = map['participants'];
    lastMessage = map['lastmessage'];
    chatTime = map['chatTime'].toDate();
    users = map['users'];
  }
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatRoomId,
      "participants": participants,
      "lastmessage": lastMessage,
      'chatTime': chatTime,
      'users': users
    };
  }
}
