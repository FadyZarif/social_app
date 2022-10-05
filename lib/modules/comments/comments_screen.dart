import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';

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
            appBar: AppBar(),
            body: ConditionalBuilder(
              condition: cubit.posts[i].comments != null,
              builder: (context)
              {
               return Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ConditionalBuilder(
                        condition: cubit.posts[i].comments![0]['img'] != null,
                        builder: (context) =>
                            buildCommentItem(cubit, index, context),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.transparent,height: 20,),
                    itemCount: cubit.posts[i].comments?.length ?? 0
              ),
               );
              },
              fallback: (context)=> Center(child: CircularProgressIndicator()),
            )
          );
        });
  }
  Widget buildCommentItem(SocialCubit cubit,int index,BuildContext context){
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(cubit.posts[i].comments![index]['img']),
        ),
        const SizedBox(width: 5,),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cubit.posts[i].comments![index]['name'],style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
                  Text(
                    cubit.posts[i].comments![index]['comment'].toString(),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
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
