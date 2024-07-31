import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/modules/likes/likes_screen.dart';
import 'package:social_app/modules/search/cubit/cubit.dart';
import 'package:social_app/modules/search/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:social_app/styles/themes.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key, required this.cubit}) : super(key: key);
  SocialCubit cubit;
  TextEditingController searchController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SearchCubit cubit = SearchCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                elevation: 3,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: formKey,
                      child: defTextFormFiled(
                          contentPadding: EdgeInsets.zero,
                          textEditingController: searchController,
                          prefixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel_outlined),
                            onPressed: () {
                              searchController.text = '';
                            },
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter word';
                            }
                            return null;
                          },
                          hintText: 'Search...',
                          onSubmitted: (value) {
                            SearchCubit.get(context).search(q: value);
                          },
                          onChanged: (value) {
                            SearchCubit.get(context).search(q: value);
                          })),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is SearchLoadingState) LinearProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    if (cubit.usersList.isNotEmpty)
                      Card(
                        color: Colors.grey[100],
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'People',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) => buildChatItem(
                                      context, cubit.usersList[i]),
                                  separatorBuilder: (context, i) =>
                                      Divider(height: 22),
                                  itemCount: cubit.usersList.length),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (cubit.postsList.isNotEmpty)
                      Card(
                        color: Colors.grey[100],
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Posts',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) => buildPostItem(
                                      context, cubit.postsList[i],cubit,i),
                                  separatorBuilder: (context, i) =>
                                      Divider(height: 22),
                                  itemCount: cubit.postsList.length),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildChatItem(BuildContext context, UserModel userModel) {
    return InkWell(
      onTap: () {
        cubit.getProfileData(userModel.uId!, context);
        },
      child: Row(
        children: [
          CircleAvatar(
              radius: 35, backgroundImage: NetworkImage(userModel.image!)),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              userModel.name!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
              onPressed: () {
                navigateTo(
                    context, ChatDetailsScreen(receiverModel: userModel));
                cubit.inChat = true;

              },
              icon: Icon(
                IconBroken.Chat,
                color: defColor,
              ))
        ],
      ),
    );
  }

  Widget buildPostItem(BuildContext context, PostModel postModel,SearchCubit searchCubit,int i) {
    GlobalKey<FormState> formState = GlobalKey();
    return Card(
      color: Colors.grey[50],
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                     cubit.getProfileData(postModel.uId!, context);
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(postModel.image!),
                  ),
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
                        InkWell(
                          onTap: () {
                             cubit.getProfileData(postModel.uId!, context);
                          },
                          child: Text(
                            postModel.name!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
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
                      '${DateFormat.yMMMMd().format(DateTime.parse(postModel.dateTime!))} at ${DateFormat.jm().format(DateTime.parse(postModel.dateTime!))}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            const Divider(
              thickness: 1.0,
              height: 30,
            ),
            Text(
              postModel.postText!,
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
            if (postModel.postImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  elevation: 4,
                  child: Image(
                    image: NetworkImage(postModel.postImage!),
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
                        '${postModel.likes?.length.toString() ?? 0} likes',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {

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
                        '${postModel.comments?.length.toString() ?? 0} comments',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
