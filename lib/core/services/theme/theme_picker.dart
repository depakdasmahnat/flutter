import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/colors.dart';
import 'package:mrwebbeast/core/constant/shadows.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/core/extensions/normal/string_extension.dart';
import 'package:provider/provider.dart';
import 'theme_controller.dart';

class ThemePicker extends StatefulWidget {
  const ThemePicker({
    Key? key,
  }) : super(key: key);

  @override
  State<ThemePicker> createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePicker> {
  ThemeMode? selectedTheme;

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Provider.of<ThemeController>(context);
    ThemeMode? selectedTheme = themeController.themeMode;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ThemeMode.values.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        ThemeMode? theme = ThemeMode.values.elementAt(index);
        bool selected = selectedTheme == theme;

        return themeCard(
          context: context,
          index: index,
          theme: theme,
          selectedItem: selected,
        );
      },
    );
  }

  Widget themeCard({
    required BuildContext context,
    required int index,
    required ThemeMode theme,
    required bool selectedItem,
  }) {
    bool lastIndex = index == (ThemeMode.values.length - 1);
    ThemeController themeController = Provider.of<ThemeController>(context, listen: false);
    return GestureDetector(
      onTap: () {
        themeController.changeTheme(themeMode: theme);
        context.pop();
      },
      child: Container(
        margin: EdgeInsets.only(right: lastIndex ? 0 : 1.2),
        decoration: BoxDecoration(
          color: context.containerColor,
          boxShadow: primaryBoxShadow(context),
        ),
        child: ListTile(
          title: Text(
            '${theme.name.toCapitalizeFirst} Theme',
            style: TextStyle(
              fontSize: 14,
              color: selectedItem ? primaryColor : null,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          trailing: Icon(
            selectedItem ? Icons.radio_button_checked : Icons.circle_outlined,
            color: selectedItem ? primaryColor : null,
          ),
        ),
      ),
    );
  }
}
