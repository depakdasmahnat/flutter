import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/normal/build_context_extension.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/route/route_config.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/screens/services/request_quote.dart';
import 'package:gaas/screens/services/review_screen.dart';
import 'package:gaas/utils/widgets/image_opener.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:gaas/utils/widgets/multiple_image_opener.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../controllers/services_controller.dart';
import '../../core/functions.dart';
import '../../models/dashboard/service/service_provider_detail.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/data_widget_builder.dart';
import '../../utils/widgets/widgets.dart';
import '../dashboard/utils/user_service_card.dart';
import '../orders/utils/rate_this_order.dart';
import '../partner/service/leads/leads_screen.dart';

class ServiceProviderDetailScreen extends StatefulWidget {
  const ServiceProviderDetailScreen({Key? key, this.id}) : super(key: key);
  final num? id;

  @override
  State<ServiceProviderDetailScreen> createState() => _ServiceProviderDetailScreenState();
}

class _ServiceProviderDetailScreenState extends State<ServiceProviderDetailScreen> {
  late num? id = widget.id;

  ServiceProviderData? serviceProviderDetail;

  fetchServiceProviderDetail() {
    ServicesController servicesController = Provider.of<ServicesController>(context, listen: false);
    servicesController.fetchServiceProviderDetail(context: context, id: id);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchServiceProviderDetail();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ServicesController controller = Provider.of<ServicesController>(context);
    serviceProviderDetail = controller.serviceProviderDetailData;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,

        title: const Text("Service Provider Detail"),
        centerTitle: true,
      ),
      body: DataWidgetBuilder(
        isLoading: controller.loadingServiceProviderDetail,
        haveData: serviceProviderDetail != null,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ServiceProviderCard(
              serviceProvider: serviceProviderDetail,
              borderRadius: 12,
              boxShadow: defaultBoxShadow(),
              detailsCard: true,
              onTap: () {
                if ((serviceProviderDetail?.rating ?? 0) > 0) {
                  context.push(Routs.reviewScreen,
                      extra: ReviewScreen(
                        id: serviceProviderDetail?.id,
                      ));
                }
              },
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            ),
            // if (serviceProviderDetail?.about != null)
            //   Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //     margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       boxShadow: defaultBoxShadow(),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "About",
            //           style: Theme.of(context).textTheme.titleMedium,
            //         ),
            //         const SizedBox(height: 8),
            //         Text(
            //           "${serviceProviderDetail?.about}",
            //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            //         ),
            //       ],
            //     ),
            //   ),

            if (serviceProviderDetail?.reviewAdded == false)
              CustomButton(
                height: 40,
                width: size.width * 0.92,
                text: "Rate this",
                borderRadius: 5,
                onPressed: () {
                  showFeedBackPopUp();
                },
                margin: const EdgeInsets.only(bottom: 12),
                boxShadow: defaultBoxShadow(),
                mainAxisAlignment: MainAxisAlignment.center,
              )
            else
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: defaultBoxShadow(),
                ),
                child: InkWell(
                  onTap: () {
                    showFeedBackPopUp();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                            Icon(
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
                                  "${serviceProviderDetail?.reviewDetail?.rating ?? 0} Stars",
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
                      if (serviceProviderDetail?.reviewDetail?.review != null)
                        Text(
                          serviceProviderDetail?.reviewDetail?.review ?? "",
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
            if (serviceProviderDetail?.services.haveData == true)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Text(
                        "Services",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),

                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: serviceProviderDetail?.services?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          var data = serviceProviderDetail?.services?.elementAt(index);

                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<AuthControllers>()
                                  .authRequired(context: context, message: 'Please log in to request quote.');

                              context.pushNamed(
                                Routs.requestQuote,
                                extra: RequestQuote(
                                  selectedService: data,
                                  onSuccess: () {
                                    context.firstRoute();
                                    context.pushNamed(Routs.leads,
                                        extra: const LeadsScreen(partnerLeads: false));
                                  },
                                  serviceProvider: serviceProviderDetail,
                                ),
                              );
                              // CustomBottomSheet.show(
                              //   context: context,
                              //   isScrollControlled: true,
                              //   enableDrag: true,
                              //   physics: const BouncingScrollPhysics(),
                              //   showTitleDivider: false,
                              //   margin: EdgeInsets.zero,
                              //   title: "Request Quote",
                              //   centerTitle: true,
                              //   body: RequestQuote(
                              //     selectedService: data,
                              //     onSuccess: () {
                              //       context.firstRoute();
                              //       context.pushNamed(Routs.leads,
                              //           extra: const LeadsScreen(partnerLeads: false));
                              //     },
                              //     serviceProvider: serviceProviderDetail,
                              //   ),
                              // );
                            },
                            child: Container(
                              width: 150,
                              margin:
                                  EdgeInsets.only(left: index == 0 ? 16 : 0, right: 16, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade100),
                                boxShadow: defaultBoxShadow(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ImageView(
                                    height: 100,
                                    width: 100,
                                    networkImage: "${data?.serviceImage}",
                                    border: Border.all(color: Colors.grey.shade100),
                                    fit: BoxFit.cover,
                                    backgroundColor: Colors.white,
                                    borderRadiusValue: 100,
                                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                                    child: Text(
                                      "${data?.name}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "\$${data?.amount}",
                                        style: const TextStyle(
                                            color: primaryColor, fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        data?.unit != null ? " / ${data?.unit}" : "",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: serviceProviderDetail?.services?.length ?? 0,
                    //   itemBuilder: (context, index) {
                    //     bool lastIndex = ((serviceProviderDetail?.services?.length ?? 0) - 1) == index;
                    //     var data = serviceProviderDetail?.services?.elementAt(index);
                    //     return Column(
                    //       children: [
                    //         ListTile(
                    //           dense: true,
                    //           contentPadding: const EdgeInsets.only(),
                    //           onTap: () {
                    //             ServicesController servicesController =
                    //                 Provider.of<ServicesController>(context, listen: false);
                    //
                    //             servicesController.updateServicesStatus(
                    //               serviceId: data?.id,
                    //               selected: data?.selected ?? false,
                    //             );
                    //           },
                    //           title: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Icon(data?.selected == true ? Icons.check_circle : Icons.radio_button_off,
                    //                   color: data?.selected == true ? primaryColor : Colors.black),
                    //               const SizedBox(width: 8),
                    //               Expanded(
                    //                 child: Text("${data?.name}"),
                    //               ),
                    //             ],
                    //           ),
                    //           trailing: Text(
                    //             "\$${data?.amount}",
                    //             style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                    //           ),
                    //         ),
                    //         if (!lastIndex) const Divider(height: 1)
                    //       ],
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            if (serviceProviderDetail?.serviceImages.haveData == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultBoxShadow(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Photo",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    AspectRatio(
                      aspectRatio: 4,
                      child: ListView.builder(
                        itemCount: serviceProviderDetail?.serviceImages?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = serviceProviderDetail?.serviceImages?.elementAt(index);
                          List<String?>? images =
                              serviceProviderDetail?.serviceImages?.map((e) => e.image).toList();
                          return ImageView(
                            networkImage: data?.image,
                            boxShadow: defaultBoxShadow(),
                            backgroundColor: Colors.white,
                            borderRadiusValue: 12,
                            margin: const EdgeInsets.only(right: 12),
                            onTap: () {
                              context.pushNamed(Routs.multipleImageOpener,
                                  extra: MultipleImageOpener(
                                    initialIndex: index,
                                    networkImages: images,
                                  ));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: serviceProviderDetail != null
          ? Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (serviceProviderDetail?.showContacts == 'Yes')
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          launchUrl(
                            Uri.parse("tel:${serviceProviderDetail?.mobile ?? ""}"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (serviceProviderDetail?.showContacts == 'Yes')
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          launchUrl(
                            Uri.parse(
                                "mailto:${serviceProviderDetail?.email ?? ""}?subject=hi ${serviceProviderDetail?.name}&body="),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: CustomButton(
                      height: 50,
                      text: "Request Quote",
                      fontSize: 14,
                      mainAxisAlignment: MainAxisAlignment.center,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                        context
                            .read<AuthControllers>()
                            .authRequired(context: context, message: 'Please log in to request quote.');

                        context.pushNamed(
                          Routs.requestQuote,
                          extra: RequestQuote(
                            onSuccess: () {
                              context.firstRoute();
                              context.pushNamed(Routs.leads, extra: const LeadsScreen(partnerLeads: false));
                            },
                            serviceProvider: serviceProviderDetail,
                          ),
                        );

                        // CustomBottomSheet.show(
                        //   context: context,
                        //   isScrollControlled: true,
                        //   enableDrag: true,
                        //   physics: const BouncingScrollPhysics(),
                        //   showTitleDivider: false,
                        //   margin: EdgeInsets.zero,
                        //   title: "Request Quote",
                        //   centerTitle: true,
                        //   body: RequestQuote(
                        //     onSuccess: () {
                        //       context.firstRoute();
                        //       context.pushNamed(Routs.leads, extra: const LeadsScreen(partnerLeads: false));
                        //     },
                        //     serviceProvider: serviceProviderDetail,
                        //   ),
                        // );
                      },
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  showFeedBackPopUp() {
    return RateThisOrder.show(
      context: context,
      onSuccess: () {
        context.pop();
        fetchServiceProviderDetail();
      },
      partnerId: serviceProviderDetail?.id,
      reviewAdded: serviceProviderDetail?.reviewAdded,
      reviewDetail: serviceProviderDetail?.reviewDetail,
      leadsReview: true,
    );
  }
}
