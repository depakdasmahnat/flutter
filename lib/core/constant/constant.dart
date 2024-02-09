import 'package:flutter/material.dart';
import 'package:gaas/controllers/dashboard_controller.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/order_type_data.dart';
import '../config/app_images.dart';
import '../enums/enums.dart';
import '../functions.dart';

double calculateDiscount({
  required String? mrpPrice,
  required String? salesPrice,
}) {
  double discountPercentage = 0;
  double mrp = 0;
  double sales = 0;

  if (mrpPrice != null && salesPrice != null) {
    discountPercentage = ((sales - mrp) / mrp) * 100;
  }

  return discountPercentage;
}

Color statusColor({required String? status}) {
  Color color = Colors.grey;
  switch (status) {
    case "Successful":
      color = primaryColor;
      break;
    case "Completed":
      color = primaryColor;
      break;

    case "Ready To Pick":
      color = Colors.orangeAccent;
      break;
    case "Processing":
      color = Colors.blue;
      break;
    case "Requested":
      color = Colors.blue;
      break;
    case "Pending":
      color = Colors.orangeAccent;
      break;
    case "Failed":
      color = Colors.red;
      break;
    case "On Hold":
      color = Colors.red;
      break;
    case "Canceled":
      color = Colors.red;
      break;
  }
  return color;
}

Color partnerStatusColor({required String? status}) {
  Color color = Colors.white;

  switch (status) {
    case "Accepted":
      color = primaryColor;
      break;
    case "Pending":
      color = Colors.blue;
      break;
    case "Rejected":
      color = Colors.red;
      break;
    case "On Hold":
      color = Colors.red;
      break;
  }
  return color;
}

List<OrderTypeData> orderTypes({
  required BuildContext context,
  bool? all,
}) {
  DashboardController dashboardController = Provider.of<DashboardController>(context);
  var serviceType = dashboardController.serviceType;
  return [
    if (all == true) OrderTypeData(type: AllOrderTypes.all),
    if (serviceType == ServiceType.freshProduce)
      OrderTypeData(type: AllOrderTypes.uPick, image: AppImages.deliveryMan2),
    OrderTypeData(type: AllOrderTypes.readyToPick, image: AppImages.deliveryMan),
    OrderTypeData(type: AllOrderTypes.delivery, image: AppImages.fastDelivery),
  ];
}

List shortingFilter = [
  {
    "id": "PHL",
    "title": "Price (High-Low)",
  },
  {
    "id": "PLH",
    "title": "Price (Low-High)",
  },
  {
    "id": "RHL",
    "title": "Rating (High-Low)",
  },
  {
    "id": "RLH",
    "title": "Rating (Low-High)",
  },
];
List serviceShortingFilter = [
  {
    "id": "RHL",
    "title": "Rating (High-Low)",
  },
  {
    "id": "RLH",
    "title": "Rating (Low-High)",
  },
];

List<String> otherFilters = ["Nearest", "On Offers"];

String formattedDateTime({String? dateTime}) {
  String dateString = '$dateTime';
  DateTime date = DateTime.parse(dateString);

  String formattedDate = DateFormat('MM/dd/yyyy, hh:mm a').format(date.toUtc());

  // debugPrint(formattedDate);
  return formattedDate;
}

String? formattedDate({DateTime? date}) {
  String? formattedDate;
  if (date != null) {
    formattedDate = DateFormat('MM/dd/yyyy').format(date.toLocal());
  }
  // debugPrint(formattedDate);
  return formattedDate;
}

String formattedTimeOnly({String? dateTime}) {
  if (dateTime == null) {
    return '';
  }

  DateTime date = DateTime.parse(dateTime);
  String formattedTime = DateFormat('hh:mm a').format(date.toLocal());

  return formattedTime;
}

double defaultCategoriesSize(BuildContext context) => deviceSpecificValue(
      context: context,
      device: 120,
      tablet: 160,
      desktop: 180,
    ).toDouble();
