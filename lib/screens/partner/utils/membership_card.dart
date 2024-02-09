import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/membership_controller.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/payments/stripe_controller.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../core/enums/enums.dart';
import '../../../models/partner/dummy_membership_data.dart';
import '../../../models/partner/membership/subscriptions_model.dart';
import '../../../utils/widgets/custom_button.dart';

class MembershipCard extends StatefulWidget {
  const MembershipCard({
    Key? key,
    required this.showMore,
    required this.data,
    required this.perks,
    required this.type,
    required this.route,
  }) : super(key: key);
  final bool? showMore;

  final String? route;
  final ServiceType? type;
  final SubscriptionsData? data;
  final List<PerksData>? perks;

  @override
  State<MembershipCard> createState() => _MembershipCardState();
}

class _MembershipCardState extends State<MembershipCard> {
  late bool showMore = widget.showMore ?? false;
  late String? route = widget.route;
  late ServiceType? type = widget.type;
  late SubscriptionsData? data = widget.data;
  late List<PerksData>? perks = widget.perks;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showMore = !showMore;
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(12),
              boxShadow: defaultBoxShadow(),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 20,
                backgroundColor: primaryColor,
                child: ImageView(
                  height: 24,
                  width: 24,
                  assetImage: AppImages.appIcon,
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                ),
              ),
              title: Text(
                "${data?.title}",
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // subtitle: Text(
              //   "${data?.description}",
              //   style: const TextStyle(
              //     color: Colors.black,
              //     fontSize: 10,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
              trailing: CircleAvatar(
                radius: 16,
                backgroundColor: primaryColor.withOpacity(0.2),
                child: Center(
                  child: Icon(
                    showMore ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_outlined,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showMore == true)
          Column(
            children: [
              const Text(
                "INVEST IN",
                style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const ImageView(
                height: 60,
                width: 60,
                assetImage: AppImages.appIcon,
                margin: EdgeInsets.only(bottom: 4),
              ),
              Text(
                "${data?.title}".toUpperCase(),
                style: const TextStyle(color: primaryColor, fontSize: 42, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              Text(
                "to feel like a Vip",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Container(
                margin: const EdgeInsets.only(left: 36, right: 36, top: 24, bottom: 18),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: defaultBoxShadow(),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "\$${data?.amount}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 42, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(width: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "\$${data?.oldAmount ?? 0}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                Text(
                                  "for ${data?.days} Days",
                                  style: TextStyle(
                                      color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w800),
                                ),
                              ],
                            )
                          ],
                        ),
                        CustomButton(
                          height: 45,
                          text: "Join",
                          backgroundColor: primaryColor,
                          fontSize: 18,
                          onPressed: () {
                            joinMemberShip();
                          },
                          mainAxisAlignment: MainAxisAlignment.center,
                          margin: const EdgeInsets.only(bottom: 14, top: 6),
                        )
                      ],
                    ),
                    Positioned(
                      top: -32,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          "Special price for your".toUpperCase(),
                          style:
                              const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: primaryColor, size: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "BENEFITS",
                      style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.star, color: primaryColor, size: 20),
                ],
              ),
            ],
          ),
        if (showMore == true && perks?.haveData == true)
          ListView.builder(
            shrinkWrap: true,
            itemCount: perks?.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            itemBuilder: (context, index) {
              var data = perks?.elementAt(index);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: primaryColor,
                      child: ImageView(
                        height: 24,
                        width: 24,
                        assetImage: AppImages.crown,
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data?.title}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          // SizedBox(
                          //   width: size.width * 0.76,
                          //   child: Text(
                          //     "${data?.description}",
                          //     style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
                          //   ),
                          // )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
      ],
    );
  }

  Future joinMemberShip() async {
    if (data != null) {
      context.read<StripeController>().initPaymentSheet(
            context: context,
            data: data,
            route: route,
            currency: AppConfig.currency,
          );
    }
  }
}
