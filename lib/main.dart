import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/styles/themes.dart';

bool? isLogin;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  bool skipOnBoarding = CacheHelper.getData(key: 'skipBoarding')??false;
  //CacheHelper.clearData();
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isLogin = false;
  } else {
    uId = user.uid;
    isLogin = true;
  }
  runApp(MyApp(skipOnBoarding: skipOnBoarding));
}

class MyApp extends StatelessWidget {
   MyApp({super.key, required this.skipOnBoarding});
  final bool skipOnBoarding;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SocialCubit()..getUserData()
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightTheme,
        home: skipOnBoarding?  isLogin!? SocialLayout() : LoginScreen() : OnBoardingScreen(),
      ),
    );
  }
}

