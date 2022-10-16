import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:story_view/story_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewStory extends StatelessWidget {
  ViewStory({Key? key, required this.story, required this.index})
      : super(key: key);
  final Map story;
  final int index;
  StoryController storyController = StoryController();

  @override
  Widget build(BuildContext context) {
    SocialCubit cubit = SocialCubit.get(context);
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [],
              backgroundColor: Colors.black,
              toolbarHeight: 30,
            ),
            body: StoryView(
              userImage: story['user'].image,
              userName: story['user'].name,
              onVerticalSwipeComplete: (d) {
                print(d);
                print('object');
              },
              storyItems: /* [
            StoryItem.text(
              title: "I guess you'd love to see more of our food. That's great.",
              backgroundColor: Colors.blue,
            ),
            StoryItem.text(
              title: "Nice!\n\nTap to continue.",
              backgroundColor: Colors.red,
              textStyle: TextStyle(
                fontFamily: 'Dancing',
                fontSize: 40,
              ),
            ),
            StoryItem.pageImage(
              url:
                  "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
              caption: "Still sampling",
              controller: storyController,
            ),
            StoryItem.pageImage(
                url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                caption: "Working with gifs",
                controller: storyController),
            StoryItem.pageImage(
              url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
              caption: "Hello, from the other side",
              controller: storyController,
            ),
            StoryItem.pageImage(
              url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
              caption: "Hello, from the other side2",
              controller: storyController,
            ),
            StoryItem.pageVideo(
              'https://player.vimeo.com/external/489779797.sd.mp4?s=0d8949fb8c4388c6638f6ad40495c72b10ea102b&profile_id=165&oauth2_token_id=57447761',
              controller: storyController,
              caption: "video",
            )
          ]*/
                  List.generate(story['story'].length, (i) {
                return story['story'][i].url != null
                    ? StoryItem.pageImage(
                        timaAgo: timeago.format(
                            DateTime.parse(story['story'][i].startTime),
                            locale: 'en'),
                        url: story['story'][i].url,
                        caption: story['story'][i].caption,
                        controller: storyController,
                      )
                    : StoryItem.text(
                        timaAgo: timeago.format(
                            DateTime.parse(story['story'][i].startTime),
                            locale: 'en'),
                        title: story['story'][i].caption,
                        backgroundColor: Colors.lightBlueAccent,
                      );
              }),
              onStoryShow: (s) {
                print("Showing a story");
              },
              onComplete: () {
                print("Completed a cycle");
                if(index+1 == cubit.stories.length){
                  navigateToReplacement(context, SocialLayout());
                }
                else {
                  navigateTo(
                    context,
                    ViewStory(
                      story: cubit.stories[index + 1],
                      index: index + 1,
                    ));
                }
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              controller: storyController,
            ),
          );
        });
  }
}
