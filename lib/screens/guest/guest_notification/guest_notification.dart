import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';

import '../../../utils/widgets/appbar.dart';

class GuestNotification extends StatefulWidget {
  const GuestNotification({super.key});

  @override
  State<GuestNotification> createState() => _GuestNotificationState();
}

class _GuestNotificationState extends State<GuestNotification> {
  @override
  Widget build(BuildContext context) {
    Color textColo = const Color(0xffB5B5B5);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Notification',
          )),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomeText(
                  text: 'New Events',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                CustomeText(
                  text: 'Mark all as read',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColo,
                ),
              ],
            ),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 24),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                AppAssets.product1,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomeText(
                                text: 'Goa event',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomeText(
                                text:
                                'New nontoxic powder uses sunlight to\nquickly disinfect contaminated dr..',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColo,
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CustomeText(
                            text: '3m ago',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textColo,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CircleAvatar(
                            maxRadius: size.height * 0.03,
                            backgroundColor: Colors.transparent,
                            backgroundImage: const AssetImage(AppAssets.userImage),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomeText(
                  text: 'New Feed update',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                CustomeText(
                  text: 'Mark all as read',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColo,
                ),
              ],
            ),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 24),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                AppAssets.product1,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomeText(
                                text: 'New Feed',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textColo,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomeText(
                                text:
                                    'New nontoxic powder uses sunlight to\nquickly disinfect contaminated dr..',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColo,
                              )
                            ],
                          )
                        ],
                      ),
                      CustomeText(
                        text: '3m ago',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColo,
                      ),
                    ],
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
