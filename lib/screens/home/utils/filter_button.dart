import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/utils/widgets/image_view.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({Key? key, this.title, this.image, this.imageColor, this.showArrow, this.selected, this.onTap})
      : super(key: key);
  final String? title;
  final String? image;
  final Color? imageColor;
  final bool? selected;
  final bool? showArrow;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
        margin: const EdgeInsets.only(top: 6, right: 8),
        decoration: BoxDecoration(
          color: selected == true ? primaryColor : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null)
              ImageView(
                height: 14,
                width: 14,
                assetImage: "$image",
                color: selected == true ? Colors.white : Colors.black,
                margin: const EdgeInsets.only(right: 6),
              ),
            Text(
              "$title",
              style: TextStyle(
                fontSize: 14,
                color: selected == true ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (showArrow == true)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  (Icons.arrow_drop_down_sharp),
                  size: 16,
                  color: selected == true ? Colors.white : Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
