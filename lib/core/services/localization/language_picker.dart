import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/colors.dart';
import 'package:mrwebbeast/core/constant/shadows.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:provider/provider.dart';

import 'localization_controller.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({
    Key? key,
  }) : super(key: key);

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  Locale? selectedTheme;
  List<Locale>? themes;

  @override
  Widget build(BuildContext context) {
    LocalizationController themeController = Provider.of<LocalizationController>(context);
    Locale? selectedLocal = themeController.locale;
    List<Locale>? supportedLocales = themeController.supportedLocales;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: supportedLocales.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        Locale? data = supportedLocales.elementAt(index);
        bool selectedItem = selectedLocal?.languageCode == data.languageCode;

        return themeCard(
          context: context,
          index: index,
          data: data,
          selectedItem: selectedItem,
        );
      },
    );
  }

  Widget themeCard({
    required BuildContext context,
    required int index,
    required Locale? data,
    required bool selectedItem,
  }) {
    bool lastIndex = index == ((themes?.length ?? 0) - 1);
    LocalizationController themeController = Provider.of<LocalizationController>(context, listen: false);

    Color themePrimaryColor = primaryColor;

    return GestureDetector(
      onTap: () {
        themeController.changeLanguage(locale: data);
        debugPrint('Language code: ${data?.languageCode}');
        debugPrint('Country code: ${data?.countryCode}');
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
            '${data?.languageCode} Language',
            style: TextStyle(
              fontSize: 14,
              color: selectedItem ? themePrimaryColor : null,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          trailing: Icon(
            selectedItem ? Icons.radio_button_checked : Icons.circle_outlined,
            color: selectedItem ? themePrimaryColor : null,
          ),
        ),
      ),
    );
  }
}
