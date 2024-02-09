import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';

class MultiFilterButton extends StatefulWidget {
  const MultiFilterButton({Key? key, this.list, this.selectedList, required this.onChange}) : super(key: key);

  final List<String>? selectedList;
  final List<String>? list;
  final Function(List<String>?) onChange;

  @override
  State<MultiFilterButton> createState() => _MultiFilterButtonState();
}

class _MultiFilterButtonState extends State<MultiFilterButton> {
  late List<String>? selectedList = widget.selectedList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.list?.length,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = widget.list?.elementAt(index);
          bool selected = widget.selectedList?.contains(title) == true;
          return GestureDetector(
            onTap: () {
              if (selected) {
                selectedList?.remove("$title");
              } else {
                selectedList?.add("$title");
              }
              setState(() {});
              widget.onChange(selectedList);
            },
            child: Container(
              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              margin: const EdgeInsets.only(top: 6, right: 8),
              decoration: BoxDecoration(
                color: selected ? primaryColor : Colors.white,
                border: Border.all(color: selected ? primaryColor : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$title",
                    style: TextStyle(
                      fontSize: 14,
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w400,
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
