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
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:timeago/timeago.dart' as timeago;

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

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
                          cubit.getStories();
                         /* print(DateTime.now().add(Duration(days: 1)));
                          print(DateTime.now());

                          timeago.setLocaleMessages('ar', timeago.ArMessages());
                          timeago.setLocaleMessages('ar_short', timeago.ArShortMessages());
                          print(timeago.format(DateTime.parse("2022-10-12 23:00:08.698220"),locale: 'ar'));*/
                        }, icon: Icon(IconBroken.Notification)),
                    IconButton(onPressed: () {navigateTo(context, SearchScreen( cubit: cubit,));}, icon: Icon(IconBroken.Search)),
                    IconButton(onPressed: (){
                      FirebaseAuth.instance.signOut().then((value) {
                        uId = null;
                        cubit.userModel = null;
                        navigateToReplacement(context, LoginScreen());
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
