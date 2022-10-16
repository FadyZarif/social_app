import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({Key? key, required this.model}) : super(key: key);
  final UserModel model;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 210,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Container(
                              height: 160.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    4.0,
                                  ),
                                  topRight: Radius.circular(
                                    4.0,
                                  ),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    '${model.cover}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 64,
                            backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage('${model.image}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      model.name!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      model.bio!,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '100',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('Posts',
                                      style: Theme.of(context).textTheme.caption),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '265',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('Photos',
                                      style: Theme.of(context).textTheme.caption),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '10K',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('Followers',
                                      style: Theme.of(context).textTheme.caption),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '64',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('Followings',
                                      style: Theme.of(context).textTheme.caption),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: model.photos!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 3),
                        itemBuilder: (context,i)=>  model.photos?[i] != null ? buildPhotosItem(model.photos![i]!) : Container()
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
  Widget buildPhotosItem(String photo){
    return Container(color: Colors.lightBlueAccent,
      child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(photo),
      ),
    );
  }
}
