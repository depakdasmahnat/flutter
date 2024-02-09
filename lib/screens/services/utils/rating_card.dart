import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/services/database/local_database.dart';
import 'package:gaas/models/orders/order_detail_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/shadows.dart';
import '../../../models/partner/services/partner_reviews.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/description_text.dart';
import '../../../utils/widgets/image_view.dart';
import '../../orders/utils/rate_this_order.dart';

class RatingCard extends StatelessWidget {
  const RatingCard({
    super.key,
    required this.review,
    this.padding,
    this.onTap,
    this.onSuccess,
  });

  final ReviewList? review;

  final EdgeInsets? padding;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    num? userId = LocalDatabase().id;
    showFeedBackPopUp() {
      return RateThisOrder.show(
        context: context,
        onSuccess: onSuccess,
        partnerId: review?.userId,
        reviewAdded: true,
        reviewDetail: ReviewDetail(
          id: review?.id,
          rating: num.tryParse("${review?.rating ?? 0}") ?? 0,
          review: review?.review,
        ),
        leadsReview: true,
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: defaultBoxShadow(),
      ),
      child: CupertinoButton(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        onPressed: review?.userId == userId
            ? () {
                showFeedBackPopUp();
              }
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ImageView(
                  height: 35,
                  width: 35,
                  borderRadiusValue: 40,
                  fit: BoxFit.cover,
                  backgroundColor: Colors.white,
                  networkImage: "${review?.userPhoto}",
                  onTap: null,
                  boxShadow: primaryBoxShadow(),
                  margin: const EdgeInsets.only(right: 16),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review?.userName ?? "",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontStyle: GoogleFonts.mulish().fontStyle,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                "${review?.datetime}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (review?.userId == userId)
                                const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.edit,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse("${review?.rating ?? 0}"),
                              minRating: 0,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 12,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                debugPrint("$rating");
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${review?.rating}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
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
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DescriptionText(
                text: "${review?.review}",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget storeDetail({
    required String? title,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
      margin: const EdgeInsets.only(top: 6, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                (icon),
                size: 12,
                color: iconColor ?? Colors.grey.shade800,
              ),
            ),
          Text(
            "$title",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
