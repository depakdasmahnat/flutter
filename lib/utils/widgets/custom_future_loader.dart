import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Future ShowFutureLoader({
  required BuildContext context,
  required Future future,
  Widget? message,
}) async {
  return showDialog(
    context: context,
    builder: (context) => CustomFutureLoader(
      future: future,
      message: message,
    ),
  );
}

class CustomFutureLoader extends StatelessWidget {
  final Future future;
  final BoxDecoration? decoration;
  final double opacity;
  final Widget? progress;
  final Widget? message;

  const CustomFutureLoader({
    super.key,
    required this.future,
    this.decoration,
    this.opacity = 1.0,
    this.progress,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    future.then((val) {
      Navigator.of(context).pop(val);
    }).catchError((e) {
      /// Navigator.of(context).pop(val);

      debugPrint('Future Progress Dialog Catch Error...');
      debugPrint('Error is $e');
    });

    return WillPopScope(
      onWillPop: () {
        return Future(() {
          return false;
        });
      },
      child: _buildDialog(context),
    );
  }

  Widget _buildDialog(BuildContext context) {
    Widget content;
    if (message == null) {
      content = Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: decoration ?? _defaultDecoration,
          child: progress ?? const CircularProgressIndicator(),
        ),
      );
    } else {
      content = Container(
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: decoration ?? _defaultDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            progress ?? const CircularProgressIndicator(),
            const SizedBox(height: 20),
            _buildText(context),
          ],
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Opacity(
        opacity: opacity,
        child: content,
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    if (message == null) {
      return const SizedBox.shrink();
    }
    return Expanded(
      flex: 1,
      child: message!,
    );
  }
}

const _defaultDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(
    Radius.circular(12),
  ),
);
