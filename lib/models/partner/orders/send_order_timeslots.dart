import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/partner/orders/suggested_times_slots_model.dart';
import 'package:provider/provider.dart';

import '../../../controllers/partner/product_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../screens/home/product/utils/custom_date_card.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';

class SendOrderTimeSlots extends StatefulWidget {
  const SendOrderTimeSlots({super.key, this.partnerId, this.orderId});

  final num? partnerId;
  final num? orderId;

  @override
  State<SendOrderTimeSlots> createState() => _SendOrderTimeSlotsState();
}

class _SendOrderTimeSlotsState extends State<SendOrderTimeSlots> {
  late num? partnerId = widget.partnerId;
  late num? orderId = widget.orderId;
  DayInfo? selectedDateSlot;
  List<DayInfo>? dateSlots = getActiveDays(daysUPto: 3, startDate: DateTime.now().add(Duration(days: 1)));
  TextEditingController textEditingController = TextEditingController();
  List<SuggestedTimesSlotsData?>? selectedTimeSlots = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, widget) {
        List<SuggestedTimesSlotsData>? suggestedTimesSlotsData = controller.suggestedTimesSlotsData;

        return ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
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
            if (dateSlots.haveData)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Choose a Date",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            if (dateSlots.haveData)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                child: CustomDateSlotCard(
                  selected: selectedDateSlot,
                  list: dateSlots,
                  onChanged: (val) {
                    setState(() {
                      selectedDateSlot = val;
                    });
                  },
                ),
              ),
            if (suggestedTimesSlotsData.haveData)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Choose Timeslots",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ListView.builder(
                    itemCount: suggestedTimesSlotsData?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                    // scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      SuggestedTimesSlotsData? data = suggestedTimesSlotsData?.elementAt(index);
                      bool selectedItem =
                          selectedTimeSlots?.where((element) => element?.id == data?.id).isNotEmpty == true;
                      return GestureDetector(
                        onTap: () {
                          if (selectedItem) {
                            selectedTimeSlots?.removeWhere((element) => element?.id == data?.id);
                          } else {
                            selectedTimeSlots?.add(data);
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
                ],
              ),
            CustomButton(
              height: 45,
              text: "Reschedule",
              mainAxisAlignment: MainAxisAlignment.center,
              onPressed: () {
                context.read<ProductController>().sendSuggestedTimesSlots(
                      context: context,
                      partnerId: partnerId,
                      orderId: orderId,
                      date: selectedDateSlot?.dateTime,
                      comment: textEditingController.text,
                      selectedTimeSlots: selectedTimeSlots,
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
