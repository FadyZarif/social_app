import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/styles/icon_broken.dart';
import 'package:social_app/styles/themes.dart';

class EditProfileScreen extends StatelessWidget {
   EditProfileScreen({Key? key}) : super(key: key);

  TextEditingController bioController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if(state is SocialGetUserSuccessState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);
          UserModel model = cubit.userModel!;
          bioController.text = model.bio!;
          nameController.text = model.name!;
          phoneController.text = model.phone!;
          return Scaffold(
            appBar:
                defAppBar(context: context, title: 'Edit Profile', actions: [
              TextButton(
                onPressed: () {},
                child: TextButton(
                  onPressed: () {
                    if(formState.currentState!.validate()) {
                      cubit.updateUser(name: nameController.text, bio: bioController.text, phone: phoneController.text);
                    }
                  },
                  child: Text('UPDATE '),
                ),
              ),
              SizedBox(
                width: 15,
              )
            ]),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formState,
                child: Column(
                  children: [
                    if(state.toString().contains('Loading'))
                    LinearProgressIndicator(),
                    if(state.toString().contains('Loading'))
                      const SizedBox(
                        height: 15,
                      ),
                    Container(
                      height: 210,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 160.0,
                                  width: double.infinity,
                                  decoration:BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                        4.0,
                                      ),
                                      topRight: Radius.circular(
                                        4.0,
                                      ),
                                    ),
                                    image: DecorationImage(
                                      image: cubit.coverImage==null? NetworkImage('${model.cover}'):FileImage(cubit.coverImage!) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: defColor,
                                    radius: 15,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                        iconSize: 18,
                                        onPressed: (){
                                          cubit.getCoverImage();
                                        },
                                        icon: Icon(IconBroken.Camera,color: Colors.white ,)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: cubit.profileImage==null? NetworkImage('${model.image}'):FileImage(cubit.profileImage!) as ImageProvider,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: defColor,
                                  radius: 15,
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 18,
                                      onPressed: (){
                                        cubit.getProfileImage();
                                      },
                                      icon: Icon(IconBroken.Camera,color: Colors.white ,)
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defTextFormFiled(
                      textEditingController: nameController,
                      labelText: 'Name',
                      prefixIcon: Icon(IconBroken.User),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Name musn\'t be empty';
                        }
                        return null;
                      }
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defTextFormFiled(
                        textEditingController: bioController,
                        labelText: 'Bio',
                        prefixIcon: Icon(IconBroken.Edit_Square),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Bio musn\'t be empty';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defTextFormFiled(
                      keyboardType: TextInputType.phone,
                        textEditingController: phoneController,
                        labelText: 'Phone',
                        prefixIcon: Icon(IconBroken.Call),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Phone musn\'t be empty';
                          }
                          return null;
                        }
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
