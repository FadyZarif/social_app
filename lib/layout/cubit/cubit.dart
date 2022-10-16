import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/story_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/modules/view_profile/view_profile_screen.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:story_maker/story_maker.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
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
      imageQuality: 25,
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
      imageQuality: 25,
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
      imageQuality: 25,
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

  void editNewPost(
      {required String postId, required PostModel model, required String postText}) {
    emit(SocialEditPostLoadingState());

    if (postImage != null) {
      FirebaseStorage.instance
          .ref()
          .child('posts/${Uri
          .file(postImage!.path)
          .pathSegments
          .last}')
          .putFile(postImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          model.postImage = value;
          model.postText = postText;
          FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .update(model.toMap())
              .then((value) {
            emit(SocialEditPostSuccessState());
          }).catchError((error) {
            print('xxxxxxxxxxxxxxxx');
            emit(SocialEditPostErrorState());
          });
        });
      });
    } else {
      model.postText = postText;
      FirebaseFirestore.instance

          .collection('posts')
          .doc(postId)
          .update(model.toMap())
          .then((value) {
        emit(SocialEditPostSuccessState());
      }).catchError((error) {
        print('xxxxxxxxxxxxxxxx');
        emit(SocialEditPostErrorState());
      });
    }
  }

  void removePostImage() {
    emit(SocialPostImgRemoveSuccessState());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<bool> isLiked = [];

  void getPosts() {
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance.collection('posts').orderBy(
        'dateTime', descending: true).snapshots().listen((event) {
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
        uId: userModel?.uId,
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

  List<UserModel> commentersList = [];

  Future<void> getCommenters(int i) async {
    emit(SocialGetPostCommentersLoadingState());
    commentersList = [];
    posts[i].comments?.forEach((element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(element['uId'])
          .get()
          .then((value) {
        commentersList.add(UserModel.fromJson(value.data()!));
        emit(SocialGetPostCommentersSuccessState());
      }).catchError((error) {
        emit(SocialGetPostCommentersErrirState());
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
        .set({'exist': true}).then((value) {
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

  void deletePost(int i) {
    FirebaseFirestore.instance.collection('posts').doc(postsId[i]).delete();
  }

  File? pickedPhoto;

  Future<void> addPhotos() async {
    emit(SocialAddPhotosLoadingState());
    List<XFile>? pickedFile = await picker.pickMultiImage(
      imageQuality: 25,
    );
    if (pickedFile != null) {
      pickedFile.forEach((element) {
        pickedPhoto = File(element.path);
        FirebaseStorage.instance.ref()
            .child('photos/${userModel?.name}/${Uri
            .file(pickedPhoto!.path)
            .pathSegments
            .last}')
            .putFile(pickedPhoto!)
            .then((v) {
          v.ref.getDownloadURL().then((value) =>
          {
            FirebaseFirestore.instance
                .collection('users')
                .doc(userModel?.uId)
                .update({
              'photos': FieldValue.arrayUnion([value])
            })
          });
        });
        FirebaseFirestore.instance.collection('users').doc(uId)
            .snapshots()
            .listen((value) {
          userModel = UserModel.fromJson(value.data()!);
          emit(SocialGetUserSuccessState());
        });
      });

      emit(SocialAddPhotosSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialAddPhotosErrorState());
    }
  }

  Future<void> getProfileData(String uId, BuildContext context) async {
    emit(SocialGetPublisherLoadingState());
    if (uId != userModel?.uId) {
      FirebaseFirestore.instance.collection('users').doc(uId).get().then((
          value) {
        navigateTo(context,
            ViewProfileScreen(model: UserModel.fromJson(value.data()!),));
        emit(SocialGetPublisherSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetPublisherErrorState());
      });
    }
    else {
      currentIndex = 4;
      emit(SocialGetPublisherSuccessState());
    }
  }


  List<Map> stories = [];

  Future<void> getStories() async {
    stories = [];
    emit(SocialGetStoriesLoadingState());
    await FirebaseFirestore.instance.collection('users').get().then((users) {
      users.docs.forEach((user) {
        UserModel? userModel;
        List<StoryModel> storiesData = [];
        user.reference.collection('stories').orderBy('startTime',descending: true).get().then((stories) {
          if (stories.docs.isNotEmpty) {
            userModel = UserModel.fromJson(user.data());
            stories.docs.forEach((story) {
              String endTime = story.get('endTime');
              if (DateTime
                  .parse(endTime)
                  .millisecondsSinceEpoch > DateTime
                  .now()
                  .millisecondsSinceEpoch) {
                storiesData.add(StoryModel.fromJson(story.data()));
              }
            });
          }
        }).then((v) {
          if (userModel != null && storiesData.isNotEmpty) {
            stories.add({'user': userModel, 'story': storiesData});
            return true;
          }
        }).then((value) {
          if (value == true) {
            emit(SocialGetStoriesSuccessState());
          }
        });
      });
    });
  }

  File? storyImage;

  Future<void> getStoryImage(BuildContext context) async {
    XFile? pickedFile = await picker.pickImage(
      imageQuality: 25,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      /*storyImage = File(pickedFile.path);
      navigateTo(context, StoryMaker(filePath: storyImage!.path,));*/
      storyImage = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              StoryMaker(
                filePath: pickedFile.path,
              ),
        ),
      );
      if (storyImage != null) {
        FirebaseStorage.instance.ref().child('stories/${Uri
            .file(storyImage!.path)
            .pathSegments
            .last}')
            .putFile(storyImage!).then((v) {
          v.ref.getDownloadURL().then((value) {
            StoryModel storyModel = StoryModel(
                caption: '',
                url: value,
                startTime: DateTime.now().toString(),
                endTime: DateTime.now().add(Duration(days: 1)).toString());
            FirebaseFirestore.instance.collection('users')
                .doc(uId).collection('stories').add(storyModel.toMap()).then((value) {
                  getStories();
              emit(SocialPostImgPickedSuccessState());
            });
          });
        });
      }

    } else {
      print('No Image Selected');
      emit(SocialPostImgPickedErrorState());
    }
  }


}
