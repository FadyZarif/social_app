import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  final int i;
  const CommentsScreen({Key? key, required this.i}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title:   Row(
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
                    '${cubit.posts[i].comments?.length.toString()??0} comments',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            body: ConditionalBuilder(
              condition: cubit.commentersList.isNotEmpty,
              builder: (context)
              {
               return Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: ListView.separated(
                    itemBuilder: (context, index) {
                      return buildCommentItem(cubit, index, context);
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.transparent,height: 20,),
                    itemCount: cubit.posts[i].comments?.length ?? 0
              ),
               );
              },
              fallback: (context)=> const Center(child: CircularProgressIndicator()),
            )
          );
        });
  }
  Widget buildCommentItem(SocialCubit cubit,int index,BuildContext context){
    return Row(
      children: [
        ConditionalBuilder(
          condition: cubit.commentersList[index].image != null,
          builder:(context)=> CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(cubit.commentersList[index].image!),
          ),
          fallback: (context)=> const CircleAvatar(
            radius: 25,
            child: CircularProgressIndicator(),
          ),
        ),
        const SizedBox(width: 5,),
        Expanded(
          child: Container(
            decoration:  BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cubit.commentersList[index].name!,style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    cubit.posts[i].comments![index]['comment'].toString(),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                    softWrap: true,
                  ),
                ],
              ),
          ),
        )
      ],
    );
  }
}
