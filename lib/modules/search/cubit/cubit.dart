import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/search/cubit/states.dart';


class SearchCubit extends Cubit<SearchStates>{

  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);


  /*SearchModel? searchModel;

  void search({required String q}){
    emit(SearchLoadingState());
    DioHelper.postData(
        url: SEARCH_PRODUCT,
        data: {'text' : q}
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState(searchModel));
    }).catchError((error){
      print(error.toString());
      emit(SearchErrorState());
    });
  }*/

  UserModel? userModel;
  List<UserModel> usersList=[];
  PostModel? postModel;
  List<PostModel> postsList=[];

  void search({required String q}){
    emit(SearchLoadingState());
    usersList=[];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        userModel = UserModel.fromJson(element.data());
        if(q !='') {
          if (userModel!.name!.toLowerCase().contains(q)) {
            usersList.add(userModel!);
          }
        }
        else{
          usersList=[];
        }
      });
    }).then((value2)  {
      postsList=[];
      FirebaseFirestore.instance.collection('posts').get().then((v){
        v.docs.forEach((element) {
          postModel = PostModel.fromJson(element.data());
          if(q !='') {
            if (postModel!.postText!.toLowerCase().contains(q)) {
              postsList.add(postModel!);
            }
          }
          else{
            postsList=[];
          }
        });
      }).then((value) {
        emit(SearchSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(SearchErrorState());
      });
    }).catchError((error){
      print(error.toString());
      emit(SearchErrorState());
    });
  }






}