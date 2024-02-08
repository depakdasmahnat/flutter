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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<GuestControllers>().fetchNewJoiners(
            context: context,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<GuestControllers>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: SizedBox(
            height: size.height * 0.10,
            width: size.width * 0.5,
            child: controller.isLoading == false
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CupertinoActivityIndicator(
                            radius: 15, color: CupertinoColors.white),
                      ),
                    ],
                  )
                :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(

                       children: [
                         Container(
                           decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               gradient: primaryGradient),
                           child: Padding(
                             padding: const EdgeInsets.all(6),
                             child: Column(
                               crossAxisAlignment:  CrossAxisAlignment.center,
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text(
                                   '07 Days',
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 8,
                                     fontFamily:
                                     GoogleFonts.urbanist().fontFamily,
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
                                     fontFamily:
                                     GoogleFonts.urbanist().fontFamily,
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
                               fontSize: 8,
                               fontFamily: GoogleFonts.urbanist().fontFamily,
                               fontWeight: FontWeight.w500,
                               height: 1),
                           textAlign: TextAlign.center,
                         ),
                       ],
                     ),
                     NewJoiner(
                       image: controller.fetchnewjoiners?.data?.members?[0].profilePhoto??'',
                       firstName:  controller.fetchnewjoiners?.data?.members?[0].firstName??'',
                       cityName: controller.fetchnewjoiners?.data?.members?[0].cityName??'',

                     ),
                     NewJoiner(
                       image: controller.fetchnewjoiners?.data?.members?[1].profilePhoto??'',
                       firstName:  controller.fetchnewjoiners?.data?.members?[1].firstName??'',
                       cityName: controller.fetchnewjoiners?.data?.members?[1].cityName??'',

                     ),
                     NewJoiner(
                       image: controller.fetchnewjoiners?.data?.members?[2].profilePhoto??'',
                       firstName:  controller.fetchnewjoiners?.data?.members?[2].firstName??'',
                       cityName: controller.fetchnewjoiners?.data?.members?[2].cityName??'',

                     ),
                     NewJoiner(
                       image: controller.fetchnewjoiners?.data?.members?[3].profilePhoto??'',
                       firstName:  controller.fetchnewjoiners?.data?.members?[3].firstName??'',
                       cityName: controller.fetchnewjoiners?.data?.members?[4].cityName??'',

                     ),
                     NewJoiner(
                       image: controller.fetchnewjoiners?.data?.members?[4].profilePhoto??'',
                       firstName:  controller.fetchnewjoiners?.data?.members?[4].firstName??'',
                       cityName: controller.fetchnewjoiners?.data?.members?[4].cityName??'',
                     ),
                   ],
                ),
          ),
        );
      },
    );
  }
}

class NewJoiner extends StatelessWidget {
  String? image;
  String? firstName;
  String? cityName;
  NewJoiner({
     this.image,
     this.firstName,
     this.cityName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return
      Column(
        children: [
          image?.isEmpty==true
              ? const CircleAvatar(
            // maxRadius: size.height * 0.03,
            // minRadius: size.height * 0.03,
            backgroundImage: AssetImage(AppAssets.getsprofile),
          )
              : CircleAvatar(
            // maxRadius: size.height * 0.03,
            // minRadius: size.height * 0.03,
            backgroundImage: NetworkImage(
              image??'',
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              firstName??'Deepak',
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: GoogleFonts.urbanist().fontFamily,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            cityName?.isEmpty==true?'Raipur':cityName??'',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontFamily: GoogleFonts.urbanist().fontFamily,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
  }
}

