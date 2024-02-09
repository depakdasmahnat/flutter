import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/location/location_controller.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/app_images.dart';
import '../../../utils/widgets/image_view.dart';

AppBar userAppBar({
  required BuildContext context,
  num? notifications,
  bool? showCart = true,
  List<Widget>? actions,
  GestureTapCallback? onSuccess,
}) {
  Size size = MediaQuery.of(context).size;

  LocationController location = Provider.of<LocationController>(context);
  CartController cartController = Provider.of<CartController>(context);
  return AppBar(
    title: Row(
      children: [
        const ImageView(
          assetImage: AppImages.appIcon,
          height: 45,
          width: 45,
          margin: EdgeInsets.zero,
        ),
        GestureDetector(
            onTap: () async {
              context
                  .read<LocationController>()
                  .showLocationPopup(
                    context: context,
                    onSuccess: onSuccess,
                  )
                  .then((value) {
                context.read<LocationController>().closeLocationPopupStatus();
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 60,
                    child: Text(
                      AppConfig.apkName,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_sharp,
                        color: Colors.black,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: size.width * 0.50,
                        child: Text(
                          location.address?.addressLine ?? "Select Location",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    ),

    actions: actions ??
        <Widget>[
          if (showCart == true)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Badge(
                    offset: const Offset(8, -6),
                    label: Text("${cartController.getProductsCount()}"),
                    backgroundColor: primaryColor,
                    isLabelVisible: (cartController.getProductsCount() > 0),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        context.push(Routs.cart);
                      },
                      child: const Icon(
                        CupertinoIcons.cart,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Badge(
                  label: Text("$notifications"),
                  offset: const Offset(4, -4),
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  isLabelVisible: notifications != null,
                  child: InkWell(
                    onTap: () {
                      context.push(Routs.notifications);
                    },
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ), //IconButton
        ], //<Widget>[]
  );
}
