import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/main.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_images.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/gradients.dart';
import '../../models/partner/auth/check_timeline_status.dart';
import '../../route/route_paths.dart';
import '../../screens/partner/setup/select_timeslots.dart';
import '../widgets/image_view.dart';
import 'package:html/parser.dart' show parse;

Color mainThemeColor = Colors.blue;

Widget appTitle(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "Quiz ",
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
        const TextSpan(
          text: "Mania",
          style: TextStyle(
            fontSize: 20,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget showMoreDescription({
  required BuildContext context,
  required String? description,
  TextStyle? style,
  int? maxLines,
  TextOverflow? overFlow,
}) {
  return RichText(
    maxLines: maxLines,
    overflow: overFlow ?? TextOverflow.clip,
    text: TextSpan(
      children: [
        TextSpan(
          text: "$description",
          style: style ??
              TextStyle(
                fontSize: 12,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w400,
              ),
        ),
        // const TextSpan(
        //   text: "Show More",
        //   style: TextStyle(
        //     fontSize: 12,
        //     color: primaryColor,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ],
    ),
  );
}

Widget customTitle({
  required BuildContext context,
  required String text,
  required String text2,
}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: text2,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget contentText({required String text}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    ),
  );
}

Widget backButton({
  required BuildContext context,
  IconData? icon,
  EdgeInsets? margin,
  GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap ??
        () {
          context.pop();
        },
    child: Container(
      margin: margin ?? const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.3),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          icon ?? Icons.arrow_back,
          color: primaryColor,
        ),
      ),
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({
  required BuildContext context,
  required String text,
  Color? color,
  Color? textColor,
  Color? iconColor,
  IconData? icon,
  Duration? duration,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.all(10),
      shape: const StadiumBorder(),
      duration: duration ?? const Duration(milliseconds: 2400),
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
          Icon(
            icon ?? Icons.check_circle,
            color: iconColor ?? Colors.white,
          ),
        ],
      ),
      backgroundColor: color ?? primaryColor,
    ),
  );
}

void showBanner({
  required String text,
  required Color color,
}) {
  BuildContext context = MyApp.navigatorKey.currentContext!;
  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      backgroundColor: color,
      leading: const Icon(Icons.error, color: Colors.white),
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text(
              "Ok",
              style: TextStyle(
                color: Colors.blue,
              ),
            )),
      ],
    ),
  );
  Future.delayed(const Duration(milliseconds: 2000)).then(
    (value) => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
  );
}

Future showLoading({required BuildContext context, required String text}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoActivityIndicator(
                      radius: 14,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      });
}

Future loadingDialog({
  required BuildContext context,
  required Future future,
  String? message,
}) async {
  return await showDialog(
    context: context,
    builder: (context) => FutureProgressDialog(
      future,
      message: message != null ? Text('$message...') : null,
    ),
  );
}

Widget termsAndConditions(BuildContext context) {
  TextStyle defaultStyle = TextStyle(fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.w500);
  TextStyle linkStyle = TextStyle(
      fontSize: 10,
      color: Colors.grey.shade400,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline);
  return RichText(
    maxLines: 4,
    text: TextSpan(
      style: defaultStyle,
      children: <TextSpan>[
        const TextSpan(text: "I agree to accept your "),
        TextSpan(
            text: "Privacy Policy ",
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint("Privacy Policy");
              }),
        const TextSpan(text: 'and  '),
        TextSpan(
            text: "Terms of Service ",
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint("Terms of Service");
              }),
      ],
    ),
  );
}

Widget rowBox({
  Key? key,
  required Color circleColor,
  required Text text,
  required Icon icon,
  required Icon trailerIcon,
  required BuildContext context,
  required GestureTapCallback onTap,
  required GestureTapCallback onTrailerTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
      color: Colors.white,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              CircleAvatar(
                backgroundColor: circleColor,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: icon,
                ),
              ),
              const SizedBox(width: 16),
              text,
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: onTrailerTap, icon: trailerIcon),
          ),
        ],
      ),
    ),
  );
}

