import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/constant/shadows.dart';

import '../../../../models/partner/setup/timeslots_model.dart';
import '../../../../utils/widgets/image_view.dart';

class MultiTimeCard extends StatefulWidget {
  const MultiTimeCard({
    Key? key,
    this.selected,
    this.timeslotsList,
    required this.onChanged,
    this.color,
    this.gradient,
    this.height,
    this.radius,
    this.fontSize,
    this.imageSize,
    this.shrinkWrap,
    this.padding,
    required this.deleteIds,
  }) : super(key: key);
  final List<TimeSlotsData?>? selected;
  final List<TimeSlotsData?>? timeslotsList;
  final Color? color;
  final double? height;
  final double? radius;
  final double? fontSize;
  final double? imageSize;

  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Set<num?>? deleteIds;

  final Function(List<TimeSlotsData?>? value, Set<num?>? deleteIds) onChanged;

  @override
  State<MultiTimeCard> createState() => _MultiTimeCardState();
}

class _MultiTimeCardState extends State<MultiTimeCard> {
  late Set<num?>? deleteIds = widget.deleteIds ?? {};
  late List<TimeSlotsData?>? selected = widget.selected ?? [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 70,
      child: ListView.builder(
        itemCount: widget.timeslotsList?.length,
        shrinkWrap: widget.shrinkWrap ?? false,
        padding: widget.padding ?? EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          TimeSlotsData? data = widget.timeslotsList?.elementAt(index);
          bool selectedItem = widget.selected?.where((element) => element?.id == data?.id).isNotEmpty == true;

          TimeSlotsData? selectedData =
              widget.selected?.where((element) => element?.id == data?.id).firstOrNull;
          Color backgroundColor = (selectedItem ? primaryColor.withOpacity(0.8) : Colors.grey.shade50);

          return GestureDetector(
            onTap: () {
              if (selectedItem) {
                debugPrint(
                    "Removed Id => ${data?.id} at Index => $index, partnerSlotId => ${selectedData?.partnerSlotId}");

                if (selectedData?.partnerSlotId != null) {
                  deleteIds?.add(selectedData?.partnerSlotId);
                }
                selected?.removeWhere((element) => element?.id == data?.id);
                debugPrint("deleteIds $deleteIds");
              } else {
                debugPrint("$index Added");
                selected?.add(data);
              }

              setState(() {});
              widget.onChanged(selected, deleteIds);
              for (TimeSlotsData? data in selected ?? []) {
                debugPrint("selected ${data?.id} ${data?.timeRange}");
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(widget.radius ?? 8),
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
                        height: widget.imageSize ?? 16,
                        width: widget.imageSize ?? 16,
                        color: (selectedItem ? Colors.white : Colors.black),
                        assetImage: AppImages.morning,
                        fit: BoxFit.contain,
                        margin: const EdgeInsets.only(right: 8),
                      ),
                      Text(
                        "${data?.name}",
                        style: TextStyle(
                          fontSize: widget.fontSize ?? 14,
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
                          selectedItem ? Icons.radio_button_checked : Icons.radio_button_off_outlined,
                          color: selectedItem ? Colors.white : Colors.black,
                          size: 12,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${data?.timeRange}",
                          style: TextStyle(
                            fontSize: widget.fontSize ?? 10,
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
    );
  }
}
