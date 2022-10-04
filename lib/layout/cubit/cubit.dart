import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:social_app/styles/icon_broken.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(error.toString());
      emit(SocialGetUserErrorState(error.message));
    });
  }

  int currentIndex = 0;
  List<BottomNavigationBarItem> BottomNavItems = [
    BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(IconBroken.Chat), label: 'Chat'),
    BottomNavigationBarItem(icon: Icon(IconBroken.Upload), label: 'Post'),
    BottomNavigationBarItem(icon: Icon(IconBroken.User), label: 'User'),
    BottomNavigationBarItem(icon: Icon(IconBroken.Setting), label: 'Setting'),
  ];
  List<Widget> screensList = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titlesList = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int i) {
    if (i == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = i;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;
  ImagePicker picker = ImagePicker();

  Future<void> getProfileImage() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImgPickedSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialProfileImgPickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImgPickedSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialCoverImgPickedErrorState());
    }
  }

  String? profileImgUrl;

  Future<void> uploadProfileImage() async {
    emit(SocialProfileImgUploadLoadingState());
    return await FirebaseStorage.instance
        .ref()
        .child(
        'users/profile/${Uri
            .file(profileImage!.path)
            .pathSegments
            .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImgUrl = value;
        FirebaseFirestore.instance
            .collection('users')
            .doc(userModel!.uId)
            .update({
          'image': profileImgUrl ?? userModel?.image,
        })
            .then((value) {})
            .catchError((error) {});
        emit(SocialProfileImgUploadSuccessState());
      }).catchError((error) {
        print('xxxxxxxxxxxxxxxxxxxxxxxxxx');
        print(error.toString());
        emit(SocialProfileImgUploadErrorState());
      });
    }).catchError((error) {
      print('xxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(error.toString());
      emit(SocialProfileImgUploadErrorState());
    });
  }

  String? coverImgUrl;

  Future<void> uploadCoverImage() async {
    emit(SocialCoverImgUploadLoadingState());
    return await FirebaseStorage.instance
        .ref()
        .child('users/cover/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImgUrl = value;
        FirebaseFirestore.instance
            .collection('users')
            .doc(userModel!.uId)
            .update({
          'cover': coverImgUrl ?? userModel?.cover,
        })
            .then((value) {})
            .catchError((error) {});
        emit(SocialCoverImgUploadSuccessState());
      }).catchError((error) {
        print('xxxxxxxxxxxxxxxxxxxxxxxxxx');
        print(error.toString());
        emit(SocialCoverImgUploadErrorState());
      });
    }).catchError((error) {
      print('xxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(error.toString());
      emit(SocialCoverImgUploadErrorState());
    });
  }

  void updateUser({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(SocialUserUpdateLoadingState());
    if (profileImage == null && coverImage == null) {
      userUpdateDate(name: name, bio: bio, phone: phone);
    } else if (profileImage != null && coverImage != null) {
      uploadProfileImage().then((value) {
        uploadCoverImage().then((value) {
          userUpdateDate(name: name, bio: bio, phone: phone);
        });
      });
    } else if (profileImage != null) {
      uploadProfileImage().then((value) {
        userUpdateDate(name: name, bio: bio, phone: phone);
      });
    } else if (coverImage != null) {
      uploadCoverImage().then((value) {
        userUpdateDate(name: name, bio: bio, phone: phone);
      });
    }
  }

  void userUpdateDate({
    required String name,
    required String bio,
    required String phone,
  }) {
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).update({
      'name': name,
      'bio': bio,
      'phone': phone,
      'image': profileImgUrl ?? userModel?.image,
      'cover': coverImgUrl ?? userModel?.cover,
    }).then((value) {
      getUserData();
    }).catchError((error) {});
  }

  File? postImage;

  Future<void> getPostImage() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImgPickedSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialPostImgPickedErrorState());
    }
  }

  Future<void> deletePostImage() async {
    if (postImage != null) {
      postImage = null;
      emit(SocialPostImgDeletedSuccessState());
    } else {
      print('No Image');
      emit(SocialPostImgDeletedErrorState());
    }
  }


  void createNewPost({String? postText}) {

    emit(SocialCreatePostLoadingState());

     if(postImage != null) {
      FirebaseStorage.instance.ref()
        .child('posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        PostModel postModel = PostModel(
            image: userModel?.image,
            uId: userModel?.uId,
            name: userModel?.name,
            dateTime: DateTime.now().toString(),
            postImage: value,
            postText: postText);
        FirebaseFirestore.instance.collection('posts').add(postModel.toMap()).then((value) {
          emit(SocialCreatePostSuccessState());
        }).catchError((error){
          print('xxxxxxxxxxxxxxxx');
          emit(SocialCreatePostErrorState());
        });
      });
    });
    }
    else{
      PostModel postModel = PostModel(
          image: userModel?.image,
          uId: userModel?.uId,
          name: userModel?.name,
          dateTime: DateTime.now().toString(),
          postText: postText);
      FirebaseFirestore.instance.collection('posts').add(postModel.toMap()).then((value) {
        emit(SocialCreatePostSuccessState());
      }).catchError((error){
        print('xxxxxxxxxxxxxxxx');
        emit(SocialCreatePostErrorState());
      });
    }

  }

  List<PostModel> posts = [];

  void getPosts(){
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
      posts = [];
      event.docs.forEach((element) {
         posts.add(PostModel.fromJson(element.data())) ;

      });
      posts.sort((a, b) => b.dateTime!.compareTo(a.dateTime!),);
      emit(SocialGetPostSuccessState());
    });

    /*FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        posts.add(PostModel.fromJson(element.data()));
      });
      emit(SocialGetPostSuccessState());
    }).catchError((error){
      print('xxxxxxxxxxxxxxxxxx');
      print(error.toString());
      emit(SocialGetPostErrorState());
    });*/

  }
}
