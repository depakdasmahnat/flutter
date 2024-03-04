import 'package:flutter/material.dart';

import '../../../../utils/widgets/image_view.dart';
import '../../core/constant/colors.dart';

class MultiOptionPicker extends StatefulWidget {
  const MultiOptionPicker({
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

  final List<String?>? selected;
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
  final Function(List<String?>? value) onChanged;

  @override
  State<MultiOptionPicker> createState() => _MultiOptionPickerState();
}

class _MultiOptionPickerState extends State<MultiOptionPicker> {
  late List<String?>? selected = widget.selected ?? [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.list?.length ?? 0,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        String? data = widget.list?.elementAt(index);
        bool selectedItem = selected?.where((element) => element == data).isNotEmpty == true;
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
            '$data',
            style: TextStyle(
              fontSize: widget.fontSize ?? 14,
              color:  Colors.white,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
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
