import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/member/leads/leads_controllers.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/member/leads/leads_member_details.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../guest/guestProfile/guest_faq.dart';

class GuestProfileDetails extends StatefulWidget {
  const GuestProfileDetails({super.key, this.guestId});

  final String? guestId;

  @override
  State<GuestProfileDetails> createState() => _GuestProfileDetailsState();
}

class _GuestProfileDetailsState extends State<GuestProfileDetails> {
  late String? guestId = widget.guestId;

  GuestProfileDetailsData? guestProfileDetails;

  Future fetchGuestProfileDetails({bool? loadingNext}) async {
    return await context.read<ListsControllers>().fetchGuestProfileDetails(guestId: guestId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchGuestProfileDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ListsControllers>(
      builder: (context, controller, child) {
        guestProfileDetails = controller.guestProfileDetails;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const Column(
              children: [
                CustomBackButton(),
              ],
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              if (controller.loadingGuestProfileDetails)
                const LoadingScreen(
                  heightFactor: 0.7,
                  message: 'Loading Profile...',
                )
              else if (guestProfileDetails != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: const AssetImage(AppAssets.memberprofile),
                            maxRadius: size.height * 0.08,
                          ),
                          CustomeText(
                            text:
                                '${guestProfileDetails?.firstName ?? ''} ${guestProfileDetails?.lastName ?? ''}',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomeText(
                            text: '+91 ${guestProfileDetails?.mobile ?? ''}',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          CustomeText(
                            text: '${guestProfileDetails?.address ?? ''}',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: kPadding, right: kPadding),
                              child: CustomeText(
                                text: 'Watched Demo Video',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(kPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomeText(
                                      text: '${guestProfileDetails?.watchedVideosCount ?? '0'}',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomeText(
                                      text: 'Watch Videos',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.09,
                                  child: const VerticalDivider(
                                    thickness: 0.5,
                                    color: Color(0xFF4D4D4D),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomeText(
                                      text: '${guestProfileDetails?.pendingVideosCount ?? '0'}',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomeText(
                                      text: 'Pending Videos',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.09,
                                  child: const VerticalDivider(
                                    thickness: 0.5,
                                    color: Color(0xFF4D4D4D),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomeText(
                                      text: guestProfileDetails?.watchCount ?? '0',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomeText(
                                      text: 'Watch Count',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                              child: CustomeText(
                                text: 'Watched Video',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (guestProfileDetails?.watchedVideos.haveData == true)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: guestProfileDetails?.watchedVideos?.length ?? 0,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: size.height * 0.1, left: 8, right: 8),
                          itemBuilder: (context, index) {
                            var data = guestProfileDetails?.watchedVideos?.elementAt(index);
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
                        )
                      else
                        const NoDataFound(
                          heightFactor: 0.4,
                          message: 'No Watched Videos Found',
                        )
                    ],
                  ),
                )
              else
                NoDataFound(
                  heightFactor: 0.7,
                  message: controller.guestProfileDetailsModel?.message ?? 'No Guest Found',
                ),
            ],
          ),
          bottomSheet: (guestProfileDetails?.mobile != null)
              ? GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse('tel:${guestProfileDetails?.mobile ?? ''}'));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                        child: GradientButton(
                          height: 70,
                          borderRadius: 18,
                          backgroundGradient: primaryGradient,
                          backgroundColor: Colors.transparent,
                          boxShadow: const [],
                          margin: const EdgeInsets.only(left: 16, right: 24),
                          onTap: () {
                            context.pushNamed(Routs.callender);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Call for Demo',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.urbanist().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
                                    ),
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    AppAssets.call,
                                    height: size.height * 0.02,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
