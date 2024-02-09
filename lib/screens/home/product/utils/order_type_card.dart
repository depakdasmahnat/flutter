import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';

import '../../../../models/order_type_data.dart';
import '../../../../utils/widgets/image_view.dart';

class OrderTypeCard extends StatelessWidget {
  const OrderTypeCard({
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
  final OrderTypeData? selected;
  final List<OrderTypeData>? list;
  final Color? color;
  final double? height;
  final double? radius;
  final double? fontSize;
  final double? imageSize;
  final Color? itemsColor;
  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Function(OrderTypeData? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 28,
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(radius ?? 10),
        // boxShadow: defaultBoxShadow(),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list?.length ?? 0,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          OrderTypeData? data = list?.elementAt(index);
          bool selectedItem = selected?.type == data?.type;

          return card(index, data, selectedItem);
        },
      ),
    );
  }

  // Stack(
  // children: List.generate(
  // list?.length ?? 0,
  // (index) {
  // OrderTypeData? data = list?.elementAt(index);
  // bool selectedItem = selected?.type == data?.type;
  // return Padding(
  // padding: EdgeInsets.only(left: (110 * index).toDouble()),
  // child: card(data, selectedItem),
  // );
  // },
  // ),
  // ),

  Widget card(int index, OrderTypeData? data, bool selectedItem) {
    bool lastIndex = index == ((list?.length ?? 0) - 1);
    debugPrint("index == list?.length $index ${list?.length}");
    return GestureDetector(
      onTap: () {
        onChanged(data);
      },
      child: Container(
        margin: EdgeInsets.only(right: lastIndex ? 0 : 1.2),
        decoration: BoxDecoration(
          color: selectedItem ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 10),
          boxShadow: [
            BoxShadow(
              color: selectedItem ? Colors.transparent : Colors.grey.shade300,
              offset: const Offset(1, 0),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (data?.image != null)
                  ImageView(
                    height: imageSize ?? 16,
                    width: imageSize ?? 16,
                    color: itemsColor ?? (selectedItem ? Colors.white : Colors.black),
                    assetImage: "${data?.image}",
                    fit: BoxFit.contain,
                    margin: const EdgeInsets.only(right: 4),
                  ),
                Text(
                  "${data?.type?.value}",
                  style: TextStyle(
                    fontSize: fontSize ?? 13,
                    color: itemsColor ?? (selectedItem ? Colors.white : Colors.grey.shade700),
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
