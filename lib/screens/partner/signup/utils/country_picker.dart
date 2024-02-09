import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utils/widgets/image_view.dart';
import '../../../../models/partner/countries_model.dart';

class CountryPicker extends StatelessWidget {
  const CountryPicker({
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
  final CountriesData? selected;
  final List<CountriesData>? list;
  final Color? color;
  final double? height;
  final double? radius;
  final double? fontSize;
  final double? imageSize;
  final Color? itemsColor;
  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Function(CountriesData? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list?.length ?? 0,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        CountriesData? data = list?.elementAt(index);
        bool selectedItem = selected?.id == data?.id;

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
    required CountriesData? data,
    required bool selectedItem,
  }) {
    bool lastIndex = index == ((list?.length ?? 0) - 1);
    debugPrint("index == list?.length $index ${list?.length}");
    return GestureDetector(
      onTap: () {
        onChanged(selectedItem ? null : data);
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
          leading: ImageView(
            height: imageSize ?? 24,
            width: imageSize ?? 24,
            networkImage: "${data?.flagImage}",
            fit: BoxFit.contain,
            margin: EdgeInsets.zero,
          ),
          title: Text(
            "${data?.code} ${data?.name}",
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
