import 'package:flutter/material.dart';

import 'core/config/app_images.dart';
import 'core/constant/colors.dart';
import 'core/functions.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int pageIndex = 0;
  PageController pageController = PageController();
  late int lastIndex = introScreensData.length - 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height *
              deviceSpecificValue(
                context: context,
                device: 0.48,
                tablet: 0.66,
              ),
          child: PageView(
            controller: pageController,
            onPageChanged: (val) {
              pageIndex = val;
              setState(() {});
            },
            scrollDirection: Axis.horizontal,
            children: List.generate(
              introScreensData.length,
              (index) => introScreens(index),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: SizedBox(
            height: 7,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 36),
              scrollDirection: Axis.horizontal,
              itemCount: introScreensData.length,
              itemBuilder: (context, index) {
                bool current = index == pageIndex;
                return Container(
                  width: current ? 40 : 18,
                  margin: const EdgeInsets.only(left: 4, right: 4),
                  decoration: BoxDecoration(
                    color: current ? primaryColor : primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List introScreensData = [
    {
      "title": "Obtain fresh produce from your neighbour's backyard",
      "imageUrl": AppImages.intro1,
    },
    {
      "title": "Locate natural produce near you",
      "imageUrl": AppImages.intro2,
    },
    {
      "title": "Identify the most qualified service provider in your area",
      "imageUrl": AppImages.intro3,
    },
    {
      "title": "Learn about gardening tips and tricks",
      "imageUrl": AppImages.intro4,
    },
  ];

  Widget introScreens(int index) {
    var data = introScreensData[index];
    String title = "${data["title"]}";
    String imageUrl = "${data["imageUrl"]}";
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image(
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          image: AssetImage(imageUrl),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(36, 24, 36, 60),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              height: 1.25,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
