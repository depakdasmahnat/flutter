import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../controllers/location/location_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/search_locations_cards.dart';
import '../../../models/partner/setup/delivery_zones_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/widgets.dart';
import '../../map/change_map_location.dart';

class SelectDeliveryZones extends StatefulWidget {
  const SelectDeliveryZones({
    Key? key,
    this.route,
    this.type,
    this.selectedOrderTypes,
    this.editMode,
  }) : super(key: key);

  final bool? editMode;
  final String? route;
  final ServiceType? type;
  final Set<OrderTypes?>? selectedOrderTypes;

  @override
  State<SelectDeliveryZones> createState() => _SelectDeliveryZonesState();
}

class _SelectDeliveryZonesState extends State<SelectDeliveryZones> {
  late bool? editMode = widget.editMode;
  late String? route = widget.route;
  late ServiceType? type = widget.type;
  late Set<OrderTypes?> selectedOrderTypes = widget.selectedOrderTypes ?? {};

  double minDistance = 1;
  double maxDistance = 10;
  num? defaultRadius = 5;

  List<DeliveryZonesData?>? deliveryZonesData = [];

  double? latitude;
  double? longitude;
  LatLng? latLng;
  Set<num?>? deleteIds = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
      LocationController location = Provider.of<LocationController>(context, listen: false);
      location.determinePosition(context: context, updateLocation: true).then((value) {});
      partnerController.fetchDeliveryZones(context: context).then((value) {
        deliveryZonesData = value ?? [];
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationController locationController = Provider.of<LocationController>(context);
    PartnerController partnerController = Provider.of<PartnerController>(context);

    latitude = locationController.latitude;
    longitude = locationController.longitude;
    latLng = (latitude != null && longitude != null) ? LatLng(latitude!, longitude!) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("${editMode == true ? "Edit" : ""} Delivery Zones"),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          CustomButton(
            backgroundColor: Colors.white,
            textColor: primaryColor,
            text: "Add Location",
            fontSize: 16,
            height: 45,
            mainAxisAlignment: MainAxisAlignment.center,
            margin: const EdgeInsets.only(top: 22, bottom: 22, left: 16, right: 16),
            onPressed: () {
              context.read<LocationController>().setShowPlacesList(data: true);
              CustomBottomSheet.show(
                context: context,
                isDismissible: false,
                enableDrag: true,
                isScrollControlled: true,
                body: changeLocationPopup(context: context),
                showTitleDivider: true,
              );

              setState(() {});
            },
          ),
          DataWidgetBuilder(
            heightFactor: 0.7,
            isLoading: partnerController.loadingDeliveryZones,
            haveData: deliveryZonesData.haveData,
            child: SizedBox(
              // height: 150,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: deliveryZonesData?.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var data = deliveryZonesData?.elementAt(index);

                  return trainingLocationCard(
                    index: index,
                    context: context,
                    data: data,
                  );
                },
              ),
            ),
          ),
        ],
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

  Widget trainingLocationCard({
    required int index,
    required BuildContext context,
    required DeliveryZonesData? data,
  }) {
    Size size = MediaQuery.of(context).size;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            if (data?.kmRange != null) {
              defaultRadius = data!.kmRange;
              setState(() {});
            }
            CustomBottomSheet.show(
              context: context,
              isDismissible: false,
              enableDrag: true,
              isScrollControlled: true,
              body: changeLocationPopup(context: context, index: index, data: data),
              showTitleDivider: true,
            );
          },
          child: Container(
            width: size.width * 0.8,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: defaultBoxShadow(),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, Routs.changeMapLocation);
                        },
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon((Icons.location_on_outlined), size: 18, color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.65,
                                      child: Text(
                                        "${data?.address}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Row(
                                    children: [
                                      const Icon((Icons.my_location_rounded), size: 15, color: primaryColor),
                                      headingText(
                                        context: context,
                                        text: "${data?.kmRange} KM",
                                        padding: const EdgeInsets.only(left: 8),
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteIds?.add(data?.id);
                          deliveryZonesData?.remove(data);

                          setState(() {});
                          this.setState(() {});
                        },
                        icon: const Icon((CupertinoIcons.multiply_circle), size: 24, color: Colors.red),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${data?.address}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextStyle sliderTextStyle() => const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600);

  Widget changeLocationPopup({
    required BuildContext context,
    int? index,
    DeliveryZonesData? data,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        LocationController location = Provider.of<LocationController>(context, listen: false);
        LocationController locationController = Provider.of<LocationController>(context);
        //
        // onSearch(Place place) async {
        //   debugPrint("$place");
        //   debugPrint(place.description);
        //   place.geolocation.then((value) {
        //     debugPrint("Coordinates Are ${value?.coordinates}");
        //   });
        //
        //   FocusScope.of(context).unfocus();
        //   loadingDialog(
        //       context: context,
        //       future: location.getSearchedLocation(
        //         searchAddress: "${place.description}",
        //         context: context,
        //         updateLocation: true,
        //       )).then((value) {
        //     Navigator.pushNamed(context, Routs.changeMapLocation,
        //         arguments: ChangeMapLocation(
        //           latitude: locationController.latitude,
        //           longitude: locationController.longitude,
        //           isDestination: true,
        //         ));
        //     // .then((value) {
        //     // setState(() {});
        //     // this.setState(() {});
        //     // })
        //   });
        // }

        return SizedBox(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingText(text: "Add Location", fontSize: 16, context: context, color: Colors.black),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 18),
                child: InkWell(
                  onTap: () async {
                    if (latitude != null) {
                      context.pushNamed(Routs.changeMapLocation,
                          extra: ChangeMapLocation(
                            latitude: latitude,
                            longitude: longitude,
                            radius: defaultRadius,
                          ));
                    } else {
                      loadingDialog(
                        context: context,
                        future: location.determinePosition(context: context),
                      ).then((value) {
                        Position? position = value;
                        if (position != null) {
                          context.pushNamed(Routs.changeMapLocation,
                              extra:
                                  ChangeMapLocation(latitude: latitude, longitude: longitude, radius: defaultRadius));
                        } else {
                          debugPrint("Please Enable Location");
                        }
                      });
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.location_searching_sharp,
                          color: secondaryColor,
                          size: 18,
                        ),
                      ),
                      Text(
                        "Pick Location",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (locationController.showPlacesList == true)
                    SearchLocationCards(
                      radius: defaultRadius,
                      padding: EdgeInsets.zero,
                      onSearchChanged: (val) {
                        context.read<LocationController>().setShowPlacesList(data: true);
                        setState(() {});
                      },
                      onLocationSelected: (placesDetailModel) async {
                        debugPrint("Search Location ON Change Call ${placesDetailModel?.result}");
                        double? selectedLatitude = placesDetailModel?.result?.geometry?.location?.lat;
                        double? selectedLongitude = placesDetailModel?.result?.geometry?.location?.lng;
                        debugPrint(
                            "Selected Delivery Zone selectedLongitude $selectedLatitude & selectedLongitude $selectedLongitude");
                        context.pushNamed(Routs.changeMapLocation,
                            extra: ChangeMapLocation(
                              latitude: selectedLatitude,
                              longitude: selectedLongitude,
                              radius: defaultRadius,
                            ));
                      },
                    )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200, width: 0.7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    if (locationController.showPlacesList == false)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8, bottom: 4),
                            child: Row(
                              children: [
                                const Icon((Icons.location_on_outlined), size: 18, color: Colors.black),
                                headingText(
                                    context: context,
                                    text: data?.address ?? "${location.address?.locality}",
                                    padding: const EdgeInsets.only(right: 8)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 16, bottom: 8),
                            child: Text(
                              data?.address ?? "${location.address?.addressLine}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16, top: 12),
                      child: Row(
                        children: [
                          Tooltip(
                            message: "Distance at which you'll be available to train from the Location Selected",
                            triggerMode: TooltipTriggerMode.tap,
                            margin: const EdgeInsets.all(16),
                            child: Icon(Icons.info, color: Colors.grey.shade500, size: 14),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "$defaultRadius KM",
                            style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.white,
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                          ),
                          child: Slider(
                            value: defaultRadius?.toDouble() ?? minDistance,
                            min: minDistance,
                            max: maxDistance,
                            divisions: 9,
                            activeColor: primaryColor,
                            inactiveColor: primaryColor.withOpacity(0.6),
                            onChanged: (double newValue) {
                              setState(() {
                                defaultRadius = newValue;
                              });
                            },
                          ),
                        ),
                        Positioned(
                          left: 24,
                          bottom: 0,
                          child: Text(
                            "Near By",
                            style: sliderTextStyle(),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Text(
                            "Medium",
                            style: sliderTextStyle(),
                          ),
                        ),
                        Positioned(
                          right: 24,
                          bottom: 0,
                          child: Text(
                            "Far Away",
                            style: sliderTextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: index != null ? "Update" : "Save",
                fontSize: 16,
                height: 45,
                mainAxisAlignment: MainAxisAlignment.center,
                margin: const EdgeInsets.only(top: 22, bottom: 22, left: 16, right: 16),
                onPressed: () {
                  debugPrint("Saved");
                  if (latitude != null && longitude != null) {
                    if (index != null) {
                      deliveryZonesData?[index] = DeliveryZonesData(
                        address: location.address?.addressLine,
                        kmRange: defaultRadius,
                        latitude: "$latitude",
                        longitude: "$longitude",
                      );
                    } else {
                      deliveryZonesData?.add(
                        DeliveryZonesData(
                          address: location.address?.addressLine,
                          kmRange: defaultRadius,
                          latitude: "$latitude",
                          longitude: "$longitude",
                        ),
                      );
                    }

                    setState(() {});
                    this.setState(() {});
                    context.read<LocationController>().setShowPlacesList(data: true);
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Future nextSetup() async {
    if (deliveryZonesData.haveData) {
      context.read<PartnerController>().addDeliveryZone(
            context: context,
            route: route,
            editMode: editMode,
            deleteIds: deleteIds,
            deliveryZonesData: deliveryZonesData,
          );
    } else {
      showSnackBar(
          context: context,
          text: "Add At-least 1 one Location",
          color: Colors.red,
          textColor: Colors.white,
          icon: Icons.error_outline);
    }
  }
}
