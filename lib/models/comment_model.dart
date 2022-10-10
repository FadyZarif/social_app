class CommentModel{

  String? uId;
  String? comment;
  String? dateTime;

  CommentModel({
    this.uId,
    this.comment,
    this.dateTime,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    comment = json['comment'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'comment': comment,
      'dateTime': dateTime,
    };
  }

}