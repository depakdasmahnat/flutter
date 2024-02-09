import 'package:flutter/material.dart';
import 'package:gaas/controllers/services_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/services/utils/rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/partner/services/partner_reviews.dart';
import '../../utils/widgets/data_widget_builder.dart';
import 'utils/rating_card.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key, this.id}) : super(key: key);
  final num? id;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late num? id = widget.id;
  RefreshController reviewController = RefreshController(initialRefresh: false);

  PartnerReviewsData? partnerReviews;
  List<ReviewList>? reviewList;

  fetchPartnerReviews({bool? loadingNext}) {
    ServicesController controller = Provider.of<ServicesController>(context, listen: false);
    controller.fetchPartnerReviews(
      context: context,
      partnerId: id,
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
      controller: reviewController,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchPartnerReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    ServicesController controller = Provider.of<ServicesController>(context);
    partnerReviews = controller.partnerReviews?.data;
    reviewList = controller.reviewList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
      ),
      body: SmartRefresher(
        controller: reviewController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            await fetchPartnerReviews();
          }
        },
        onLoading: () async {
          await fetchPartnerReviews(loadingNext: true);
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${partnerReviews?.rating ?? 0}",
                              style: const TextStyle(
                                fontSize: 44,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "/5",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Top Seller",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        RatingBarLine(
                            totalStars: 5, percentage: (partnerReviews?.fiveRatingPercent ?? 0).toDouble()),
                        RatingBarLine(
                            totalStars: 4, percentage: (partnerReviews?.fourRatingPercent ?? 0).toDouble()),
                        RatingBarLine(
                            totalStars: 3, percentage: (partnerReviews?.threeRatingPercent ?? 0).toDouble()),
                        RatingBarLine(
                            totalStars: 2, percentage: (partnerReviews?.twoRatingPercent ?? 0).toDouble()),
                        RatingBarLine(
                            totalStars: 1, percentage: (partnerReviews?.oneRatingPercent ?? 0).toDouble()),
                      ],
                    ),
                  )
                ],
              ),
            ),
            DataWidgetBuilder(
              isLoading: controller.loadingPartnerReviews,
              haveData: reviewList.haveData,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: reviewList?.length ?? 0,
                padding: const EdgeInsets.only(top: 8),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var data = reviewList?.elementAt(index);

                  return RatingCard(
                    review: data,
                    onSuccess: () {
                      context.pop();
                      fetchPartnerReviews();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
