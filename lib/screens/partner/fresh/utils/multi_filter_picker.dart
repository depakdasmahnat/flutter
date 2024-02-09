import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';

import '../../../../models/dashboard/filters_model.dart';
import '../../../../utils/widgets/no_data_screen.dart';

class MultiFilterPicker extends StatefulWidget {
  const MultiFilterPicker({Key? key, this.list, this.selectedList, required this.onChange}) : super(key: key);

  final List<FiltersData?>? selectedList;
  final List<FiltersData?>? list;
  final Function(List<FiltersData?>?) onChange;

  @override
  State<MultiFilterPicker> createState() => _MultiFilterPickerState();
}

class _MultiFilterPickerState extends State<MultiFilterPicker> {
  late List<FiltersData?>? selectedList = widget.selectedList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        if (widget.list.haveData)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.list?.length ?? 0,
            padding: const EdgeInsets.only(top: 8),
            itemBuilder: (context, index) {
              var data = widget.list?.elementAt(index);

              return Column(
                children: [
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${data?.name}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // if (selected == true)
                        //   const Icon(
                        //     Icons.check,
                        //     color: Colors.white,
                        //   )
                      ],
                    ),
                  ),
                  if (data?.options?.haveData == true)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: data?.options?.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, optionIndex) {
                        bool lastIndex = optionIndex == ((data?.options?.length ?? 0) - 1);
                        var optionData = data?.options?.elementAt(optionIndex);

                        bool selected =
                            selectedList?.where((element) => element?.selected?.id == optionData?.id).isNotEmpty ==
                                true;
                        bool alreadySelectedFilter =
                            selectedList?.where((element) => (element?.id == data?.id)).isNotEmpty == true;
                        bool alreadySelectedOption = selectedList
                                ?.where((element) => alreadySelectedFilter && (element?.selected != null))
                                .isNotEmpty ==
                            true;
                        return GestureDetector(
                          onTap: () {
                            FiltersData? newData = FiltersData(
                              id: data?.id,
                              name: data?.name,
                              selected: optionData,
                            );
                            add() {
                              selectedList?.add(newData);
                              setState(() {});
                            }

                            remove() {
                              selectedList?.removeWhere((element) => element?.selected?.id == optionData?.id);
                              setState(() {});
                            }

                            removeOld() {
                              selectedList?.removeWhere((element) => element?.id == data?.id);
                              setState(() {});
                            }

                            if (selected) {
                              remove();
                            } else {
                              if (alreadySelectedFilter == false) {
                                add();
                              } else {
                                removeOld();
                                add();
                              }
                            }

                            setState(() {});
                            debugPrint("selectedList ${selectedList?.length} ${selectedList.toString()}");
                            widget.onChange(selectedList);
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
                                "${optionData?.name}",
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
            },
          )
        else
          const NoDataScreen(heightFactor: 0.4),
      ],
    );
  }
}
