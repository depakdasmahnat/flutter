import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/models/partner/services/lead_details_model.dart';
import 'package:gaas/screens/partner/service/leads/add_reply.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/partner/service_provider_controller.dart';
import '../../../../core/constant/colors.dart';
import '../../../../core/constant/shadows.dart';
import '../../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../../utils/widgets/data_widget_builder.dart';
import '../../../../utils/widgets/image_view.dart';
import '../../../dashboard/utils/partner_services_card.dart';
import '../../../orders/utils/rate_this_order.dart';
import '../../utils/partner_app_bar.dart';

class LeadsDetail extends StatefulWidget {
  const LeadsDetail({Key? key, required this.id, this.partnerLeads}) : super(key: key);
  final num? id;
  final bool? partnerLeads;

  @override
  State<LeadsDetail> createState() => _LeadsDetailState();
}

class _LeadsDetailState extends State<LeadsDetail> {
  late num? id = widget.id;
  late bool partnerLeads = widget.partnerLeads ?? false;
  double imageRadius = 70;

  LeadData? leadDetails;

  fetchLeadDetails() {
    ServiceProviderController servicesController =
        Provider.of<ServiceProviderController>(context, listen: false);
    servicesController.fetchLeadDetails(
      context: context,
      id: id,
      partnerLeads: partnerLeads,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchLeadDetails();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ServiceProviderController controller = Provider.of<ServiceProviderController>(context);
    leadDetails = controller.leadDetail;

    return Scaffold(
      appBar: partnerAppBar(
        context: context,
        title: "${partnerLeads ? "Lead" : "Enquire"} Detail",
        onBackPress: () {
          context.pop();
        },
        actions: [],
      ),
      body: DataWidgetBuilder(
        isLoading: controller.loadingLeadDetails,
        haveData: leadDetails != null,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: defaultBoxShadow(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        ImageView(
                          height: imageRadius,
                          width: imageRadius,
                          borderRadiusValue: imageRadius,
                          networkImage: "${leadDetails?.profilePhoto}",
                          backgroundColor: Colors.white,
                          isAvatar: true,
                          boxShadow: defaultBoxShadow(),
                          fit: BoxFit.cover,
                          margin: const EdgeInsets.only(right: 16),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                leadDetails?.name ?? "",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  leadDetails?.email ?? "",
                                  style:  const TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (leadDetails?.createdAt != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    "Date :-${leadDetails?.createdAt}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: GoogleFonts.mulish().fontStyle,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 14, right: 14, top: 8),
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: defaultBoxShadow(),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                        child: Text(
                          "Service's",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      PartnerServicesCard(
                        leadDetails: leadDetails,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (leadDetails?.comment != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: defaultBoxShadow(),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Comment",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: primaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${leadDetails?.comment}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (leadDetails?.reply != null)
                                Container(
                                  height: 35,
                                  width: 1.8,
                                  margin: const EdgeInsets.only(left: 12),
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                  ),
                                ),
                              if (leadDetails?.reply != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: defaultBoxShadow(),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${partnerLeads ? "" : "Partner "}Reply",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: primaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${leadDetails?.reply}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (leadDetails?.reviewAdded == true)
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 24),
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: defaultBoxShadow(),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (partnerLeads == false) {
                          showFeedBackPopUp();
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Review",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 8),
                                    //   child: Text(
                                    //     "(${leadDetails?.reviewDetail?.rating} Stars)",
                                    //     style: const TextStyle(
                                    //       fontSize: 16,
                                    //       color: primaryColor,
                                    //       fontWeight: FontWeight.w800,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                if (partnerLeads == false)
                                  const Icon(
                                    Icons.edit,
                                    color: primaryColor,
                                  )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${leadDetails?.reviewDetail?.rating} Stars",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),

                                // const SizedBox(width: 8),
                                // RatingBar.builder(
                                //   ignoreGestures: true,
                                //   initialRating: (leadDetails?.reviewDetail?.rating ?? 0).toDouble(),
                                //   minRating: 1,
                                //   direction: Axis.horizontal,
                                //   allowHalfRating: true,
                                //   itemCount: 5,
                                //   itemSize: 24,
                                //   unratedColor: Colors.grey.shade300,
                                //   itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                                //   itemBuilder: (context, _) => const Icon(
                                //     Icons.star,
                                //     color: primaryColor,
                                //   ),
                                //   onRatingUpdate: (rating) {},
                                // ),
                              ],
                            ),
                          ),
                          Text(
                            "${leadDetails?.reviewDetail?.review}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (leadDetails?.mobile != null && leadDetails?.publicContactInfo == "Yes")
                      CustomButton(
                        height: 40,
                        width: size.width * 0.42,
                        text: "Call Now",
                        onPressed: () {
                          launchUrl(
                            Uri.parse("tel:${leadDetails?.mobile ?? ""}"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        borderRadius: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        boxShadow: defaultBoxShadow(),
                        margin: EdgeInsets.zero,
                      ),
                    if (partnerLeads && leadDetails?.reply == null)
                      CustomButton(
                        height: 40,
                        width: size.width * 0.42,
                        text: "Reply",
                        borderRadius: 5,
                        onPressed: () {
                          CustomBottomSheet.show(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: true,
                            physics: const BouncingScrollPhysics(),
                            showTitleDivider: false,
                            margin: EdgeInsets.zero,
                            body: AddReply(
                              onSuccess: () {
                                fetchLeadDetails();
                                context.pop();
                              },
                              lead: leadDetails,
                            ),
                          );
                        },
                        margin: EdgeInsets.zero,
                        boxShadow: defaultBoxShadow(),
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    if (!partnerLeads)
                      CustomButton(
                        height: 40,
                        width: size.width * 0.42,
                        text: leadDetails?.reviewAdded == true ? "Update Feedback" : "Rate this",
                        borderRadius: 5,
                        onPressed: () {
                          showFeedBackPopUp();
                        },
                        margin: EdgeInsets.zero,
                        boxShadow: defaultBoxShadow(),
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  showFeedBackPopUp() {
    return RateThisOrder.show(
      context: context,
      onSuccess: () {
        context.pop();
        fetchLeadDetails();
      },
      id: leadDetails?.id,
      partnerId: leadDetails?.partnerId,
      reviewAdded: leadDetails?.reviewAdded,
      reviewDetail: leadDetails?.reviewDetail,
      leadsReview: partnerLeads,
    );
  }
}
