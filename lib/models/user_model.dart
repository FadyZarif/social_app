class UserModel {
  String? name;
  String? email;
  String? password;
  String? uId;
  String? phone;
  String? image;
  String? cover;
  String? bio;
  String? token;
  bool? isOnline;
  List<String?>? photos=[];

  UserModel({
    this.name,
    this.email,
    this.password,
    this.uId,
    this.phone,
    this.image,
    this.cover,
    this.bio,
    this.token,
    this.isOnline,
    this.photos,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    uId = json['uId'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    token = json['token'];
    isOnline = json['isOnline'];
    json['photos'].forEach((e){
      photos?.add(e);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'uId': uId,
      'phone': phone,
      'image': image,
      'cover': cover,
      'bio': bio,
      'token': token,
      'isOnline': isOnline,
      'photos': photos,
    };
  }
}
