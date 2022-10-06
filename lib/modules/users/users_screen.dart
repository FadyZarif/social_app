import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:social_app/styles/themes.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);
          return Scaffold(
              body: ConditionalBuilder(
                condition: cubit.allUsers.length > 0,
                builder: (context)=> ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context,i)=>buildChatItem(cubit, i, context),
                    separatorBuilder: (context,i)=> const Divider(height: 4,endIndent: 20,indent: 20),
                    itemCount: cubit.allUsers.length
                ), fallback: (context)=>const Center(child: CircularProgressIndicator()),
              )
          );
        });
  }
  Widget buildChatItem(SocialCubit cubit , int index,BuildContext context){
    return InkWell(
      onTap: (){},
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
                radius: 25,
                backgroundImage:
                NetworkImage(cubit.allUsers[index].image!)
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                cubit.allUsers[index].name!,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(onPressed: (){
              navigateTo(context, ChatDetailsScreen(receiverModel: cubit.allUsers[index]));
            }, icon: Icon(IconBroken.Chat,color: defColor,))
          ],
        ),
      ),
    );
  }
}
