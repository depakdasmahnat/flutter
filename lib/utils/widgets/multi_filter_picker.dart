import 'package:flutter/material.dart';

import '../../../../utils/widgets/image_view.dart';
import '../../core/constant/colors.dart';
import '../../models/member/filter/filter_model.dart';

class MultiFilterPicker extends StatefulWidget {
  const MultiFilterPicker({
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

  final List<FilterData?>? selected;
  final List<FilterData?>? list;
  final Color? color;
  final double? height;
  final double? radius;
  final double? fontSize;
  final double? imageSize;
  final Color? itemsColor;
  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Function(List<FilterData?>? value) onChanged;

  @override
  State<MultiFilterPicker> createState() => _MultiFilterPickerState();
}

class _MultiFilterPickerState extends State<MultiFilterPicker> {
  late List<FilterData?>? selected = widget.selected ?? [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.list?.length ?? 0,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        FilterData? data = widget.list?.elementAt(index);
        bool selectedItem = selected?.where((element) => element?.id == data?.id).isNotEmpty == true;
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
    required FilterData? data,
    required bool selectedItem,
  }) {
    bool lastIndex = index == ((widget.list?.length ?? 0) - 1);
    debugPrint('index == list?.length $index ${widget.list?.length}');
    return GestureDetector(
      onTap: () {
        if (selectedItem) {
          debugPrint('$index Removed');

          selected?.removeWhere((element) => element == data);
        } else {
          debugPrint('$index Added');
          selected?.add(data);
        }
        setState(() {});
        widget.onChanged(selected);
      },
      child: Container(
        margin: EdgeInsets.only(right: lastIndex ? 0 : 1.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius ?? 10),
        ),
        child: ListTile(
          title: Text(
            '${data?.name}',
            style: TextStyle(
              fontSize: widget.fontSize ?? 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(2),
            child: Icon(
              selectedItem ? Icons.check : Icons.circle,
              color: selectedItem ? Colors.black : Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
