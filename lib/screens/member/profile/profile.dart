import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/profile/watch_video_count.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/member/leads/leads_controllers.dart';
import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/guestProfileDetailsFor/guestProfileDetailFor.dart';
import '../../../models/member/leads/leads_member_details.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../../guest/guest_check_demo/guest_check_demo_step2.dart';

class GuestProfileDetails extends StatefulWidget {
  const GuestProfileDetails({super.key, this.guestId});

  final String? guestId;

  @override
  State<GuestProfileDetails> createState() => _GuestProfileDetailsState();
}

class _GuestProfileDetailsState extends State<GuestProfileDetails> {
  late String? guestId = widget.guestId;
  Color? textColor = const Color(0xFFDCDCDC);
  int _index = 0;

  GuestProfileDetailFor? guestProfileDetails;

  Future fetchGuestProfileDetails({bool? loadingNext}) async {
    return await context
        .read<ListsControllers>()
        .fetchGuestProfileDetails(guestId: guestId);
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
        List<Step> steps = [
          if (guestProfileDetails?.data?.leadJourney?.addedInNewList
                  .toString() !=
              '')
            Step(
                isActive: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText1(
                      text: 'Added in new listed',
                      fontSize: 16,
                    ),
                    CustomText1(
                      text:
                          '${guestProfileDetails?.data?.leadJourney?.addedInNewList}',
                    ),
                  ],
                ),
                content: SizedBox.shrink()),
          if (guestProfileDetails?.data?.leadJourney?.moveToInvitationCall
                  .toString() !=
              '')
            Step(
                isActive: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText1(
                      text: 'Move to Invitation call',
                      fontSize: 16,
                      color: textColor,
                    ),
                    CustomText1(
                      text:
                          '${guestProfileDetails?.data?.leadJourney?.moveToInvitationCall}',
                      fontSize: 14,
                      color: textColor,
                    )
                  ],
                ),
                content: const SizedBox.shrink()),
          if (guestProfileDetails?.data?.leadJourney?.businessDemoMeeting
                  .toString() !=
              '')
            Step(
              isActive: false,
              title: Column(
                children: [
                  CustomText1(
                    text: 'Business Demo meeting',
                    fontSize: 16,
                    color: textColor,
                  ),
                  CustomText1(
                    text:
                        '${guestProfileDetails?.data?.leadJourney?.businessDemoMeeting}',
                    fontSize: 14,
                    color: textColor,
                  )
                ],
              ),
              content: SizedBox.shrink(),
            ),
          if (guestProfileDetails?.data?.leadJourney?.productDemoMeeting
                  .toString() !=
              '')
            Step(
                isActive: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText1(
                      text: 'Product Demo meeting',
                      fontSize: 16,
                      color: textColor,
                    ),
                    CustomText1(
                      text:
                          '${guestProfileDetails?.data?.leadJourney?.productDemoMeeting}',
                      fontSize: 14,
                      color: textColor,
                    )
                  ],
                ),
                content: SizedBox.shrink()),
          if (guestProfileDetails?.data?.leadJourney?.followUp.toString() != '')
            Step(
              isActive: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText1(
                    text: 'Follow up',
                    fontSize: 16,
                    color: textColor,
                  ),
                  CustomText1(
                    text: '${guestProfileDetails?.data?.leadJourney?.followUp}',
                    fontSize: 14,
                    color: textColor,
                  )
                ],
              ),
              content: SizedBox.shrink(),
            ),
          if (guestProfileDetails?.data?.leadJourney?.moveToClosing
                  .toString() !=
              '')
            Step(
                isActive: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText1(
                      text: 'Move to closing',
                      fontSize: 16,
                      color: textColor,
                    ),
                    CustomText1(
                      text:
                          '${guestProfileDetails?.data?.leadJourney?.moveToClosing}',
                      fontSize: 14,
                      color: textColor,
                    )
                  ],
                ),
                content: SizedBox.shrink()),
        ];
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

            // physics: const BouncingScrollPhysics(),
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
                          guestProfileDetails?.data?.profilePhoto.toString() != 'null' ? ImageView(
                            networkImage: guestProfileDetails?.data?.profilePhoto,
                            height: size.height * 0.13,
                            isAvatar: true,
                            borderRadiusValue: 50,
                          )
                              : CircleAvatar(
                                  backgroundImage:
                                      const AssetImage(AppAssets.memberprofile),
                                  maxRadius: size.height * 0.08,
                                ),
                          CustomeText(
                            text:
                                '${guestProfileDetails?.data?.firstName ?? ''} ${guestProfileDetails?.data?.lastName ?? ''}',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomeText(
                            text:
                                '+91 ${guestProfileDetails?.data?.mobile ?? ''}',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          CustomeText(
                            text: '${guestProfileDetails?.data?.address ?? ''}',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: kPadding, right: kPadding),
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
                                ProfileWatch(
                                  value:
                                      '${guestProfileDetails?.data?.watchedVideosCount ?? '0'}',
                                  subHeading: 'Watch\nVideos',
                                  textColor: true,
                                ),
                                ProfileWatch(
                                  value:
                                      '${guestProfileDetails?.data?.pendingVideosCount ?? '0'}',
                                  subHeading: 'Pending\nVideos',
                                  colors: [Colors.white],
                                ),
                                ProfileWatch(
                                  value:
                                      guestProfileDetails?.data?.watchCount ??
                                          '0',
                                  subHeading: 'Watch\nCount',
                                  colors: const [Colors.white],
                                  onTap: () {
                                    context.pushNamed(Routs.watchVideoCount,
                                        extra: WatchVideoCount(
                                          guestProfileDetails:
                                              guestProfileDetails,
                                        ));
                                  },
                                  showArrow: true,
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: kPadding,
                                  right: kPadding,
                                  bottom: kPadding),
                              child: CustomeText(
                                text: 'Watched Video',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (steps.isNotEmpty == true)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Stepper(
                              currentStep: _index,
                              onStepCancel: () {
                                if (_index > 0) {
                                  setState(() {
                                    _index -= 1;
                                  });
                                }
                              },
                              onStepContinue: () {
                                if (_index <= 0) {
                                  setState(() {
                                    _index += 1;
                                  });
                                }
                              },
                              onStepTapped: (int index) {
                                setState(() {
                                  _index = index;
                                });
                              },
                              controlsBuilder: (context, details) {
                                return Container();
                              },
                              steps: steps,
                            );
                          },
                        )
                      else
                        NoDataFound(
                          heightFactor: 0.7,
                          message:
                              controller.guestProfileDetailsModel?.message ??
                                  'No Data Found ',
                        ),
                    ],
                  ),
                )
              else
                NoDataFound(
                  heightFactor: 0.7,
                  message: controller.guestProfileDetailsModel?.message ??
                      'No Guest Found',
                ),
            ],
          ),
          bottomSheet: (guestProfileDetails?.data?.mobile != null)
              ? GestureDetector(
                  onTap: () async {
                    await context.read<MembersController>().callUser(
                          mobileNo: guestProfileDetails?.data?.mobile ?? '',
                        );
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
                            // context.pushNamed(Routs.callender);
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
                                      colors: [
                                        Color(0xFF1B1B1B),
                                        Color(0xFF282828)
                                      ],
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

class ProfileWatch extends StatelessWidget {
  String? value;
  bool? textColor;
  bool? showArrow;
  String? subHeading;
  List<Color>? colors;
  void Function()? onTap;
  ProfileWatch({
    this.value,
    this.colors,
    this.onTap,
    this.subHeading,
    this.textColor,
    this.showArrow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(3),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size.width * 0.26,
          decoration: ShapeDecoration(
            gradient: colors != null
                ? inActiveGradient
                : const LinearGradient(colors: [
                    Color(0xFFDDA63C),
                    Color(0xFFFEDC9D),
                  ]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomeText(
                      text: value,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: textColor == true ? Colors.black : Colors.white,
                    ),
                    if (showArrow == true)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: CustomBackButton1(
                          padding: EdgeInsets.all(3),
                          icon: Feather.arrow_up_right,
                        ),
                      )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  subHeading ?? '',
                  style: TextStyle(
                    color: textColor == true ? Colors.black : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
