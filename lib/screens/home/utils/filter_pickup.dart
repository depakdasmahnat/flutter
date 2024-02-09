import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';

import '../../../../models/dashboard/filters_model.dart';

class FilterPicker extends StatefulWidget {
  const FilterPicker(
      {Key? key,
      this.filterOptions,
      this.selectedFilterOptions,
      required this.onChange,
      this.filterId,
      this.selectedFilterIds})
      : super(key: key);

  final num? filterId;
  final Set<num?>? selectedFilterIds;
  final List<FilterOptions?>? selectedFilterOptions;
  final List<FilterOptions?>? filterOptions;
  final Function(Set<num?>?, List<FilterOptions?>?) onChange;

  @override
  State<FilterPicker> createState() => _FilterPickerState();
}

class _FilterPickerState extends State<FilterPicker> {
  late Set<num?>? selectedFilterIds = widget.selectedFilterIds;
  late List<FilterOptions?>? selectedList = widget.selectedFilterOptions;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.filterOptions?.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, optionIndex) {
            bool lastIndex = optionIndex == ((widget.filterOptions?.length ?? 0) - 1);
            var data = widget.filterOptions?.elementAt(optionIndex);
            bool selected = selectedList?.where((element) => element?.id == data?.id).isNotEmpty == true;

            int getCurrentSelectedOptionsLength() {
              List<FilterOptions?>? currentSelectedOptions = [];

              widget.filterOptions?.forEach((element) {
                bool? containElement1;
                bool? containElement2;

                selectedList?.forEach((element2) {
                  containElement1 = selectedList?.contains(element) == true;
                  containElement2 = widget.filterOptions?.contains(element2) == true;
                });

                if (containElement1 == true && containElement2 == true) {
                  currentSelectedOptions.add(element);
                }
              });
              int length = currentSelectedOptions.length;
              return length;
            }

            bool containFilerId = selectedFilterIds?.any((element) => element == widget.filterId) == true;

            return GestureDetector(
              onTap: () {
                if (!containFilerId) {
                  selectedFilterIds?.add(widget.filterId);
                }

                setState(() {});
                if (selected) {
                  selectedList?.removeWhere((element) => element?.id == data?.id);
                } else {
                  selectedList?.add(data);
                }

                setState(() {});

                debugPrint("selectedList ${selectedList?.length} ${selectedList.toString()}");
                debugPrint("OnTap currentSelectedOptionsLength ${getCurrentSelectedOptionsLength()}");
                if (getCurrentSelectedOptionsLength() == 0) {
                  selectedFilterIds?.remove(widget.filterId);
                }

                widget.onChange(selectedFilterIds, selectedList);
              },
              child: Container(
                margin: EdgeInsets.only(right: lastIndex ? 0 : 1.2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: selected ? Colors.transparent : Colors.grey.shade300,
                      offset: const Offset(1, 0),
                    )
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "${data?.name}",
                    style: TextStyle(
                      fontSize: 14,
                      color: selected ? primaryColor : Colors.black,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  trailing: Icon(
                    selected ? Icons.radio_button_checked : Icons.circle_outlined,
                    color: selected ? primaryColor : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
