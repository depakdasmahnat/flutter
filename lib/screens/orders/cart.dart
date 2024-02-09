import 'package:flutter/material.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/services/database/local_database.dart';
import '../../models/dashboard/producer_details_model.dart';
import '../../models/orders/cart_Items_model.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/custom_button.dart';
import 'cart_items.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<ProducerDetailsData?>? cartItems = [];
  LocalDatabase localDatabase = LocalDatabase();
  late bool isAuthenticated = localDatabase.accessToken != null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CartController cartController = Provider.of(context, listen: false);

      if (isAuthenticated) {
        cartController.fetchCartItems(context: context).then((value) {
          List<CartItemsData>? items = value;
          cartController.setCartItemsFromServer(items);
        });
      } else {
        localDatabase.getCartItems(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CartController cartController = Provider.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        title: const Text(
          "Cart",
          style: TextStyle(fontSize: 20, letterSpacing: 1.3, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: const CartItems(),
      bottomNavigationBar: (cartController.getProductsCount() > 0)
          ? CustomButton(
              height: 75,
              width: size.width,
              borderRadius: 0,
              text: "Checkout",
              fontSize: 22,
              fontWeight: FontWeight.w700,
              mainAxisAlignment: MainAxisAlignment.center,
              onPressed: () {
                context.push(Routs.checkout);
              },
              margin: EdgeInsets.zero)
          : const SizedBox(),
    );
  }
}
