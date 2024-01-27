import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/guest_Model/fetchnewjoiners.dart';

class GuestProfiles extends StatefulWidget {
  const GuestProfiles({super.key});

  @override
  State<GuestProfiles> createState() => _GuestProfilesState();
}

class _GuestProfilesState extends State<GuestProfiles> {
  // Fetchnewjoiners? fetchnewjoiners;
  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
     await context.read<GuestControllers>().fetchNewJoiners(context: context,);
    });
  }
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
                            child:  controller.fetchnewjoiners?.data?.members?[index].profilePhoto==null?Image.asset(
                            AppAssets.userImage,
                              fit: BoxFit.cover,
                              height: size.height * 0.05,
                            ):Image.network(
                              controller.fetchnewjoiners?.data?.members?[index].profilePhoto??'',
                              fit: BoxFit.cover,
                              height: size.height * 0.05,
                            ),
                          ),
                          SizedBox(
                            width: size.width*0.1,
                            child: Text(
                              '${controller.fetchnewjoiners?.data?.members?[index].firstName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,

                                fontSize: 12,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
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

    );
  }
}
