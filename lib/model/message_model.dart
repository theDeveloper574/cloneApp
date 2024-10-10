class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? creation;
  String? image;
  String? voice;
  String? imageText;

  MessageModel(
      {this.messageId,
      this.sender,
      this.text,
      this.seen,
      this.creation,
      this.image,
      this.voice,
      this.imageText});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map['messageId'];
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    creation = map['creation'].toDate();
    image = map['image'];
    voice = map['voice'];
    imageText = map['imageText'];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "creation": creation,
      "image": image,
      "voice": voice,
      "imageText": imageText
    };
  }
}
