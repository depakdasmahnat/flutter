import 'package:flutter/cupertino.dart';

import 'loading_screen.dart';
import 'no_data_screen.dart';

class DataWidgetBuilder extends StatelessWidget {
  const DataWidgetBuilder(
      {Key? key,
      required this.child,
      required this.isLoading,
      required this.haveData,
      this.loadingMessage,
      this.errorMessage,
      this.heightFactor,
      this.widthFactor,
      this.loadingWidget,
      this.nodDataWidget})
      : super(key: key);
  final bool isLoading;
  final bool haveData;
  final Widget child;
  final Widget? loadingWidget;
  final Widget? nodDataWidget;
  final String? loadingMessage;
  final String? errorMessage;
  final double? heightFactor;
  final double? widthFactor;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ??
          LoadingScreen(
            heightFactor: heightFactor,
            widthFactor: widthFactor,
            message: loadingMessage,
          );
    } else if (haveData) {
      return child;
    } else {
      return nodDataWidget ??
          NoDataScreen(
            heightFactor: heightFactor,
            widthFactor: widthFactor,
            message: errorMessage,
          );
    }
  }
}
