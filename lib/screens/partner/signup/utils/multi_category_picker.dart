import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';

import '../../../../models/partner/category_model.dart';
import '../../../../utils/widgets/image_view.dart';

class MultiCategoryPicker extends StatefulWidget {
  const MultiCategoryPicker({
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
  final List<CategoryData?>? selected;
  final List<CategoryData>? list;
  final Color? color;
  final double? height;
  final double? radius;
  final double? fontSize;
  final double? imageSize;
  final Color? itemsColor;
  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Function(List<CategoryData?>? value) onChanged;

  @override
  State<MultiCategoryPicker> createState() => _MultiCategoryPickerState();
}

class _MultiCategoryPickerState extends State<MultiCategoryPicker> {
  late List<CategoryData?>? selected = widget.selected ?? [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.list?.length ?? 0,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            CategoryData? data = widget.list?.elementAt(index);
            bool selectedItem = selected?.where((element) => element?.id == data?.id).isNotEmpty == true;
            return card(
              context: context,
              index: index,
              data: data,
              selectedItem: selectedItem,
            );
          },
        ),
      ],
    );
  }

  Widget card({
    required BuildContext context,
    required int index,
    required CategoryData? data,
    required bool selectedItem,
  }) {
    bool lastIndex = index == ((widget.list?.length ?? 0) - 1);
    debugPrint("index == list?.length $index ${widget.list?.length}");
    return GestureDetector(
      onTap: () {
        if (selectedItem) {
          debugPrint("$index Removed");

          selected?.removeWhere((element) => element?.id == data?.id);
        } else {
          debugPrint("$index Added");
          selected?.add(data);
        }
        setState(() {});
        widget.onChanged(selected);
      },
      child: Container(
        margin: EdgeInsets.only(right: lastIndex ? 0 : 1.2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.radius ?? 10),
          boxShadow: [
            BoxShadow(
              color: selectedItem ? Colors.transparent : Colors.grey.shade300,
              offset: const Offset(1, 0),
            )
          ],
        ),
        child: ListTile(
          leading: ImageView(
            height: 50,
            width: 50,
            borderRadiusValue: 50,
            fit: BoxFit.cover,
            border: Border.all(color: primaryColor),
            networkImage: "${data?.icon}",
            margin: EdgeInsets.zero,
          ),
          title: Text(
            "${data?.name}",
            style: TextStyle(
              fontSize: widget.fontSize ?? 14,
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