Widget rowBox1({
  required BuildContext context,
  required Color circleColor1,
  required Color circleColor2,
  required Text text1,
  required Text text2,
  required Icon icon1,
  required Icon icon2,
  required GestureTapCallback onTap1,
  required GestureTapCallback onTap2,
}) {
  return Row(
    children: [
      Expanded(
        flex: 5,
        child: InkWell(
          onTap: onTap1,
          child: Container(
            margin: const EdgeInsets.fromLTRB(6, 0, 0, 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).primaryColor,
            ),
            height: 80,
            child: Row(
              children: [
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: circleColor1,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: icon1,
                  ),
                ),
                const SizedBox(width: 16),
                text1,
              ],
            ),
          ),
        ),
      ),
      Expanded(
        flex: 5,
        child: InkWell(
          onTap: onTap2,
          child: Container(
            margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: circleColor2,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: icon2,
                  ),
                ),
                const SizedBox(width: 16),
                text2
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Future showLoader({
  required BuildContext context,
  required String text,
  Color? backgroundColor,
}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SimpleDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(
                        color: backgroundColor ?? primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

void copyText({
  required BuildContext context,
  required String textToCopy,
  required String message,
  Color? color,
  Color? textColor,
}) {
  Clipboard.setData(ClipboardData(text: textToCopy));
  showSnackBar(context: context, text: message, color: color ?? Colors.blueAccent);
}

InkWell notificationBadge({required BuildContext context}) {
  return InkWell(
    onTap: () {
      context.pushNamed(Routs.notifications);
    },
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Icon(
        CupertinoIcons.bell,
        color: Colors.white,
      ),
    ),
  );
}

Column leadingButton({required BuildContext context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_rounded),
        color: Colors.white,
        iconSize: 20,
        padding: EdgeInsets.zero,
      )
    ],
  );
}

imageChips({
  required String? text,
  bool selected = false,
  String? imageUrl,
  Color? iconColor,
  EdgeInsets? margin,
  EdgeInsets? padding,
  bool? firstChip,
  bool? leftSideIcon,
  double? fontSize,
  double? height,
  double? width,
  double? imageHeight,
  double? imageWidth,
  double? borderRadius,
  FontWeight? fontWeight,
  bool networkImage = false,
  VoidCallback? onPressed,
}) {
  Color imageColor = iconColor ?? Colors.grey;

  Widget imageWidget() {
    Widget widget = Container();
    if (networkImage == true) {
      widget = ImageView(
        height: imageHeight ?? 14,
        width: imageWidth ?? 14,
        borderRadiusValue: 0,
        color: selected ? Colors.white : imageColor,
        margin: EdgeInsets.only(left: leftSideIcon == true ? 0 : 8, right: leftSideIcon == true ? 8 : 0),
        networkImage: imageUrl,
        fit: BoxFit.contain,
      );
    } else {
      widget = ImageView(
        height: imageHeight ?? 14,
        width: imageWidth ?? 14,
        borderRadiusValue: 0,
        color: selected ? Colors.white : imageColor,
        margin: EdgeInsets.only(left: leftSideIcon == true ? 0 : 8, right: leftSideIcon == true ? 8 : 0),
        assetImage: imageUrl,
        fit: BoxFit.contain,
      );
    }
    return widget;
  }

  return CupertinoButton(
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    child: Container(
      height: height,
      width: width,
      margin: margin ?? EdgeInsets.only(left: firstChip == true ? 16 : 0, right: 12, top: 6, bottom: 6),
      padding: padding ?? const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: selected ? null : Colors.white,
        gradient: selected ? primaryGradient : null,
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        boxShadow: [
          BoxShadow(
              offset: const Offset(2, 2),
              color: Colors.grey.shade300,
              // Shadow for bottom right corner
              blurRadius: 4,
              spreadRadius: 0,
              blurStyle: selected ? BlurStyle.inner : BlurStyle.normal),
          BoxShadow(
              offset: const Offset(-1, -1),
              color: Colors.grey.shade100,
              // Shadow for bottom right corner
              blurRadius: 4,
              spreadRadius: 0,
              blurStyle: selected ? BlurStyle.inner : BlurStyle.normal),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageUrl != null && leftSideIcon == true) imageWidget(),
          Text(
            "$text",
            style: TextStyle(
              fontSize: fontSize ?? 12,
              color: selected ? Colors.white : Colors.black,
              fontWeight: fontWeight ?? FontWeight.w400,
            ),
          ),
          if (imageUrl != null && leftSideIcon == null) imageWidget(),
        ],
      ),
    ),
  );
}

