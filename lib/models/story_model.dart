import 'package:social_app/models/user_model.dart';



class StoryModel {
  String? url;
  String? caption;
  String? startTime;
  String? endTime;


  StoryModel({
    this.url,
    this.caption,
    this.startTime,
    this.endTime,
  });

  StoryModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    caption = json['caption'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'caption': caption,
      'startTime': startTime,
      'endTime': endTime,

    };
  }
}