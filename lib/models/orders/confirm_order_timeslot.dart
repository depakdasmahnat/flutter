import 'package:flutter/material.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/partner/orders/suggested_times_slots_model.dart';
import 'package:gaas/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../utils/widgets/image_view.dart';
import '../../screens/home/product/utils/custom_date_card.dart';
import '../../utils/widgets/custom_button.dart';
import 'order_detail_model.dart';

class ConfirmOrderTimeSlot extends StatefulWidget {
  const ConfirmOrderTimeSlot({super.key, this.partnerId, this.orderId, this.refreshOrders, this.orderDetail});

  final num? partnerId;
  final num? orderId;
  final OrderDetailData? orderDetail;
  final GestureTapCallback? refreshOrders;

  @override
  State<ConfirmOrderTimeSlot> createState() => _ConfirmOrderTimeSlotState();
}

class _ConfirmOrderTimeSlotState extends State<ConfirmOrderTimeSlot> {
  late num? partnerId = widget.partnerId;
  late num? orderId = widget.orderId;
  late OrderDetailData? orderDetail = widget.orderDetail;
  late GestureTapCallback? refreshOrders = widget.refreshOrders;
  TextEditingController textEditingController = TextEditingController();
  SuggestedTimesSlotsData? selectedTimeSlots;
  DayInfo? selectedDateSlot;
  late List<DayInfo?>? dateSlot = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (orderDetail?.rescheduleDate != null && orderDetail?.rescheduleDay != null) {
        selectedDateSlot = DayInfo(
          dayName: orderDetail?.rescheduleDay,
          formattedDate: orderDetail?.rescheduleDate,
        );
        dateSlot?.add(selectedDateSlot);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CartController>(
      builder: (context, controller, widget) {
        List<SuggestedTimesSlotsData>? suggestedTimesSlotsData = controller.suggestedTimesSlotsData;

        return SizedBox(
          height: size.height * 0.7,
          child: Scaffold(
            body: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Text(
                    "Comment",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                CustomTextField(
                  labelText: 'Comment',
                  controller: textEditingController,
                  hintText: 'Comment',
                  minLines: 2,
                  maxLines: 4,
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
                if (dateSlot.haveData)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Available Date",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                if (dateSlot.haveData)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                    child: CustomDateSlotCard(
                      selected: selectedDateSlot,
                      list: dateSlot,
                      onChanged: (val) {},
                    ),
                  ),
                if (suggestedTimesSlotsData.haveData)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                    child: ListView.builder(
                      itemCount: suggestedTimesSlotsData?.length ?? 0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      // scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        SuggestedTimesSlotsData? data = suggestedTimesSlotsData?.elementAt(index);
                        bool selectedItem = selectedTimeSlots?.id == data?.id;

                        return GestureDetector(
                          onTap: () {
                            if (selectedItem) {
                              selectedTimeSlots = null;
                            } else {
                              selectedTimeSlots = data;
                            }
                            setState(() {});
                          },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: selectedItem ? primaryColor.withOpacity(0.8) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: defaultBoxShadow(),
                            ),
                            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ImageView(
                                      height: 18,
                                      width: 18,
                                      color: (selectedItem ? Colors.white : Colors.black),
                                      assetImage: AppImages.morning,
                                      fit: BoxFit.contain,
                                      margin: const EdgeInsets.only(right: 8),
                                    ),
                                    Text(
                                      "${data?.name}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: (selectedItem ? Colors.white : Colors.black),
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        selectedItem
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off_outlined,
                                        color: selectedItem ? Colors.white : Colors.black,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${data?.fromTime} to ${data?.toTime}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: (selectedItem ? Colors.grey.shade200 : Colors.black),
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedTimeSlots?.partnerSlotId != null || textEditingController.text.isNotEmpty)
                  CustomButton(
                    height: 45,
                    text: "Confirm TimeSlot",
                    mainAxisAlignment: MainAxisAlignment.center,
                    onPressed: () {
                      context.read<CartController>().confirmTimesSlot(
                          context: context,
                          partnerId: partnerId,
                          orderId: orderId,
                          date: selectedDateSlot?.formattedDate,
                          comment: textEditingController.text,
                          partnerSlotId: selectedTimeSlots?.partnerSlotId,
                          refreshOrders: refreshOrders);
                    },
                  ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