customRow({
  required String? title1,
  required String? title2,
  IconData? icon1,
  IconData? icon2,
  bool? showDivider,
  bool? lastDetail,
  TextStyle? title1Style,
  TextStyle? title2Style,
  EdgeInsets? padding,
}) {
  return Padding(
    padding: padding ?? EdgeInsets.only(top: 12, bottom: lastDetail == true ? 16 : 0, left: 16, right: 16),
    child: Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
                child: Row(
              children: [
                if (icon1 != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      icon1,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                if (title1 != null)
                  Expanded(
                    child: Text(
                      title1,
                      style: title1Style ??
                          const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
              ],
            )),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (icon2 != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        icon2,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  if (title2 != null)
                    Expanded(
                      child: Text(
                        title2,
                        style: title2Style ??
                            const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
        if (showDivider == true)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Divider(color: Colors.grey.shade300, height: 0),
          ),
      ],
    ),
  );
}

headingText({
  required String text,
  EdgeInsets? padding,
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  required BuildContext context,
}) {
  return Padding(
    padding: padding ?? const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 8),
    child: Row(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: fontSize,
                color: color,
                fontWeight: fontWeight,
              ),
        ),
      ],
    ),
  );
}

pickImageButton({required String text, required IconData icon}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 16, 4, 16),
    child: Container(
      height: 45,
      constraints: const BoxConstraints(
        minWidth: 150.0,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget avatarImage({
  double? radius,
  Color? color,
  String? imageUrl,
  EdgeInsets? margin,
}) {
  return ImageView(
    height: radius,
    width: radius,
    borderRadiusValue: 100,
    networkImage: imageUrl,
    assetImage: imageUrl == null ? AppImages.appIcon : null,
    margin: margin ?? const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
  );
}

Set<OrderTypes>? getOrderTypes({required List<String>? orderTypes}) {
  Set<OrderTypes>? selectedOrderTypes = {};

  if (orderTypes?.haveData == true) {
    for (String? orderTypeString in orderTypes ?? []) {
      OrderTypes.values.any((element) {
        bool haveOrderType = element.value == orderTypeString;
        if (haveOrderType == true) {
          selectedOrderTypes.add(element);
        }

        return haveOrderType;
      });
    }
  }
  return selectedOrderTypes;
}

Future<bool> updateTimeSlotsPopup({
  required ServiceType? type,
  required CheckTimeLinesStatus? timeLineStatus,
}) async {
  BuildContext? context = MyApp.navigatorKey.currentContext;
  bool? shouldPop;
  Set<OrderTypes>? orderTypes = getOrderTypes(orderTypes: timeLineStatus?.orderTypes);
  debugPrint("partnerOrderTypes $orderTypes");
  if (context != null) {
    shouldPop = await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Update TimeSlots",
              style: TextStyle(color: primaryColor),
            ),
            content:
                Text(timeLineStatus?.message ?? "You have to update timeslots for ${timeLineStatus?.data} "),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                  context.pushNamed(Routs.selectTimeSlots,
                      extra: SelectTimeSlots(
                        editMode: false,
                        timeLineStatus: timeLineStatus,
                        type: type,
                        selectedOrderTypes: orderTypes,
                      ));
                },
                child: const Text(
                  "Update",
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          );
        });
  }

  return shouldPop ?? false;
}

Future<bool> onAppExit() async {
  BuildContext? context = MyApp.navigatorKey.currentContext;
  bool? shouldPop;

  if (context != null) {
    shouldPop = await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Close App",
              style: TextStyle(color: Colors.red),
            ),
            content: const Text("Are you sure you want to close the app ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          );
        });
  }

  return shouldPop ?? false;
}

Future<bool> onPartnerDashboardBack() async {
  BuildContext? context = MyApp.navigatorKey.currentContext;
  bool? shouldPop;
  if (context != null) {
    shouldPop = await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Close Partner Profile",
              style: TextStyle(color: Colors.red),
            ),
            content: const Text("Are you sure you want to close the partner profile?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          );
        });
  }

  return shouldPop ?? false;
}

String parseHtmlToText({required String htmlString}) {
  final document = parse(htmlString);
  final String parsedText = parse(document.body!.text).documentElement!.text;
  return parsedText;
}
