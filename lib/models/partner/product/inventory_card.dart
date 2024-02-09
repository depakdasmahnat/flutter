import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/utils/validators.dart';
import 'package:gaas/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../controllers/partner/product_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/constant/shadows.dart';
import '../../../models/partner/product/my_products_model.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/image_view.dart';

class InventoryCard extends StatefulWidget {
  const InventoryCard({Key? key, required this.index, required this.data, this.hideCounter}) : super(key: key);
  final int index;
  final MyProductsData? data;
  final bool? hideCounter;

  @override
  State<InventoryCard> createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  late MyProductsData? data = widget.data;

  late TextEditingController salesPriceCtrl = TextEditingController(text: data?.price ?? "");
  late TextEditingController mrpPriceCtrl = TextEditingController(text: data?.mrpPrice ?? "");
  late TextEditingController quantityCtrl = TextEditingController(text: "${data?.initialInventory ?? ""}");
  GlobalKey<FormState> inventoryProductsKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: inventoryProductsKey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: primaryBoxShadow(),
            ),
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                ImageView(
                  height: 100,
                  width: 100,
                  border: Border.all(color: Colors.grey.shade100),
                  networkImage: "${data?.image}",
                  fit: BoxFit.contain,
                  margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data?.name}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          "${quantityCtrl.text} ${data?.unitName}.",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      CustomTextField(
                        height: 30,
                        width: 100,
                        borderRadius: 4,
                        borderColor: Colors.transparent,
                        onChanged: (val) {
                          ProductController controller = Provider.of<ProductController>(context, listen: false);
                          controller.changeMrpPrice(id: data?.id, price: val);
                        },
                        style: const TextStyle(color: Colors.red),
                        prefix: const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Text(
                            "\$",
                            style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        errorStyle: const TextStyle(fontSize: 7),
                        contentPadding: EdgeInsets.zero,
                        controller: mrpPriceCtrl,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          return Validator.numericValidator(val);
                        },
                        margin: const EdgeInsets.only(),
                      ),
                      CustomTextField(
                        height: 30,
                        width: 100,
                        borderRadius: 4,
                        borderColor: Colors.transparent,
                        onChanged: (val) {
                          ProductController controller = Provider.of<ProductController>(context, listen: false);
                          controller.changeSalesPrice(id: data?.id, price: val);
                        },
                        prefix: const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Text(
                            "\$",
                            style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        style: const TextStyle(color: primaryColor),
                        errorStyle: const TextStyle(fontSize: 7),
                        contentPadding: EdgeInsets.zero,
                        controller: salesPriceCtrl,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          return Validator.validatePrices(val ?? "", mrpPriceCtrl.text);
                        },
                        margin: const EdgeInsets.only(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Inventory",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 8),
                if (widget.hideCounter != true)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      countButton(
                        context: context,
                        index: widget.index,
                        decreaseMode: true,
                        margin: EdgeInsets.zero,
                      ),
                      CustomTextField(
                        height: 20,
                        width: 35,
                        borderRadius: 4,
                        borderColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        controller: quantityCtrl,
                        hintText: "0",
                        onChanged: (val) {
                          ProductController controller = Provider.of<ProductController>(context, listen: false);
                          controller.changeQuantity(id: data?.id, quantity: val);
                        },
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        errorStyle: const TextStyle(fontSize: 7),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          return Validator.numericValidator(val);
                        },
                      ),
                      countButton(
                        context: context,
                        index: widget.index,
                        decreaseMode: false,
                        margin: const EdgeInsets.only(right: 8),
                      ),
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget countButton({
    required BuildContext context,
    required int index,
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
              ProductController controller = Provider.of<ProductController>(context, listen: false);
              int newInitialInventory = 0;
              if (decreaseMode) {
                newInitialInventory =
                    controller.changeQuantity(id: data?.id, quantity: quantityCtrl.text, removeOne: true);
              } else {
                newInitialInventory =
                    controller.changeQuantity(id: data?.id, quantity: quantityCtrl.text, addOne: true);
              }

              quantityCtrl.text = "$newInitialInventory";
              setState(() {});
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
}
