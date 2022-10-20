import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/constant.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void newRegistration(
      {required String name,
      required String email,
      required String password,
      required String phone,
      }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(error.toString());
      emit(RegisterErrorState(error.message));
    });
  }

  void createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String uId,
   }) {
    UserModel userModel = UserModel(
      token: token,
      name: name,
      email: email,
      password: password,
      phone: phone,
      uId: uId,
      image: 'https://cdn-icons-png.flaticon.com/512/274/274133.png?w=740&t=st=1664670509~exp=1664671109~hmac=daa652327bae2d17c15f4c20059f769329bfd09f38ab127909c65c7f8893005e',
      cover: 'https://media.istockphoto.com/photos/delicious-meal-on-a-black-plate-top-view-copy-space-picture-id1165399909?k=20&m=1165399909&s=612x612&w=0&h=5g5C4BDoxaejlIr4r_8cV6jDYXzN8n1-JkIW3LgPUuA=',
      bio: 'write your bio ...',
      isOnline: true,
      photos: []
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(CreateSuccessState(uId));
    }).catchError((error) {
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(error.toString());
      emit(CreateErrorState(error.message));
    });
  }

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility;

  void changePasswordVisibility() {
    emit(LoginChangeVisibilityState());
    isPassword = !isPassword;
    if (isPassword) {
      suffixIcon = Icons.visibility;
    } else {
      suffixIcon = Icons.visibility_off;
    }
  }
}
