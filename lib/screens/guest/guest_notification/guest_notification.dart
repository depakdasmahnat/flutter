import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../utils/widgets/appbar.dart';
import '../guest_check_demo/guest_check_demo_step2.dart';

class GuestNotification extends StatefulWidget {
  const GuestNotification({super.key});

  @override
  State<GuestNotification> createState() => _GuestNotificationState();
}

class _GuestNotificationState extends State<GuestNotification> {
  bool? expend = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<GuestControllers>().fetchNotification(context: context);
    });
  }
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
        child: Consumer<GuestControllers>(
          builder: (context, controller, child) {
            return controller.notificationLoader == false
                ? const LoadingScreen()
                : controller.fetchNotificationModel
                ?.eventNotification?.isNotEmpty==true &&controller.fetchNotificationModel
                ?.otherNotification?.isNotEmpty ==true ?
            ListView(
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
                        itemCount: controller.fetchNotificationModel
                                ?.eventNotification?.length ??
                            0,
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
                                        child: controller
                                                    .fetchNotificationModel
                                                    ?.eventNotification?[index]
                                                    .image ==
                                                null
                                            ? Image.asset(
                                                AppAssets.product1,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                '${controller.fetchNotificationModel?.eventNotification?[index].image}',
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomeText(
                                          text:
                                              '${controller.fetchNotificationModel?.eventNotification?[index].title}',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.55,
                                          child: CustomText1(
                                            text:
                                                '${controller.fetchNotificationModel?.eventNotification?[index].description}',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: textColo,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                CustomeText(
                                  text:
                                      '${controller.fetchNotificationModel?.eventNotification?[index].sentAt}',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textColo,
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
                        itemCount: controller.fetchNotificationModel
                                ?.otherNotification?.length ??
                            0,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 24),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: ClipRRect(borderRadius: BorderRadius.circular(14),
                                          clipBehavior: Clip.antiAlias,
                                          child: controller.fetchNotificationModel?.otherNotification?[
                                                          index]
                                                      .image ==
                                                  null
                                              ? Image.asset(
                                                  AppAssets.product1,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  '${controller.fetchNotificationModel?.otherNotification?[index].image}',
                                                  fit: BoxFit.cover,
                                                )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomeText(
                                          text:
                                              '${controller.fetchNotificationModel?.otherNotification?[index].title}',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: textColo,
                                        ),
                                        SizedBox(
                                          width: size.width*0.5,
                                          child: ExpandableText(
                                            '${controller.fetchNotificationModel?.otherNotification?[index].description}',
                                            expandText: 'more',
                                            collapseText: 'less',
                                            maxLines: 2,
                                            linkColor: Colors.blue,
                                          ),
                                        ),
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
                  ):const Center(
              child: NoDataFound(),
            );
          },
        ),
      ),
    );
  }
}
