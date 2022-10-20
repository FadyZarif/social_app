class MessageModel {
  String? senderId;
  String? receiverId;
  String? message;
  String? dateTime;
  bool? isSeen;


  MessageModel({
    this.senderId,
    this.receiverId,
    this.message,
    this.dateTime,
    this.isSeen,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = json['message'];
    dateTime = json['dateTime'];
    isSeen = json['isSeen'];
    }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'message': message,
      'isSeen': isSeen,
    };
  }
}
