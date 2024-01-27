import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
<<<<<<< HEAD
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';
=======
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/guest_Model/fetchnewjoiners.dart';
>>>>>>> guestUI

class GuestProfiles extends StatefulWidget {
  const GuestProfiles({super.key});

  @override
  State<GuestProfiles> createState() => _GuestProfilesState();
}

class _GuestProfilesState extends State<GuestProfiles> {
<<<<<<< HEAD
=======
  // Fetchnewjoiners? fetchnewjoiners;
  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
     await context.read<GuestControllers>().fetchNewJoiners(context: context,);
    });
  }
>>>>>>> guestUI
  List guestProfile = [
    {
      'image': AppAssets.guestProfile1,
      'title': 'blue_bouy',
      'subtital': 'Raipur',
    },
    {
      'image': AppAssets.guestProfile2,
      'title': 'sabanok...',
      'subtital': 'Raipur',
    },
    {
      'image': AppAssets.guestProfile1,
      'title': 'sabanok...',
      'subtital': 'Raipur',
    },
    {
      'image': AppAssets.guestProfile2,
      'title': 'sabanok...',
      'subtital': 'Raipur',
    },
    {
      'image': AppAssets.guestProfile2,
      'title': 'sabanok...',
      'subtital': 'Raipur',
    },
<<<<<<< HEAD
    {
      'image': AppAssets.guestProfile2,
      'title': 'sabanok...',
      'subtital': 'Raipur',
    },
    {
      'image': AppAssets.guestProfile1,
      'title': 'sabanok...',
      'subtital': 'Raipur',
    },
    {
      'image': AppAssets.guestProfile2,
      'title': 'sabanok...',
      'subtital': 'Raipur',
    },
    {
      'image': AppAssets.guestProfile2,
      'title': 'sabanok...',
      'subtital': 'Raipur',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: kPadding, right: kPadding),
      child: SizedBox(
        height: 85,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: primaryGradient),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '07 Days',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '24',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            height: 1,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'New\nMembers Join',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: GoogleFonts.urbanist().fontFamily,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: guestProfile.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageView(
                          height: 45,
                          width: 45,
                          borderRadiusValue: 45,
                          margin: const EdgeInsets.only(bottom: 8),
                          assetImage: guestProfile[index]['image'],
                        ),
                        Text(
                          '${guestProfile[index]["title"]}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${guestProfile[index]["subtital"]}',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 8,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
=======
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<GuestControllers>(

    builder: (context, controller, child) {

      return   Padding(
        padding: const EdgeInsets.only(left: kPadding, right: kPadding),
        child: SizedBox(
          height: size.height * 0.10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              controller.isLoading==false?
              const Center(
                child:   CupertinoActivityIndicator(
                    radius: 15, color: CupertinoColors.white),
              ):
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, gradient: primaryGradient),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '07 Days',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            '${controller.fetchnewjoiners?.data?.counts}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              height: 1,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'New\nMembers Join',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: GoogleFonts.urbanist().fontFamily,
                        fontWeight: FontWeight.w500,
                        height: 1),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              controller.isLoading==false?
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child:   CupertinoActivityIndicator(
                        radius: 15, color: CupertinoColors.white),
                  ),
                ],
              ):
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.fetchnewjoiners?.data?.members?.length??0,
                  itemBuilder: (context, index) {
                    return 
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child:controller.fetchnewjoiners?.data?.members?[index].profilePhoto==null?Image.asset(AppAssets.getsprofile,fit: BoxFit.cover,
                              height: size.height * 0.05,) :Image.network(
                              controller.fetchnewjoiners?.data?.members?[index].profilePhoto??'',
                              fit: BoxFit.cover,
                              height: size.height * 0.05,
                            ),
                          ),
                          Text(
                            '${controller.fetchnewjoiners?.data?.members?[index].firstName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${controller.fetchnewjoiners?.data?.members?[index].cityName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },

>>>>>>> guestUI
    );
  }
}
