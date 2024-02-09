import 'package:flutter/material.dart';

extension BuildContextExtenstion on BuildContext {
  Future firstRoute() async {
    return Navigator.of(this).popUntil((route) => route.isFirst);
  }
}
