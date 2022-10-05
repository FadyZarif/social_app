import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:social_app/styles/themes.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);

  TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is SocialCreatePostSuccessState) {
        Navigator.pop(context);
        SocialCubit.get(context).postImage = null;
      }
    }, builder: (context, state) {
      SocialCubit cubit = SocialCubit.get(context);
      return Scaffold(
        appBar: defAppBar(context: context, title: 'Create Post', actions: [
          TextButton(
              onPressed: () {
                cubit.createNewPost(postText: postController.text);
              },
              child: const Text('Post'))
        ]),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
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
                  child: TextFormField(
                    controller: postController,
                    maxLines: 7,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          'what is on your mind, ${cubit.userModel?.name} ?',
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
              if (cubit.postImage != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
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
