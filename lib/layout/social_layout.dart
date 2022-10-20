import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/network/remote/dio_helper.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:timeago/timeago.dart' as timeago;

class SocialLayout extends StatefulWidget  {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  State<SocialLayout> createState() => _SocialLayoutState();
}

class _SocialLayoutState extends State<SocialLayout> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SocialCubit.get(context).setUserStatus(isOnline: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed){
      SocialCubit.get(context).setUserStatus(isOnline: true);
    }

    else
    {
      SocialCubit.get(context).setUserStatus(isOnline: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SocialCubit cubit = SocialCubit.get(context);
    //cubit.getUserData();

    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if(state is SocialNewPostState){
            navigateTo(context, NewPostScreen());
          }
        },
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);
          return ConditionalBuilder(
            condition: cubit.userModel != null ,
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(cubit.titlesList[cubit.currentIndex]),
                  actions: [
                    IconButton(
                        onPressed: () {
                          DioHelper.sendNotification(
                              token: 'ehHarXwvT-CKRHRT0UgnMj:APA91bGPuO2szYM34jN2YDGD4QimtSryDFekPR8qGl907uOSS7hSF8tuos-ixUmhw85UmQWeBxIt_4xV5-2e3yBTNlqiuHIlP6uWLJLhs7SsHBvGjZT24ZL9u14URLf5MINmSkXKt_e3',
                              title: 'Dio Helper',
                              body: 'Test',
                              image: ''
                          );
                          // cubit.getStories();
                         /* print(DateTime.now().add(Duration(days: 1)));
                          print(DateTime.now());

                          timeago.setLocaleMessages('ar', timeago.ArMessages());
                          timeago.setLocaleMessages('ar_short', timeago.ArShortMessages());
                          print(timeago.format(DateTime.parse("2022-10-12 23:00:08.698220"),locale: 'ar'));*/
                        }, icon: Icon(IconBroken.Notification)),
                    IconButton(onPressed: () {navigateTo(context, SearchScreen( cubit: cubit,));}, icon: Icon(IconBroken.Search)),
                    IconButton(onPressed: (){
                      cubit.setUserStatus(isOnline: false).then((value) {
                        FirebaseFirestore.instance.collection('users').doc(uId).update({"token":null}).then((value) {
                          FirebaseAuth.instance.signOut().then((value) {
                            uId = null;
                            cubit.userModel = null;
                            navigateToReplacement(context, LoginScreen());
                        });
                      });
                      });
                    }, icon: Icon(IconBroken.Logout))
                  ],
                ),
                body: cubit.screensList[cubit.currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  items: cubit.BottomNavItems,
                  onTap: (i) {
                    cubit.changeBottomNav(i);
                  },
                  currentIndex: cubit.currentIndex,
                ),
              );
            },
            fallback: (context) =>
                Scaffold(
                    body: const Center(child: CircularProgressIndicator())
                ),
          );
        });
  }
}
