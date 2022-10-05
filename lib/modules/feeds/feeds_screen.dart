import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comments/comments_screen.dart';
import 'package:social_app/modules/likes/likes_screen.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:social_app/styles/themes.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({Key? key}) : super(key: key);

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is SocialWriteCommentSuccessState) {
        commentController.text = '';
      }
    }, builder: (context, state) {
      SocialCubit cubit = SocialCubit.get(context);
      return Scaffold(
        key: scaffoldKey,
        body: ConditionalBuilder(
          condition: cubit.posts.isNotEmpty,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8),
                  elevation: 5,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      const Image(
                        image: NetworkImage(
                            'https://img.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg?w=740&t=st=1664659256~exp=1664659856~hmac=186f74c0db8dbbd1afd68e85d470121f4189e3103becb116c418a10ac8cef96f'),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 220,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Communicate with friends',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) => buildPostItem(
                      context, cubit.posts[i], i, cubit, scaffoldKey),
                  separatorBuilder: (context, i) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: cubit.posts.length,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        ),
      );
    });
  }

  Widget buildPostItem(BuildContext context, PostModel model, int i,
      SocialCubit cubit, GlobalKey<ScaffoldState> scaffoldKey) {
    GlobalKey<FormState> formState = GlobalKey();
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(model.image!),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.name!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 15,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${DateFormat.yMMMMd().format(DateTime.parse(model.dateTime!))} at ${DateFormat.jm().format(DateTime.parse(model.dateTime!))}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {}, icon: const Icon(IconBroken.More_Circle))
              ],
            ),
            const Divider(
              thickness: 1.0,
              height: 30,
            ),
            Text(
              model.postText!,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            /* MaterialButton(
                      onPressed: (){},
                      minWidth: 1,
                      height: 1,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#Software',
                        style: TextStyle(
                          color: defColor
                        ),
                      ),
                    ),*/
            if (model.postImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  elevation: 4,
                  child: Image(
                    image: NetworkImage(model.postImage!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    //height: 120,
                  ),
                ),
              ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    navigateTo(context, LikesScreen(i: i,));
                  },
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Heart,
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        model.likes?.length.toString() ?? '0',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    navigateTo(context, CommentsScreen(i: i));
                  },
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Chat,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        model.comments?.length.toString() ?? '0',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1.0,
              height: 30,
            ),
            Form(
              key: formState,
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(cubit.userModel!.image!),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: commentController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'empty';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'write comment ... ',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          if(formState.currentState!.validate()) {
                            cubit.writeComment(
                              cubit.postsId[i], i, commentController.text);
                          }
                        },
                        icon: Icon(
                          IconBroken.Send,
                          color: defColor,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        cubit.likePost(cubit.postsId[i], i);
                      },
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            color: cubit.isLiked[i] ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Like',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                  color:
                                      cubit.isLiked[i] ? Colors.red : Colors.grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
