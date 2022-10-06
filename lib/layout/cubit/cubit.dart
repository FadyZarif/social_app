import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
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
      getPosts();
      getAllUsers();
      getAllChats();
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
            'users/profile/${Uri.file(profileImage!.path).pathSegments.last}')
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
        .child('users/cover/${Uri.file(coverImage!.path).pathSegments.last}')
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

    if (postImage != null) {
      FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
          .putFile(postImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          PostModel postModel = PostModel(
            image: userModel?.image,
            uId: userModel?.uId,
            name: userModel?.name,
            dateTime: DateTime.now().toString(),
            postImage: value,
            postText: postText,
          );
          FirebaseFirestore.instance
              .collection('posts')
              .add(postModel.toMap())
              .then((value) {
            emit(SocialCreatePostSuccessState());
          }).catchError((error) {
            print('xxxxxxxxxxxxxxxx');
            emit(SocialCreatePostErrorState());
          });
        });
      });
    } else {
      PostModel postModel = PostModel(
        image: userModel?.image,
        uId: userModel?.uId,
        name: userModel?.name,
        dateTime: DateTime.now().toString(),
        postText: postText,
      );
      FirebaseFirestore.instance
          .collection('posts')
          .add(postModel.toMap())
          .then((value) {
        emit(SocialCreatePostSuccessState());
      }).catchError((error) {
        print('xxxxxxxxxxxxxxxx');
        emit(SocialCreatePostErrorState());
      });
    }
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<bool> isLiked = [];

  void getPosts() {
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
      posts = [];
      postsId = [];
      isLiked = [];
      event.docs.forEach((element) {
        posts.add(PostModel.fromJson(element.data()));
        var x = posts.last.likes?.where((e) => e.toString() == userModel?.uId);
        if (x?.isEmpty ?? true) {
          isLiked.add(false);
        } else {
          isLiked.add(true);
        }
        postsId.add(element.id);
      });
      /*print(isLiked);
      print(posts[0].fav?[0].id);
      posts[0].fav?[0]?.get().then((value) {
        print(value.data());
      });*/

      emit(SocialGetPostSuccessState());
    });
  }

  void likePost(String postId, int i) {
    if (isLiked[i] == false) {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([
          //FirebaseFirestore.instance.collection('users').doc(userModel?.uId)
          userModel?.uId
        ])
      });
    } else {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([
          //FirebaseFirestore.instance.collection('users').doc(userModel?.uId)
          userModel?.uId
        ])
      });
    }
  }

  void writeComment(String postId, int i, String comment) {
    emit(SocialWriteCommentLoadingState());
    CommentModel? commentModel;
    commentModel = CommentModel(
        name: userModel?.name,
        img: userModel?.image,
        dateTime: DateTime.now().toString(),
        comment: comment);
    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([commentModel.toMap()])
    }).then((value) {
      emit(SocialWriteCommentSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialWriteCommentErrorState());
    });
  }

  List<UserModel> likersList = [];

  Future<void> getLikers(int i) async {
    emit(SocialGetPostLikersLoadingState());
    likersList = [];
    posts[i].likes?.forEach((element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(element)
          .get()
          .then((value) {
        likersList.add(UserModel.fromJson(value.data()!));
        emit(SocialGetPostLikersSuccessState());
      }).catchError((error) {
        emit(SocialGetPostLikersErrirState());
      });
    });
  }

  List<UserModel> allUsers = [];

  void getAllUsers() {
    emit(SocialGetAllUserLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      allUsers = [];
      event.docs.forEach((element) {
        if (element.data()['uId'] != userModel?.uId) {
          allUsers.add(UserModel.fromJson(element.data()));
        }
      });
      emit(SocialGetAllUserSuccessState());
    });
  }

  List<UserModel> allChats = [];

  void getAllChats() {
    emit(SocialGetAllChatsLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .snapshots()
        .listen((event) {
      allChats = [];
      event.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .get()
            .then((value) {
          allChats.add(UserModel.fromJson(value.data()!));
        });
      });
      emit(SocialGetAllChatsSuccessState());
    });
  }

  void sendMessage(String message, UserModel receiverModel) {
    MessageModel messageModel = MessageModel(
        dateTime: DateTime.now().toString(),
        message: message,
        senderId: userModel?.uId,
        receiverId: receiverModel.uId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverModel.uId)
        .set({'exist' : true}).then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel?.uId)
          .collection('chats')
          .doc(receiverModel.uId)
          .collection('messages')
          .add(messageModel.toMap())
          .then((value) {
        emit(SocialSendMessageSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialSendMessageSuccessState());
      });

    });



    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverModel.uId)
        .collection('chats')
        .doc(userModel?.uId)
        .set({'dummy': 'dummy'}).then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverModel.uId)
          .collection('chats')
          .doc(userModel?.uId)
          .collection('messages')
          .add(messageModel.toMap())
          .then((value) {
        emit(SocialSendMessageSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialSendMessageSuccessState());
      });
    });

  }

  List<MessageModel> messages = [];

  void getMessages(UserModel receiverModel) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverModel.uId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetAllMessagesSuccessState());
    });
  }
}








