import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/styles/icon_broken.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);
          return Scaffold(
              body: ConditionalBuilder(
                  condition: cubit.allChats.length > 0 || state is SocialGetAllUserSuccessState,
                  builder: (context) => ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, i) =>
                          buildChatItem(cubit, i, context),
                      separatorBuilder: (context, i) =>
                          const Divider(height: 4, endIndent: 20, indent: 20),
                      itemCount: cubit.allChats.length),
                  fallback: (context) {
                    return Center(
                      child: Text('No Recent Chats!',style: Theme.of(context).textTheme.headlineLarge,),
                    );
                  }));
        });
  }

  Widget buildChatItem(SocialCubit cubit, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            ChatDetailsScreen(
              receiverModel: cubit.allChats[index],
            ));
        cubit.inChat = true;

      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CircleAvatar(
                    radius: 33,
                    backgroundImage: NetworkImage(cubit.allChats[index].image!)),
                if(cubit.allChats[index].isOnline!)
                  const CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 7,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cubit.allChats[index].name!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(
                  //   height: 3,
                  // ),
                   // Text(cubit.allLastMessage[index].message!,overflow: TextOverflow.ellipsis,)
                ],
              ),
            ),
            // Column(
            //   children: [
            //     Text('7:30 Am'),
            //     if(cubit.isSeenList[index] == false)
            //     CircleAvatar(
            //       radius: 15,
            //       backgroundColor: Colors.lightBlueAccent,
            //         child: Icon(IconBroken.Notification,size: 18,color: Colors.white,)
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
