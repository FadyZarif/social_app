import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/user_model.dart';

class PostModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? postText;
  String? postImage;
  List? likes;
  List? comments;


  PostModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.postText,
    this.postImage,
    this.likes,
    this.comments
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    postText = json['postText'];
    postImage = json['postImage'];
    likes = json['likes'];
    comments = json['comments'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': dateTime,
      'postText': postText,
      'postImage': postImage,
      'likes': likes,
      'comments': comments,
    };
  }
}
