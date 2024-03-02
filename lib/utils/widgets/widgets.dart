import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/colors.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';

import '../../app.dart';

Widget backButton({required Icon icon}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.3),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
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
      padding: const EdgeInsets.all(2.0),
      child: icon,
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({
  required BuildContext context,
  required String text,
  Color? color,
  Color? textColor,
  IconData? icon,
  Duration? duration,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.all(10),
      shape: const StadiumBorder(),
      duration: duration ?? const Duration(milliseconds: 3000),
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
          Icon(
            icon ?? CupertinoIcons.checkmark_alt_circle,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: color ?? Colors.black,
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError({
  required BuildContext context,
  required String? message,
}) {
  return showSnackBar(
    context: context,
    text: message ?? 'Something Went Wrong',
    color: Colors.red,
    icon: Icons.error_outline,
  );
}

void showBanner({
  required BuildContext context,
  required String text,
  required Color color,
}) {
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
              'Ok',
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
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    text,
                    style: const TextStyle(
                      color: primaryColor,
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
        const TextSpan(text: 'I agree to accept your '),
        TextSpan(
            text: 'Privacy Policy ',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint('Privacy Policy');
              }),
        const TextSpan(text: 'and  '),
        TextSpan(
            text: 'Terms of Service ',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint('Terms of Service');
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
                        color: backgroundColor ?? context.colorScheme.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: context.colorScheme.primary,
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
  showSnackBar(context: context, text: message);
}

InkWell notificationBadge(context) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, Routs.notifications);
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

customRow({
  required String? title1,
  required String? title2,
  IconData? icon1,
  IconData? icon2,
  bool? lastDetail,
}) {
  return Padding(
    padding: EdgeInsets.only(top: 8, bottom: lastDetail == true ? 16 : 0),
    child: Row(
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),
        )
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

Future<bool> onAppExit() async {
  BuildContext? context = MyApp.navigatorKey.currentContext;
  bool? shouldPop;

  if (context != null) {
    shouldPop = await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              'Close App',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text('Are you sure you want to close the app ?'),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop(false);
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pop(true);
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          );
        });
  }

  return shouldPop ?? false;
}

pickImageButton({required BuildContext context, required String text, required IconData icon}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 16, 4, 16),
    child: Container(
      height: 45,
      constraints: const BoxConstraints(
        minWidth: 150.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
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
