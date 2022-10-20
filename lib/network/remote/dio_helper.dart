
import 'package:dio/dio.dart';

class DioHelper{

  static Dio? dio;
  static init(){

    dio = Dio(
        BaseOptions(
            baseUrl: 'https://fcm.googleapis.com/fcm/',
            receiveDataWhenStatusError: true,
            headers: {
              'Content-Type':'application/json',
              'Authorization' : 'key=AAAAx-aOIh4:APA91bF4s96Xs077-C5BpllNr6to8sjW2r-opfZoPJBqsRinHNXeH4YpqJVeipbF9WhGfGrFJn_lOkXeNXAbhtcjt-5kEfrSzTtX5nTP2GDnqeGonc6xyNnu9uzDPIOUf2gWAGbYd0mR',
            },
        )
    );

  }

  // static Future<Response> getData({
  //   required String url ,
  //   Map<String,dynamic>? query,
  //   String lang = 'en',
  //   String? token
  // })
  // async{
  //   dio?.options.headers = {
  //     'Content-Type':'application/json',
  //     'lang' : lang,
  //     'Authorization' : token??''
  //   };
  //   return await dio!.get(url,queryParameters: query);
  // }

  static Future<Response> sendNotification({
    required String? token,
    required String? title,
    required String? body,
    required String? image,
  })
  async{

    return await dio!.post(
        'send',
        data: {
          "to":token,
          "notification" : {
            "title" : title,
            "body" : body,
            "image": image,
            "sound" : "default"
          },
          "android":{
            "priority":"HIGH",
            "notification":{
              "notification_priority":"PRIORITY_MAX",
              "sound":"default",
              "default_sound":true,
              "default_vibrate_timings":true,
              "default_light_settings":true
            }
          },
          "data":{
            "type":"order",
            "id":"87",
            "click_action":"FLUTTER_NOTIFICATION_CLICK"
          }
        },
    );
  }

}