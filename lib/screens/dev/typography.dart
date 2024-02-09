import 'package:flutter/material.dart';


import '../../core/constant/shadows.dart';
import '../../utils/widgets/custom_row.dart';

class TypographyScreen extends StatefulWidget {
  const TypographyScreen({Key? key}) : super(key: key);

  @override
  State<TypographyScreen> createState() => _TypographyScreenState();
}

class _TypographyScreenState extends State<TypographyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Typography"),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(14),
              boxShadow: defaultBoxShadow(),
            ),
            child: Column(
              children: [
                CustomRow(
                  title: "displayLarge",
                  subTitle: "displayLarge",
                  subTitleStyle: Theme.of(context).textTheme.displayLarge,
                  showDivider: true,
                ),
                CustomRow(
                  title: "displayMedium",
                  subTitle: "displayMedium",
                  subTitleStyle: Theme.of(context).textTheme.displayMedium,
                  showDivider: true,
                ),
                CustomRow(
                  title: "displaySmall",
                  subTitle: "displaySmall",
                  subTitleStyle: Theme.of(context).textTheme.displaySmall,
                  showDivider: true,
                ),
                CustomRow(
                  title: "headlineMedium",
                  subTitle: "headlineMedium",
                  subTitleStyle: Theme.of(context).textTheme.headlineMedium,
                  showDivider: true,
                ),
                CustomRow(
                  title: "headlineSmall",
                  subTitle: "headlineSmall",
                  subTitleStyle: Theme.of(context).textTheme.headlineSmall,
                  showDivider: true,
                ),
                CustomRow(
                  title: "titleLarge",
                  subTitle: "titleLarge",
                  subTitleStyle: Theme.of(context).textTheme.titleLarge,
                  showDivider: true,
                ),
                CustomRow(
                  title: "titleMedium",
                  subTitle: "titleMedium",
                  subTitleStyle: Theme.of(context).textTheme.titleMedium,
                  showDivider: true,
                ),
                CustomRow(
                  title: "titleSmall",
                  subTitle: "titleSmall",
                  subTitleStyle: Theme.of(context).textTheme.titleSmall,
                  showDivider: true,
                ),
                CustomRow(
                  title: "bodyLarge",
                  subTitle: "bodyLarge",
                  subTitleStyle: Theme.of(context).textTheme.bodyLarge,
                  showDivider: true,
                ),
                CustomRow(
                  title: "bodyMedium",
                  subTitle: "bodyMedium",
                  subTitleStyle: Theme.of(context).textTheme.bodyMedium,
                  showDivider: true,
                ),
                CustomRow(
                  title: "bodySmall",
                  subTitle: "bodySmall",
                  subTitleStyle: Theme.of(context).textTheme.bodySmall,
                  showDivider: true,
                ),
                CustomRow(
                  title: "labelLarge",
                  subTitle: "labelLarge",
                  subTitleStyle: Theme.of(context).textTheme.labelLarge,
                  showDivider: true,
                ),
                CustomRow(
                  title: "labelMedium",
                  subTitle: "labelMedium",
                  subTitleStyle: Theme.of(context).textTheme.labelMedium,
                  showDivider: true,
                ),
                CustomRow(
                    title: "labelSmall", subTitle: "labelSmall", subTitleStyle: Theme.of(context).textTheme.labelSmall),
              ].reversed.toList(),
            ),
          )
        ],
      ),
    );
  }
}
