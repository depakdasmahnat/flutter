import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../models/member/genrate_referal/genrateReferralModel.dart';

class InviteLeadsCard extends StatefulWidget {
  const InviteLeadsCard({super.key});

  @override
  State<InviteLeadsCard> createState() => _InviteLeadsCardState();
}

class _InviteLeadsCardState extends State<InviteLeadsCard> {
  GenrateReferralModel? generateReferralModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MembersController>().fetchReferral(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembersController>(builder: (context, controller, child) {
      generateReferralModel = controller.generateReferralModel;
      String? referCode = generateReferralModel?.data?.referCode;
      return controller.generateRefLoader == false
          ? const LoadingScreen(
              heightFactor: 0.2,
            )
          : Container(
              margin: const EdgeInsets.all(kPadding),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: kPadding),
              decoration: BoxDecoration(
                gradient: primaryGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    generateReferralModel?.data?.title ?? 'Invite a Leads',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      generateReferralModel?.data?.message ??
                          "Unlock endless opportunities! Join Global Team Pinnacle by downloading our app today with the referral code [$referCode]. Let's embark on a journey of growth and success together. See you on the inside!",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: kPadding),
                            child: DottedBorder(
                              dashPattern: const [4, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(50),
                              color: Colors.black,
                              child: GradientButton(
                                height: 46,
                                backgroundGradient: primaryGradient,
                                borderRadius: 50,
                                margin: EdgeInsets.zero,
                                onTap: () {
                                  if (referCode != null) {
                                    copyText(
                                      context: context,
                                      textToCopy: referCode,
                                      message: generateReferralModel?.data?.shareMessage ?? '',
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const ImageView(
                                      height: 24,
                                      width: 24,
                                      onTap: null,
                                      assetImage: AppAssets.copyIcon,
                                    ),
                                    Text(
                                      referCode ?? '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GradientButton(
                            height: 50,
                            backgroundColor: Colors.black,
                            border: Border.all(color: Colors.black),
                            borderRadius: 50,
                            margin: const EdgeInsets.only(left: kPadding),
                            onTap: () {
                              if (generateReferralModel?.data?.shareMessage != null) {
                                Share.share(generateReferralModel?.data?.shareMessage ?? '');
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Invite Leads',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
    });
  }
}
