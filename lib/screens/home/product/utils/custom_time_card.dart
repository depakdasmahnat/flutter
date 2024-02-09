import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/models/partner/setup/timeslots_model.dart';

import '../../../../utils/widgets/image_view.dart';

class CustomTimeSlotCard extends StatelessWidget {
  const CustomTimeSlotCard({
    Key? key,
    this.selected,
    this.list,
    required this.onChanged,
    this.color,
    this.itemsColor,
    this.gradient,
    this.height,
    this.radius,
    this.fontSize,
    this.imageSize,
    this.shrinkWrap,
    this.padding,
  }) : super(key: key);
  final TimeSlotsData? selected;
  final List<TimeSlotsData>? list;
  final Color? color;
  final double? height;
  final double? radius;
  final double? fontSize;
  final double? imageSize;
  final Color? itemsColor;
  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Function(TimeSlotsData? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 70,
      child: ListView.builder(
        itemCount: list?.length ?? 0,
        shrinkWrap: shrinkWrap ?? false,
        padding: padding ?? EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          TimeSlotsData? data = list?.elementAt(index);
          bool selectedItem = selected?.id == data?.id;
          return GestureDetector(
            onTap: () {
              onChanged(data);
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectedItem
                    ? primaryColor.withOpacity(0.8)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(radius ?? 8),
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
                        height: imageSize ?? 16,
                        width: imageSize ?? 16,
                        color: itemsColor ??
                            (selectedItem ? Colors.white : Colors.black),
                        assetImage: AppImages.morning,
                        fit: BoxFit.contain,
                        margin: const EdgeInsets.only(right: 8),
                      ),
                      Text(
                        "${data?.name}",
                        style: TextStyle(
                          fontSize: fontSize ?? 14,
                          color: itemsColor ??
                              (selectedItem ? Colors.white : Colors.black),
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
                          size: 12,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${data?.fromTime} to ${data?.toTime}",
                          style: TextStyle(
                            fontSize: fontSize ?? 10,
                            color: itemsColor ??
                                (selectedItem
                                    ? Colors.grey.shade200
                                    : Colors.black),
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
    );
  }
}
