class UserModel {
  String? name;
  String? email;
  String? password;
  String? uId;
  String? phone;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;
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
    this.isEmailVerified,
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
    isEmailVerified = json['isEmailVerified'];
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
      'isEmailVerified': isEmailVerified,
      'photos': photos,
    };
  }
}
