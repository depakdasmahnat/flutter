import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteLeadsCard extends StatelessWidget {
  const InviteLeadsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(kPadding),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: kPadding),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text(
            'Invite a Leads',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ',
              style: TextStyle(
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
                          copyText(
                              context: context,
                              textToCopy: 'GBD21',
                              message: 'Invitation "GBD21" Code copied');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageView(
                              height: 24,
                              width: 24,
                              onTap: null,
                              assetImage: AppAssets.copyIcon,
                            ),
                            Text(
                              'GBD21',
                              style: TextStyle(
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
                      Share.share('Invitation "GBD21" Code copied');
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
  }
}
