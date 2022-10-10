import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/styles/icon_broken.dart';

class EditPostScreen extends StatelessWidget {
   EditPostScreen({Key? key, required this.postId, required this.model,}) : super(key: key);
   final String postId;
   PostModel model;



  @override
  Widget build(BuildContext context) {
    TextEditingController postController = TextEditingController(text: model.postText );
    GlobalKey<FormState> formKey = GlobalKey();
    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is SocialEditPostSuccessState) {
        Navigator.pop(context);
        SocialCubit.get(context).postImage = null;
      }
    }, builder: (context, state) {
      SocialCubit cubit = SocialCubit.get(context);
      return Scaffold(
        appBar: defAppBar(isEditPost: true, context: context, title: 'Edit Post', actions: [
          TextButton(
              onPressed: () {
                if(formKey.currentState!.validate()) {
                  cubit.editNewPost(model: model,postId: postId);
                }
              },
              child: const Text('Edit'))
        ]),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (state is SocialEditPostLoadingState)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: LinearProgressIndicator(),
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          cubit.userModel!.image!),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      cubit.userModel!.name!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  height: 160,
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                        controller: postController,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                          'what is on your mind, ${cubit.userModel?.name} ?',
                        ),
                        validator: (v){
                          if(v!.isEmpty){
                            return 'write post';
                          }
                          else {
                            return null;
                          }
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                ConditionalBuilder(
                  condition: cubit.postImage != null,
                  builder:(context)=> Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      if(!kIsWeb)
                        Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 5,
                          child: Image(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            //height: 450,
                          ),
                        ),
                      if(kIsWeb)
                        Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 5,
                          child: Image(
                            image: NetworkImage(cubit.postImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            //height: 450,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          radius: 15,
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              onPressed: () {
                                cubit.deletePostImage();
                              },
                              icon: const Icon(
                                IconBroken.Delete,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                  fallback: (context) => Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      if(!kIsWeb)
                        if(model.postImage != null)
                        Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 5,
                          child: Image(
                            image: NetworkImage(model.postImage!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            //height: 450,
                          ),
                        ),
                      if(kIsWeb)
                        Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 5,
                          child: Image(
                            image: NetworkImage(cubit.postImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            //height: 450,
                          ),
                        ),
                      if(model.postImage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          radius: 15,
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              onPressed: () {
                                model.postImage = null;
                                cubit.removePostImage();
                              },
                              icon: const Icon(
                                IconBroken.Delete,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              TextButton(
                  onPressed: () {
                    cubit.getPostImage();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(IconBroken.Image),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('add photo'),
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }
}
