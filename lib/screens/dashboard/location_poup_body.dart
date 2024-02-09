import 'package:flutter/material.dart';
import 'package:gaas/core/services/search_locations_cards.dart';
import 'package:gaas/screens/map/utils/location_radius_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/location/location_controller.dart';
import '../../core/config/app_config.dart';
import '../../core/constant/colors.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/widgets.dart';

class LocationPopupBody extends StatefulWidget {
  const LocationPopupBody({Key? key, this.onSuccess}) : super(key: key);
  final GestureTapCallback? onSuccess;

  @override
  State<LocationPopupBody> createState() => _LocationPopupBodyState();
}

class _LocationPopupBodyState extends State<LocationPopupBody> {
  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LocationController location = Provider.of<LocationController>(context, listen: false);
      location.checkLocationAccess(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationController location = Provider.of<LocationController>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (location.haveLocationAccess == false || location.haveLocationPermission == false)
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 24, bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        "${AppConfig.apkName} does not have location\naccess",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        "Location helps us access your near...",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  height: 45,
                  icon: const Icon(
                    Icons.my_location_rounded,
                    color: Colors.white,
                  ),
                  text: "Grant location access",
                  onPressed: () async {
                    debugPrint("Grant location access ");

                    LocationController locationController =
                        Provider.of<LocationController>(context, listen: false);
                    await locationController.requestLocationPermission(context: context).then((value) {
                      context.pop();
                      locationController.checkBothLocationPermission(context: context, showPopup: false);
                    });
                  },
                  margin: const EdgeInsets.only(top: 36, bottom: 16),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Divider(color: Colors.grey, height: 1),
                ),
              ],
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        height: 45,
                        icon: const Icon(
                          Icons.my_location_rounded,
                          color: Colors.white,
                        ),
                        text: "Use Current location",
                        onPressed: () async {
                          LocationController location =
                              Provider.of<LocationController>(context, listen: false);

                          await loadingDialog(
                            context: context,
                            future: location.determinePosition(context: context, updateLocation: true),
                          );

                          if (context.mounted) {
                            widget.onSuccess?.call();
                            context.pop();
                          }
                        },
                        margin: const EdgeInsets.only(top: 36, bottom: 16),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 36, bottom: 16, left: 16),
                      decoration: BoxDecoration(
                        color: primaryGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: LocationRadiusPicker(
                          selectedItem: location.locationRange,
                          items: location.locationRanges,
                          onChanged: (range) {
                            location.setLocationRange(range: range);
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          const Text(
            "Select your location",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          SearchLocationCards(
            onSearchChanged: (search) {},
            onLocationSelected: (placesDetailModel) async {
              debugPrint("Search Location ON Change Call");

              LocationController location = Provider.of<LocationController>(context, listen: false);
              await location
                  .setLatLong(
                context: context,
                updateLocation: true,
                latitude: placesDetailModel?.result?.geometry?.location?.lat,
                longitude: placesDetailModel?.result?.geometry?.location?.lng,
                address: Address(
                  featureName: placesDetailModel?.result?.name,
                  addressLine: placesDetailModel?.result?.formattedAddress,
                ),
              )
                  .then(
                (value) {
                  widget.onSuccess?.call();
                  Navigator.pop(context);
                },
              );
            },
          )
        ],
      ),
    );
  }
}
