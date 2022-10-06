import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:social_app/styles/themes.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel receiverModel;

  ChatDetailsScreen({Key? key, required this.receiverModel}) : super(key: key);
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(receiverModel);
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SocialCubit cubit = SocialCubit.get(context);
            return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  toolbarHeight: 75,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(receiverModel.image!)),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          receiverModel.name!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                body: ConditionalBuilder(
                    condition: state is SocialGetAllMessagesSuccessState || cubit.messages.length > 0,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context, i) {
                                    if(cubit.messages[i].senderId == cubit.userModel?.uId){
                                      return buildMyMessage(cubit.messages[i]);
                                    }
                                    else{
                                      return buildMessage(cubit.messages[i]);
                                    }
                                  },
                                  separatorBuilder: (context, i) {
                                    return SizedBox(
                                      height: 15,
                                    );
                                  },
                                  itemCount: cubit.messages.length),
                            ),
                            Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadiusDirectional.all(
                                      Radius.circular(15))),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: TextFormField(
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          hintText: 'Write a Message...',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    child: MaterialButton(
                                      onPressed: () {
                                        cubit.sendMessage(
                                            messageController.text,
                                            receiverModel);
                                      },
                                      minWidth: 1,
                                      color: defColor,
                                      child: Center(
                                          child: Icon(IconBroken.Send,
                                              color: Colors.white, size: 18)),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator())));
          });
    });
  }

  Widget buildMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
          ),
        ),
        child: Text(model.message!),
      ),
    );
  }

  Widget buildMyMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.4),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
          ),
        ),
        child: Text(model.message!),
      ),
    );
  }
}
