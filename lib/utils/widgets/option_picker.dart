import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../core/constant/colors.dart';

class OptionPicker extends StatelessWidget {
  const OptionPicker({
    super.key,
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
  });

  final String? selected;
  final List<String>? list;
  final Color? color;
  final double? height;
  final double? radius;
  final double? fontSize;
  final double? imageSize;
  final Color? itemsColor;
  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Function(String? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list?.length ?? 0,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        String? data = list?.elementAt(index);
        bool selectedItem = selected == data;

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
    required String? data,
    required bool selectedItem,
  }) {
    bool lastIndex = index == ((list?.length ?? 0) - 1);
    debugPrint('index == list?.length $index ${list?.length}');
    return GestureDetector(
      onTap: () {
        onChanged(selectedItem ? null : data);
      },
      child: Container(
        margin: EdgeInsets.only(right: lastIndex ? 0 : 1.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 10),
        ),
        child: ListTile(
          title: Text(
            '$data',
            style: TextStyle(
              fontSize: fontSize ?? 14,
              color: Colors.white,
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
