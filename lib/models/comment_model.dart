class CommentModel{

  String? img;
  String? name;
  String? comment;
  String? dateTime;

  CommentModel({
    this.img,
    this.name,
    this.comment,
    this.dateTime,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    name = json['name'];
    comment = json['comment'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'img': img,
      'comment': comment,
      'dateTime': dateTime,
    };
  }

}