import 'package:flutter/material.dart';
import 'package:mrwebbeast/controllers/member/events/events_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/models/member/events/events_model.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({
    super.key,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  TextEditingController searchController = TextEditingController();
  List<EventsData>? events;

  Future fetchEvents({bool? loadingNext}) async {
    return await context.read<EventsControllers>().fetchEvents(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          searchKey: searchController.text,
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
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                // const Padding(
                //   padding: EdgeInsets.only(
                //     left: kPadding,
                //     top: kPadding,
                //   ),
                //   child: Row(
                //     children: [
                //       Text(
                //         'Upcoming Events',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w700,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Row(
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
                        onEditingComplete: () {
                          fetchEvents();
                        },
                        margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                      ),
                    ),
                    GradientButton(
                      height: 60,
                      width: 60,
                      margin: const EdgeInsets.only(left: 8, right: kPadding),
                      backgroundGradient: blackGradient,
                      child: const ImageView(
                        height: 28,
                        width: 28,
                        assetImage: AppAssets.filterIcons,
                        margin: EdgeInsets.zero,
                      ),
                    )
                  ],
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

  final EventsData? data;

  const EventCard({super.key, this.imageHeight, this.fit, required this.index, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text(
                  data?.description ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
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
              ],
            ),
          )
        ],
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
  });

  final String icon;
  final String? value;
  final bool? lastMenu;
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
