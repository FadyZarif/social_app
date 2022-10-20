import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/components/constant.dart';

class LoginCubit extends Cubit<LoginStates>{

  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  //LoginModel? loginModel ;

  void userLogin({required String email , required String password}){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
      uId = value.user!.uid;
      FirebaseFirestore.instance.collection('users').doc(value.user!.uid).update({"token":token}).then((value) {
        emit(LoginSuccessState());
      });
    }).catchError((error){
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(error.toString());
      emit(LoginErrorState(error.message));
    });
  }

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility;

  void changePasswordVisibility(){
    emit(LoginChangeVisibilityState());
    isPassword = !isPassword;
    if(isPassword) {
      suffixIcon = Icons.visibility;
    } else {
      suffixIcon = Icons.visibility_off;
    }
  }

}