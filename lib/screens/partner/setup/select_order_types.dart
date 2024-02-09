import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../controllers/partner/membership_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/enums/enums.dart';
import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_text_field.dart';

class SelectOrderTypes extends StatefulWidget {
  const SelectOrderTypes({Key? key, this.route, this.type, this.editMode}) : super(key: key);
  final bool? editMode;
  final String? route;
  final ServiceType? type;

  @override
  State<SelectOrderTypes> createState() => _SelectOrderTypesState();
}

class _SelectOrderTypesState extends State<SelectOrderTypes> {
  late bool? editMode = widget.editMode;
  late String? route = widget.route;
  late ServiceType? type = widget.type;

  Set<OrderTypes?>? selectedOrderTypes = {};
  List<OrderTypes>? orderTypes;

  bool? isPaidSelfPicking = false;
  TextEditingController selfPickingEntryFeeCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint("type == ServiceType.nursery ${type == ServiceType.nursery}");
      debugPrint("orderTypes.length  ${orderTypes?.length}");
      if (type == ServiceType.nursery) {
        orderTypes = [
          OrderTypes.readyToPick,
          OrderTypes.delivery,
        ];

        setState(() {});
      } else {
        orderTypes = OrderTypes.values;
      }

      debugPrint("orderTypes.length  ${orderTypes?.length}");
      PartnerController partner = Provider.of<PartnerController>(context, listen: false);
      if (partner.partnerData?.isFreeSelfPicking != null) {
        isPaidSelfPicking = partner.partnerData?.isFreeSelfPicking == "Yes" ? false : true;
      }
      selfPickingEntryFeeCtrl.text = "${partner.partnerData?.eachPersonAmount ?? ""}";
      setState(() {});
      MembershipController membershipController = Provider.of<MembershipController>(context, listen: false);
      selectedOrderTypes = membershipController.partnerOrderTypes;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${editMode == true ? "Edit" : ""} ${type?.value} Order Type"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Select Order Type",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: primaryColor),
              ),
            ),
            if (orderTypes.haveData)
              ListView.builder(
                shrinkWrap: true,
                itemCount: orderTypes?.length,
                padding: const EdgeInsets.only(top: 8),
                itemBuilder: (context, index) {
                  var data = orderTypes?.elementAt(index);
                  bool selected = selectedOrderTypes?.contains(data) == true;

                  return Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: defaultBoxShadow(),
                      border: Border.all(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                            value: selected,
                            dense: true,
                            title: Text(data?.value ?? '', style: const TextStyle(color: Colors.black, fontSize: 14)),
                            activeColor: primaryColor,
                            onChanged: (val) {
                              if (selected) {
                                selectedOrderTypes?.remove(data);
                              } else {
                                selectedOrderTypes?.add(data);
                              }
                              setState(() {});
                            }),
                        if (selected && data == OrderTypes.uPick)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${isPaidSelfPicking == true ? "Paid" : "Free"} Self Picking Entry",
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      value: isPaidSelfPicking ?? false,
                                      onChanged: (val) {
                                        isPaidSelfPicking = val;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (isPaidSelfPicking == true)
                                CustomTextField(
                                  keyboardType: TextInputType.number,
                                  controller: selfPickingEntryFeeCtrl,
                                  prefixIcon: const Icon(Icons.attach_money),
                                  hintText: "Enter entry charges",
                                  labelText: "Self Picking Entry charges",
                                  borderRadius: 8,
                                  validator: (val) {
                                    return Validator.numberValidator(val);
                                  },
                                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                                ),
                            ],
                          )
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        height: 45,
        text: editMode == true ? "Update" : "Continue",
        backgroundColor: primaryColor,
        fontSize: 18,
        onPressed: () {
          nextSetup();
        },
        mainAxisAlignment: MainAxisAlignment.center,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future nextSetup() async {
    if (formKey.currentState?.validate() == true && selectedOrderTypes?.isNotEmpty == true) {
      context.read<PartnerController>().addOrderType(
            context: context,
            route: route,
            editMode: editMode,
            isPaidSelfPicking: isPaidSelfPicking,
            eachPersonAmount: selfPickingEntryFeeCtrl.text,
            selectedOrderTypes: selectedOrderTypes,
          );
    } else {
      String error = "Select At-least 1 Order Type";
      if (formKey.currentState?.validate() == false) {
        error = "Enter Self Picking Charges";
      }

      showSnackBar(
          context: context, text: error, color: Colors.red, textColor: Colors.white, icon: Icons.error_outline);
    }
  }
}
