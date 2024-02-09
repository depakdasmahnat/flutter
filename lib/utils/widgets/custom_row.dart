import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  const CustomRow(
      {Key? key,
      this.title,
      this.subTitle,
      this.titleIcon,
      this.subTitleIcon,
      this.showDivider,
      this.lastDetail,
      this.titleStyle,
      this.subTitleStyle,
      this.padding})
      : super(key: key);
  final String? title;
  final String? subTitle;
  final IconData? titleIcon;
  final IconData? subTitleIcon;
  final bool? showDivider;
  final bool? lastDetail;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(top: 12, bottom: lastDetail == true ? 16 : 0, left: 16, right: 16),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                  child: Row(
                children: [
                  if (titleIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        titleIcon,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  if (title != null)
                    Expanded(
                      child: Text(
                        '$title',
                        style: titleStyle ?? Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                ],
              )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (subTitleIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          subTitleIcon,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    if (subTitle != null)
                      Expanded(
                        child: Text(
                          '$subTitle',
                          style: subTitleStyle ?? Theme.of(context).textTheme.labelMedium,
                          textAlign: TextAlign.right,
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
          if (showDivider == true)
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 4),
              child: Divider(height: 0),
            ),
        ],
      ),
    );
  }
}
