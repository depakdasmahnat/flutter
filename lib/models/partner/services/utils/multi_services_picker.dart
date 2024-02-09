import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/partner/service_provider_controller.dart';
import '../../../../utils/widgets/no_data_screen.dart';
import '../services_model.dart';

class MultiServicePicker extends StatefulWidget {
  const MultiServicePicker({Key? key}) : super(key: key);

  @override
  State<MultiServicePicker> createState() => _MultiServicePickerState();
}

class _MultiServicePickerState extends State<MultiServicePicker> {
  List<ServicesData>? services;

  @override
  Widget build(BuildContext context) {
    ServiceProviderController controller = Provider.of<ServiceProviderController>(context);
    services = controller.services;

    return ListView(
      shrinkWrap: true,
      children: [
        if (services.haveData)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services?.length ?? 0,
            padding: const EdgeInsets.only(top: 8),
            itemBuilder: (context, index) {
              var category = services?.elementAt(index);

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
                          "${category?.name}",
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
                  if (category?.subcategories?.haveData == true)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: category?.subcategories?.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, optionIndex) {
                        bool lastIndex = optionIndex == ((category?.subcategories?.length ?? 0) - 1);
                        var subCategory = category?.subcategories?.elementAt(optionIndex);
                        bool selected = subCategory?.selected == true;

                        return GestureDetector(
                          onTap: () {
                            ServiceProviderController controller =
                                Provider.of<ServiceProviderController>(context, listen: false);

                            controller.updateSubCategorySelectedStatus(
                              categoryId: category?.id,
                              subCategoryId: subCategory?.id,
                              selected: !selected,
                            );
                            setState(() {});
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
                                "${subCategory?.name}",
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
