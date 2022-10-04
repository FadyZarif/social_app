import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/styles/themes.dart';

class OnBoardingScreen extends StatelessWidget {
   OnBoardingScreen({Key? key}) : super(key: key);

  PageController pageController = PageController();

  List<BoardingModel> onBoardingList = [
    BoardingModel(
        img: 'assets/onboarding1.png',
        tx1: 'Welcome To our Social App',
        tx2: 'Let\'s Discover the World'),
    BoardingModel(
        img: 'assets/onboarding2.png',
        tx1: 'Enjoy With Us',
        tx2: 'Know all the news and you are in your place'),
    BoardingModel(
        img: 'assets/onboarding3.png',
        tx1: 'Keep in Touch',
        tx2: 'Chat with all your Friends'),
  ];



  @override
  Widget build(BuildContext context) {

    void skipOnBoarding() {
      CacheHelper.saveData(key: 'skipBoarding', value: true).then((value) {
        if(value==true){
          navigateToReplacement(context, LoginScreen());
        }
      }).catchError((error){
        print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');print('Save SharedPreferences ');
        print(error.toString());
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                skipOnBoarding();
              },
              child: Text(
                'SKIP',
                style: TextStyle(color: defColor),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: onBoardingList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildPageViewItem(index);
                },
              ),
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: onBoardingList.length,
              onDotClicked: (i) {
                pageController.animateToPage(i,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
              effect: ExpandingDotsEffect(
                activeDotColor: defColor,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          onPressed: () {
            if(pageController.page!.ceil() == onBoardingList.length-1){
              skipOnBoarding();
            }
            else {
              pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.fastLinearToSlowEaseIn);
            }

          }),
    );
  }

  Widget buildPageViewItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(onBoardingList[index].img),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          onBoardingList[index].tx1,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w900, color: defColor),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          onBoardingList[index].tx2,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black87),
        )
      ],
    );
  }
}

class BoardingModel {
  String img;
  String tx1;
  String tx2;

  BoardingModel({required this.img, required this.tx1, required this.tx2});
}
