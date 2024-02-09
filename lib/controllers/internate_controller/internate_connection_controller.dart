import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/widgets/widgets.dart';


// class InterNateControllers extends ChangeNotifier {
//   final Connectivity _connectivity = Connectivity();
//   @override
//   void onInit() {
//
//     _connectivity.onConnectivityChanged.listen((event) {
//       _updateConnectionStatus(event);
//     });
//     super.onInit();
//   }
//
//   void _updateConnectionStatus(ConnectivityResult connectivityResult) {
//     if (connectivityResult == ConnectivityResult.none) {
//       showSnackBar(context:context , text:  'No Internal Connection !', color: Colors.green);
//       Get.rawSnackbar(
//           backgroundColor: Get.isDarkMode ? Colors.red.shade100 : Colors.black,
//           messageText: const Text(
//             "No Internal Connection !",
//             style: TextStyle(color: Colors.white),
//           ),
//           isDismissible: false,
//           duration: const Duration(days: 1),
//           icon: const Icon(
//             Icons.wifi_off,
//             color: Colors.white,
//             size: 35,
//           ),
//           margin: EdgeInsets.zero,
//           snackStyle: SnackStyle.FLOATING);
//     } else {
//       if (Get.isSnackbarOpen) {
//         Get.closeCurrentSnackbar();
//       }
//     }
//   }
//
// }
