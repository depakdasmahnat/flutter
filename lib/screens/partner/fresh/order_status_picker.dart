import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:go_router/go_router.dart';

class OrderStatusPicker extends StatelessWidget {
  const OrderStatusPicker({
    Key? key,
    required this.selected,
    required this.list,
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

  final EarningStatuses selected;
  final List<EarningStatuses> list;
  final Color? color;
  final double? height;
  final double? radius;
  final double? fontSize;
  final double? imageSize;
  final Color? itemsColor;
  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Function(EarningStatuses value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        EarningStatuses data = list.elementAt(index);
        bool selectedItem = selected.value == data.value;

        return card(
          context: context,
          index: index,
          data: data,
          selectedItem: selectedItem,
        );
      },
    );
  }

  Widget card({
    required BuildContext context,
    required int index,
    required EarningStatuses data,
    required bool selectedItem,
  }) {
    bool lastIndex = index == ((list.length) - 1);

    return GestureDetector(
      onTap: () {
        onChanged(data);
        context.pop();
      },
      child: Container(
        margin: EdgeInsets.only(right: lastIndex ? 0 : 1.2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 10),
          boxShadow: [
            BoxShadow(
              color: selectedItem ? Colors.transparent : Colors.grey.shade300,
              offset: const Offset(1, 0),
            )
          ],
        ),
        child: ListTile(
          title: Text(
            data.value,
            style: TextStyle(
              fontSize: fontSize ?? 14,
              color: selectedItem ? primaryColor : Colors.black,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          trailing: Icon(
            selectedItem ? Icons.radio_button_checked : Icons.circle_outlined,
            color: selectedItem ? primaryColor : Colors.black,
          ),
        ),
      ),
    );
  }
}
