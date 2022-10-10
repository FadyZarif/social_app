import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/styles/icon_broken.dart';

class LikesScreen extends StatelessWidget {
  final int i;

  LikesScreen({Key? key, required this.i}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Row(
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
                  cubit.posts[i].likes?.length.toString() ?? '0',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          body: ConditionalBuilder(
            condition: cubit.likersList.isNotEmpty,
            builder: (context) => Container(
              padding: const EdgeInsets.all(20),
              child: ListView.separated(
                  itemCount: cubit.posts[i].likes?.length ?? 0,
                  separatorBuilder: (context, index) => Divider(
                        thickness: 0,
                        color: Colors.transparent,
                      ),
                  itemBuilder: (context, index) {
                    return buildLikerItem(cubit, index, context);
                  }),
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget buildLikerItem(SocialCubit cubit, int index, BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(cubit.likersList[index].image!)
                //NetworkImage(cubit.likersa[i].image!),
                ),
            CircleAvatar(
                backgroundColor: Colors.red,
                radius: 10,
                child: Icon(
                  IconBroken.Heart,
                  color: Colors.white,
                  size: 14,
                ))
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          cubit.likersList[index].name!,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
