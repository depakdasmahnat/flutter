import 'package:flutter/material.dart';
import 'package:mrwebbeast/screens/member/report/partner_report_table.dart';

import '../../../../utils/widgets/image_view.dart';
import '../network/pinnacle_list_table.dart';

class ReportLabelPicker extends StatefulWidget {
  const ReportLabelPicker({
    super.key,
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

  final List<Report?>? list;
  final Color? color;
  final double? height;
  final double? radius;
  final double? fontSize;
  final double? imageSize;
  final Color? itemsColor;
  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Function(List<Report?>? value) onChanged;

  @override
  State<ReportLabelPicker> createState() => _ReportLabelPickerState();
}

class _ReportLabelPickerState extends State<ReportLabelPicker> {
  late List<Report?>? list = widget.list ?? [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.list?.length ?? 0,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        Report? data = list?.elementAt(index);
        bool selectedItem = data?.isSelected == true;

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
    required Report? data,
    required bool selectedItem,
  }) {
    bool lastIndex = index == ((widget.list?.length ?? 0) - 1);
    debugPrint('index == list?.length $index ${widget.list?.length}');
    return GestureDetector(
      onTap: () {
        if (selectedItem) {
          debugPrint('$index Removed');

          list?[index]?.isSelected = false;
        } else {
          debugPrint('$index Added');
          list?[index]?.isSelected = true;
        }
        setState(() {});
        widget.onChanged(list);
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
