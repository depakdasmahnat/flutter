import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../controllers/orders/cart_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/strings.dart';
import '../../../models/dashboard/producer_details_model.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';

class CounterButtons extends StatefulWidget {
  const CounterButtons(
      {Key? key,
      required this.producer,
      required this.product,
      this.showTotal,
      this.hideCounter,
      this.onCartEmpty,
      this.refreshPaymentSummary})
      : super(key: key);

  final ProducerDetailsData? producer;
  final ProducerProducts? product;
  final bool? showTotal;
  final bool? hideCounter;
  final bool? refreshPaymentSummary;
  final GestureTapCallback? onCartEmpty;

  @override
  State<CounterButtons> createState() => _CounterButtonsState();
}

class _CounterButtonsState extends State<CounterButtons> {
  late bool? refreshPaymentSummary = widget.refreshPaymentSummary;

  @override
  Widget build(BuildContext context) {
    ProducerDetailsData? producer = widget.producer;
    ProducerProducts? product = widget.product;
    bool showTotal = widget.showTotal ?? true;
    bool? hideCounter = widget.hideCounter;
    GestureTapCallback? onCartEmpty = widget.onCartEmpty;
    TextEditingController countCtrl = TextEditingController(text: "${product?.quantity ?? ""}");
    CartController cartController = Provider.of<CartController>(context);
    ProducerProducts? cartProduct;
    if (hideCounter == false) {
      cartProduct = cartController.getProduct(producerId: producer?.id, productId: product?.id);
    }
    if (cartProduct?.quantity != null) {
      countCtrl.text = "${cartProduct?.quantity}";
    }

    Widget countButton({
      required BuildContext context,
      required bool decreaseMode,
      double? height,
      double? width,
      Color? iconColor,
      Gradient? gradient,
      EdgeInsets? margin,
      List<BoxShadow>? iconShadows,
      GestureTapCallback? onTap,
    }) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 24,
            width: 24,
            margin: margin ?? EdgeInsets.zero,
            child: GradientButton(
              borderWidth: 2,
              height: 24,
              width: 24,
              radius: 20,
              gradient: gradient ?? primaryGradient,
              onTap: () {
                CartController controller = Provider.of<CartController>(context, listen: false);
                int newCount = 0;

                if (decreaseMode) {
                  newCount = controller.changeCount(
                      producer: producer,
                      productId: product?.id,
                      quantity: countCtrl.text,
                      limit: product?.initialInventory,
                      removeOne: true,
                      context: context,
                      onCartEmpty: onCartEmpty,
                      debounceEffect: true,
                      refreshPaymentSummary: refreshPaymentSummary);
                } else {
                  newCount = controller.changeCount(
                      context: context,
                      producer: producer,
                      productId: product?.id,
                      quantity: countCtrl.text,
                      limit: product?.initialInventory,
                      addOne: true,
                      onCartEmpty: onCartEmpty,
                      debounceEffect: true,
                      refreshPaymentSummary: refreshPaymentSummary);
                }

                if (newCount <= (product?.initialInventory ?? 0)) {
                  countCtrl.text = "$newCount";
                  setState(() {});
                }
              },
              child: Center(
                  child: Icon(
                decreaseMode ? CupertinoIcons.minus : Icons.add,
                color: iconColor ?? primaryColor,
                size: 14,
                shadows: iconShadows ?? [],
              )),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (showTotal == true)
          Text(
            "\$ ${(num.parse("${countCtrl.text.isNotEmpty ? countCtrl.text : 0}") * num.parse("${(product?.price ?? 0)}")).toStringAsFixed(2)}",
            style: const TextStyle(color: primaryColor, fontSize: 16),
          ),
        const SizedBox(height: 8),
        if (hideCounter == true)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${countCtrl.text} ${product?.unitName}"),
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              countButton(
                context: context,
                decreaseMode: true,
                gradient: widget.product?.quantity == 0 ? blankGradient : null,
                margin: const EdgeInsets.only(right: 12),
              ),
              CustomTextField(
                height: 20,
                width: 35,
                borderRadius: 4,
                borderColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                controller: countCtrl,
                hintText: "0",
                onChanged: (val) {
                  CartController controller = Provider.of<CartController>(context, listen: false);
                  controller.changeCount(
                      context: context,
                      producer: producer,
                      productId: product?.id,
                      quantity: countCtrl.text,
                      limit: product?.initialInventory,
                      onCartEmpty: onCartEmpty,
                      refreshPaymentSummary: refreshPaymentSummary);
                },
                margin: const EdgeInsets.symmetric(horizontal: 6),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                errorStyle: const TextStyle(fontSize: 7),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }

                  final isNumeric = double.tryParse(value) != null;
                  if (!isNumeric) {
                    return 'Field must contain only numeric characters';
                  } else if (isNumeric && num.parse(value) > (product?.initialInventory ?? 0)) {
                    showSnackBar(context: context, text: productLimitExceed);

                    return 'Order limit exceed';
                  }
                  return null;
                },
              ),
              countButton(
                context: context,
                decreaseMode: false,
                margin: const EdgeInsets.only(left: 12),
              ),
            ],
          ),
      ],
    );
  }
}
