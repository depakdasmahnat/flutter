import 'package:flutter/material.dart';
import 'package:gaas/core/services/database/local_database.dart';
import 'package:geocoder/model.dart';
import 'package:provider/provider.dart';

import '../../controllers/orders/cart_controller.dart';
import '../../core/constant/colors.dart';
import '../../core/enums/enums.dart';
import '../../utils/validators.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/widgets.dart';

class ManageOrderAddress extends StatefulWidget {
  const ManageOrderAddress({
    super.key,
    this.latitude,
    this.longitude,
    this.address,
  });

  final double? latitude;
  final double? longitude;
  final Address? address;

  @override
  State<ManageOrderAddress> createState() => _ManageOrderAddressState();
}

class _ManageOrderAddressState extends State<ManageOrderAddress> {
  GlobalKey<FormState> addAddressFormKey = GlobalKey<FormState>();
  LocalDatabase localDatabase = LocalDatabase();
  late Address? address = widget.address;

  late TextEditingController nameCtrl = TextEditingController(text: localDatabase.name ?? "");
  late TextEditingController addressCtrl = TextEditingController(text: address?.addressLine ?? "");
  late TextEditingController localityCtrl = TextEditingController(text: address?.subAdminArea ?? "");
  late TextEditingController landmarkCtrl = TextEditingController(text: address?.subLocality ?? "");
  String? addressType = AddressTypes.home.value;
  bool? isDefaultAddress = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addAddressFormKey,
      child: Stack(
        children: [
          Column(
            children: [
              CustomTextField(
                controller: nameCtrl,
                autofocus: true,
                prefixIcon: const Icon(Icons.person, color: primaryColor),
                validator: (val) {
                  return Validator.nameValidator(val);
                },
                labelText: "Name",
                hintText: "Name",
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  children: [
                    headingText(text: "Address Type", context: context),
                    SizedBox(
                      height: 42,
                      child: ListView.builder(
                        itemCount: AddressTypes.values.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var data = AddressTypes.values.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                addressType = data.value;
                              });
                            },
                            child: imageChips(
                              firstChip: index == 0,
                              text: data.value,
                              selected: addressType == data.value,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              CustomTextField(
                controller: addressCtrl,
                autofocus: true,
                prefixIcon: const Icon(Icons.location_on, color: primaryColor),
                validator: (val) {
                  if (val?.isEmpty == true) {
                    return 'Address is required';
                  } else {
                    return null;
                  }
                },
                minLines: 1,
                maxLines: 4,
                labelText: "Address",
                hintText: "*",
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              ),
              CustomTextField(
                controller: localityCtrl,
                autofocus: true,
                prefixIcon: const Icon(Icons.share_location, color: primaryColor),
                validator: (val) {
                  if (val?.isEmpty == true) {
                    return 'Locality is required';
                  } else {
                    return null;
                  }
                },
                minLines: 1,
                maxLines: 4,
                labelText: "FLat /House No /Floor /Building *",
                hintText: "Name",
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              ),
              CustomTextField(
                controller: landmarkCtrl,
                autofocus: true,
                prefixIcon: const Icon(Icons.location_city, color: primaryColor),
                labelText: "Nearby Landmark(optional)",
                hintText: "Nearby Landmark",
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Set Default Address",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Switch(
                      value: isDefaultAddress ?? false,
                      onChanged: (val) {
                        isDefaultAddress = val;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomButton(
              height: 45,
              mainAxisAlignment: MainAxisAlignment.center,
              text: "Save Address",
              onPressed: () {
                if (addAddressFormKey.currentState?.validate() == true) {
                  context.read<CartController>().manageAddressApi(
                        context: context,
                        name: nameCtrl.text,
                        addressType: addressType,
                        houseAddress: addressCtrl.text,
                        locality: localityCtrl.text,
                        landmark: landmarkCtrl.text,
                        address: address,
                        isDefault: isDefaultAddress,
                      );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  headingText({
    required String text,
    EdgeInsets? padding,
    required BuildContext context,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 8),
      child: Row(
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
