import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/orders/cart_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/dashboard/producer_details_model.dart';
import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';

class PeoplesCounterButtons extends StatefulWidget {
  const PeoplesCounterButtons(
      {Key? key, required this.producer, this.hideCounter, this.onCartEmpty, this.refreshPaymentSummary})
      : super(key: key);

  final ProducerDetailsData? producer;

  final bool? hideCounter;
  final bool? refreshPaymentSummary;
  final GestureTapCallback? onCartEmpty;

  @override
  State<PeoplesCounterButtons> createState() => _PeoplesCounterButtonsState();
}

class _PeoplesCounterButtonsState extends State<PeoplesCounterButtons> {
  late bool? refreshPaymentSummary = widget.refreshPaymentSummary;

  @override
  Widget build(BuildContext context) {
    ProducerDetailsData? producer = widget.producer;
    TextEditingController countCtrl = TextEditingController(text: "${producer?.noOfPersons ?? "1"}");

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
                  newCount = controller.setNoOfPeoplesCount(
                    producerId: producer?.id,
                    quantity: countCtrl.text,
                    removeOne: true,
                    context: context,
                  );
                } else {
                  newCount = controller.setNoOfPeoplesCount(
                    context: context,
                    producerId: producer?.id,
                    quantity: countCtrl.text,
                    addOne: true,
                  );
                }

                countCtrl.text = "$newCount";
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

    return Column(
      children: [
        if (producer?.eachPersonAmount != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "\$${producer?.eachPersonAmount}/Person",
              style: const TextStyle(color: primaryColor, fontSize: 16),
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            countButton(
              context: context,
              decreaseMode: true,
              gradient: producer?.noOfPersons == 0 ? blankGradient : null,
              margin: const EdgeInsets.only(right: 12),
            ),
            CustomTextField(
              height: 20,
              width: 35,
              borderRadius: 4,
              borderColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              controller: countCtrl,
              hintText: "1",
              onChanged: (val) {
                CartController controller = Provider.of<CartController>(context, listen: false);
                controller.setNoOfPeoplesCount(
                  context: context,
                  producerId: producer?.id,
                  quantity: countCtrl.text,
                );
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
              decreaseMode: false,
              margin: const EdgeInsets.only(left: 12),
            ),
          ],
        ),
      ],
    );
  }
}
