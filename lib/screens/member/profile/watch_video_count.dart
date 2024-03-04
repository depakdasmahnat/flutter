import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/screens/guest/guest_check_demo/guest_check_demo_step2.dart';

import '../../../core/config/app_assets.dart';
import '../../../models/guestProfileDetailsFor/guestProfileDetailFor.dart';
import '../../../models/member/leads/leads_member_details.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../guest/guestProfile/guest_faq.dart';

class WatchVideoCount extends StatefulWidget {
  GuestProfileDetailFor? guestProfileDetails;
   WatchVideoCount({super.key,this.guestProfileDetails});

  @override
  State<WatchVideoCount> createState() => _WatchVideoCountState();
}

class _WatchVideoCountState extends State<WatchVideoCount> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: CustomText1(
          text: 'Watch Count',
          color: Colors.white,
        ),
        leading:  Column(
          children: [
            CustomBackButton(),
          ],
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.guestProfileDetails?.data?.watchedVideos?.length ?? 0,

        padding: EdgeInsets.only(bottom: size.height * 0.1, left: 8, right: 8),
        itemBuilder: (context, index) {
          var data = widget.guestProfileDetails?.data?.watchedVideos?.elementAt(index);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: size.height * 0.08,
                      width: size.height * 0.08,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          data?.file ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Expanded(
                      child: CustomeText(
                        text: data?.title ?? '',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    CircleAvatar(
                      maxRadius: size.height * 0.03,
                      backgroundColor: Colors.transparent,
                      backgroundImage: const AssetImage(AppAssets.playIcon),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // body: ,
    );
  }
}
