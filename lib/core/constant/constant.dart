import 'package:flutter/material.dart';

Color statusColor({required String? status}) {
  Color color = Colors.grey;
  switch (status) {
    case 'Processing':
      color = Colors.blue;
      break;
    case 'Successfully':
      color = Colors.green;
      break;
    case 'Failed':
      color = Colors.orangeAccent;
      break;
    case 'Canceled':
      color = Colors.red;
      break;
  }
  return color;
}


