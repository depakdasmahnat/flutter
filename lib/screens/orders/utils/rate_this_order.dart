import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/database/local_database.dart';
import '../../../../utils/widgets/custom_button.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/orders/cart_controller.dart';
import '../../../models/orders/order_detail_model.dart';
import '../../../utils/widgets/custom_bottom_sheet.dart';

class RateThisOrder extends StatefulWidget {
  const RateThisOrder({
    Key? key,
    required this.onSuccess,
    required this.id,
    required this.partnerId,
    required this.reviewAdded,
    required this.reviewDetail,
    this.leadsReview,
  }) : super(key: key);

  final num? id;
  final num? partnerId;
  final bool? reviewAdded;
  final bool? leadsReview;

  final ReviewDetail? reviewDetail;
  final GestureTapCallback? onSuccess;

  static show({
    required BuildContext context,
    required GestureTapCallback? onSuccess,
    num? id,
    required num? partnerId,
    required bool? reviewAdded,
    required bool? leadsReview,
    final ReviewDetail? reviewDetail,
  }) {
    context.read<AuthControllers>().authRequired(
          context: context,
          message: 'Please log in to rate this order.',
        );
    return CustomBottomSheet.show(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      physics: const BouncingScrollPhysics(),
      showTitleDivider: false,
      body: RateThisOrder(
        onSuccess: onSuccess,
        id: id,
        partnerId: partnerId,
        reviewAdded: reviewAdded,
        reviewDetail: reviewDetail,
        leadsReview: leadsReview,
      ),
    );
  }

  @override
  State<RateThisOrder> createState() => _RateThisOrderState();
}

class _RateThisOrderState extends State<RateThisOrder> {
  late bool leadsReview = widget.leadsReview ?? false;

  late ReviewDetail? reviewDetail = widget.reviewDetail;

  late VoidCallback? onSuccess = widget.onSuccess;
  LocalDatabase localDatabase = LocalDatabase();

  late TextEditingController reviewCtrl = TextEditingController(text: reviewDetail?.review ?? "");
  late double initialRating = (reviewDetail?.rating ?? 0).toDouble();

  final reviewFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: reviewFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 18, 16),
                    child: Text(
                      "Service Review",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: initialRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 48,
                    unratedColor: Colors.grey.shade300,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: primaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      initialRating = rating;
                      setState(() {});
                      debugPrint("$initialRating");
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 12),
                    child: Text(
                      "Your opinion matters, give us feedback & share your thoughts regarding this service",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CustomTextField(
                    controller: reviewCtrl,
                    hintText: "Review",
                    labelText: "Review",
                    autofocus: true,
                    minLines: 3,
                    maxLines: 8,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  CustomButton(
                      height: 45,
                      width: size.width * 0.7,
                      mainAxisAlignment: MainAxisAlignment.center,
                      text: widget.reviewAdded == true ? "Update" : "Submit",
                      fontSize: 16,
                      margin: const EdgeInsets.only(bottom: 16, top: 24),
                      onPressed: () {
                        submitReview(onSuccess: onSuccess);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future submitReview({required GestureTapCallback? onSuccess}) async {
    if (reviewFormKey.currentState?.validate() == true) {
      if (widget.reviewAdded == true) {
        context.read<CartController>().updateReview(
              context: context,
              reviewId: reviewDetail?.id,
              rating: initialRating,
              review: reviewCtrl.text,
              onSuccess: onSuccess,
            );
      } else {
        context.read<CartController>().submitReview(
              context: context,
              leadsReview: leadsReview,
              id: widget.id,
              partnerId: widget.partnerId,
              rating: initialRating,
              review: reviewCtrl.text,
              onSuccess: onSuccess,
            );
      }
    } else {}
  }
}
