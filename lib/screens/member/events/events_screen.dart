import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/controllers/member/events/events_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/models/member/events/events_model.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_text_field.dart';

import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

List eventFeedbackOptions = ['I Will Attend', 'Attend with others', 'Not interested'];

class EventScreen extends StatefulWidget {
  const EventScreen({
    super.key,
    this.eventId,
    this.filter,
    this.viewAll,
  });

  final num? eventId;
  final String? filter;
  final bool? viewAll;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late bool? viewAll = widget.viewAll;
  late num? eventId = widget.eventId;
  TextEditingController searchController = TextEditingController();
  List<EventsData>? events;
  late String? filter = widget.filter;
  Timer? _debounce;

  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchEvents();

      setState(() {});
    });
  }

  Future fetchEvents({bool? loadingNext}) async {
    return await context.read<EventsControllers>().fetchEvents(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          searchKey: searchController.text,
          eventId: eventId,
          filter: filter,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<EventsControllers>(
      builder: (context, controller, child) {
        events = controller.events;
        return SmartRefresher(
          controller: controller.eventsController,
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: () async {
            if (mounted) {
              await fetchEvents();
            }
          },
          onLoading: () async {
            if (mounted) {
              await fetchEvents(loadingNext: true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: const CustomBackButton(),
              title: const Text('Events'),
              actions: [
                if (viewAll == true)
                  TextButton(
                    onPressed: () {
                      context.pop();
                      context.pushNamed(Routs.events);
                    },
                    child: const Text('View All'),
                  )
              ],
            ),
            body: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: kPadding, top: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          hintText: 'Search',
                          controller: searchController,
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: ImageView(
                            height: 20,
                            width: 20,
                            borderRadiusValue: 0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: kPadding, right: kPadding),
                            fit: BoxFit.contain,
                            assetImage: AppAssets.searchIcon,
                            onTap: () {
                              fetchEvents();
                            },
                          ),
                          onChanged: (val) async {
                            onSearchFieldChanged(val);
                          },
                          onEditingComplete: () {
                            fetchEvents();
                          },
                          margin: const EdgeInsets.only(left: kPadding, right: kPadding),
                        ),
                      ),
                      CustomPopupMenu(
                        items: [
                          CustomPopupMenuEntry(
                            value: '',
                            label: 'All',
                            onPressed: () {
                              filter = null;
                            },
                          ),
                          CustomPopupMenuEntry(
                            label: 'This Week',
                            onPressed: null,
                          ),
                          CustomPopupMenuEntry(
                            label: 'This Month',
                            onPressed: null,
                          ),
                          CustomPopupMenuEntry(
                            label: 'This Year',
                            onPressed: null,
                          ),
                        ],
                        onChange: (String? val) {
                          filter = val;
                          setState(() {});
                          fetchEvents();
                        },
                        child: GradientButton(
                          height: 60,
                          width: 60,
                          margin: const EdgeInsets.only(right: kPadding),
                          backgroundGradient: blackGradient,
                          child: const ImageView(
                            height: 28,
                            width: 28,
                            assetImage: AppAssets.filterIcons,
                            margin: EdgeInsets.zero,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (controller.loadingEvents)
                  const LoadingScreen(
                    heightFactor: 0.7,
                    message: 'Loading Events...',
                  )
                else if (events.haveData)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events?.length ?? 0,
                    padding: const EdgeInsets.only(bottom: bottomNavbarSize),
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = events?.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          // context.pushNamed(Routs.productDetail);
                        },
                        child: EventCard(
                          index: index,
                          data: data,
                        ),
                      );
                    },
                  )
                else
                  NoDataFound(
                    heightFactor: 0.7,
                    message: controller.eventsModel?.message ?? 'No Events Found',
                  ),
              ],
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientButton(
                  height: 70,
                  borderRadius: 18,
                  backgroundGradient: primaryGradient,
                  backgroundColor: Colors.transparent,
                  boxShadow: const [],
                  margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                  onTap: () async {
                    context.pushReplacementNamed(Routs.createEvent);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Event',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: GoogleFonts.urbanist().fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final double? imageHeight;
  final BoxFit? fit;

  final int index;

  final num? eventId;
  final EventsData? data;

  const EventCard(
      {super.key, this.imageHeight, this.fit, required this.index, required this.data, this.eventId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (data?.eventLink != null) {
          launchUrlString(data?.eventLink);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
        decoration: BoxDecoration(
          gradient: feedsCardGradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ImageView(
                borderRadiusValue: 16,
                margin: const EdgeInsets.all(12),
                fit: fit ?? BoxFit.cover,
                networkImage: '${data?.image}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      data?.description ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: kPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FeedMenu(
                              icon: AppAssets.eventIcon,
                              value: data?.startDate ?? '',
                            ),
                            FeedMenu(
                              icon: AppAssets.clockIcon,
                              value: data?.startTime ?? '',
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Type of Events: ${data?.type ?? ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: kPadding),
                    child: SizedBox(
                      height: 35,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: eventFeedbackOptions.length ?? 0,
                        itemBuilder: (context, index) {
                          var feedback = eventFeedbackOptions.elementAt(index);
                          return GradientButton(
                            width: size.width * 0.4,
                            borderRadius: 50,
                            margin: const EdgeInsets.only(right: kPadding),
                            border: feedback == 'I Will Attend' ? null : Border.all(color: Colors.grey),
                            backgroundGradient: feedback == 'I Will Attend' ? primaryGradient : blackGradient,
                            onTap: () async {
                              await context.read<GuestControllers>().attendEvent(
                                    context: context,
                                    eventId: '$eventId',
                                    feedback: feedback,
                                  );
                            },
                            child: Center(
                              child: Text(
                                '$feedback',
                                style: TextStyle(
                                  color: feedback == 'I Will Attend' ? Colors.black : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FeedMenu extends StatelessWidget {
  const FeedMenu({
    super.key,
    required this.icon,
    this.value,
    this.onTap,
    this.lastMenu,
    this.fontSize,
  });

  final String icon;
  final String? value;
  final bool? lastMenu;
  final double? fontSize;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: lastMenu != true ? kPadding : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageView(
            height: 12,
            width: 12,
            borderRadiusValue: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(right: 4),
            fit: BoxFit.contain,
            onTap: onTap,
            assetImage: icon,
          ),
          if (value != null)
            Text(
              '$value',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize ?? 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
