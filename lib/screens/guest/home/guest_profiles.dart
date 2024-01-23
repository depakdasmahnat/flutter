import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';

class GuestProfiles extends StatefulWidget {
  const GuestProfiles({super.key});

  @override
  State<GuestProfiles> createState() => _GuestProfilesState();
}

class _GuestProfilesState extends State<GuestProfiles> {
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
    );
  }
}
