import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/utils/widgets/custom_bottom_sheet.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:geocoder/geocoder.dart' as geocoder;
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../controllers/location/location_controller.dart';
import '../../core/constant/colors.dart';
import '../../models/partner/setup/delivery_zones_model.dart';
import '../../utils/widgets/widgets.dart';
import 'add_order_address.dart';

class OderAddressPicker extends StatefulWidget {
  const OderAddressPicker({
    Key? key,
    this.latitude,
    this.longitude,
    this.partnerId,
  }) : super(key: key);

  final double? latitude;
  final double? longitude;
  final num? partnerId;

  @override
  OderAddressPickerState createState() => OderAddressPickerState();
}

class OderAddressPickerState extends State<OderAddressPicker> {
  bool updateUserLocation = false;
  bool tempLocation = true;

  late num? partnerId = widget.partnerId;

  late double? latitude = widget.latitude;
  late double? longitude = widget.longitude;
  Address? address;
  bool showAddressPath = false;
  bool updatingLocation = false;

  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LocationController location = Provider.of<LocationController>(context, listen: false);
      latitude = double.parse("${widget.latitude ?? location.latitude ?? 0}");
      longitude = double.parse("${widget.longitude ?? location.longitude ?? 0}");

      setState(() {});

      debugPrint("widget.latitude ${widget.latitude} & widget.longitude $widget.longitude");

      if (latitude != null) {
        debugPrint("Animating to latitude $latitude & longitude $longitude");

        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitude!, longitude!),
              zoom: 14,
            ),
          ));
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationController location = Provider.of<LocationController>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                mapToolbarEnabled: true,
                padding: const EdgeInsets.only(bottom: 120, top: 36),
                onCameraMoveStarted: () {
                  if (showAddressPath == true) {
                    setState(() {
                      showAddressPath = false;
                    });
                  }
                },
                onCameraMove: (loc) async {
                  setState(() {
                    latitude = loc.target.latitude;
                    longitude = loc.target.longitude;
                  });
                  debugPrint("latitude $latitude");
                  debugPrint("latitude $latitude");
                  debugPrint("Camera Moving");
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    latitude ?? location.latitude!,
                    longitude ?? location.longitude!,
                  ),
                  zoom: 13,
                ),
                compassEnabled: true,
                markers: Set<Marker>.of(location.markers.values),
                onMapCreated: (GoogleMapController controller) async {
                  mapController = controller;
                  setState(() {});
                },
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.location_pin,
                  color: primaryColor,
                  size: 48,
                  shadows: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.7, 0),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0, 0.7),
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                          child: backButton(icon: Icons.arrow_back_ios_new, context: context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomSheet: Container(
        width: size.width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade50),
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showAddressPath)
              Column(
                children: [
                  Text(
                    (tempLocation == true
                            ? location.tempAddress?.addressLine
                            : location.address?.addressLine) ??
                        "Select Location from Map",
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  updatingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CupertinoActivityIndicator(),
                        )
                      : CustomButton(
                          height: 45,
                          width: size.width * 0.8,
                          margin: const EdgeInsets.only(top: 16, bottom: 16),
                          text: updateUserLocation ? "Update Location" : "Add Location",
                          mainAxisAlignment: MainAxisAlignment.center,
                          onPressed: () {
                            updatePickerLocation(location: location);
                            if (address != null) {
                              CustomBottomSheet.show(
                                context: context,
                                title: "Add a New Address",
                                body: ManageOrderAddress(
                                  latitude: latitude,
                                  longitude: longitude,
                                  address: address,
                                ),
                              );
                            }
                          },
                        ),
                ],
              )
            else
              Column(
                children: [
                  CustomButton(
                    height: 45,
                    width: size.width * 0.8,
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    text: "Get Address",
                    mainAxisAlignment: MainAxisAlignment.center,
                    onPressed: () {
                      loadingDialog(
                        context: context,
                        future: updateLocation(latitude: latitude, longitude: longitude),
                      );
                    },
                  ),
                ],
              ),
            if (!showAddressPath && latitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$latitude:$longitude",
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future updateLatLong({required double latitude, required double longitude}) async {
    LocationController location = Provider.of<LocationController>(context, listen: false);
    location.setLatLong(
        latitude: latitude,
        longitude: longitude,
        context: context,
        updateLocation: true,
        tempLocation: tempLocation);
    debugPrint("latitude is $latitude");
  }

  Future updateLocation({
    required double? latitude,
    required double? longitude,
  }) async {
    LocationController location = Provider.of<LocationController>(context, listen: false);

    debugPrint("latitude is $latitude");

    if (latitude != null && longitude != null) {
      location.setLatLong(
          latitude: latitude,
          longitude: longitude,
          context: context,
          updateLocation: updateUserLocation,
          tempLocation: tempLocation);
      List<geocoder.Address> addressList =
          await geocoder.Geocoder.local.findAddressesFromCoordinates(Coordinates(latitude, longitude));
      address = addressList.first;
      debugPrint("Address.first ${address?.toMap().toString()}");
      if (address != null) {
        location.setAddress(address: address!, tempLocation: tempLocation);
        setState(() {
          showAddressPath = true;
        });
      }
    }
  }

  void updatePickerLocation({required LocationController location}) {
    context.read<LocationController>().setShowPlacesList(data: false);
    updatingLocation = false;
    setState(() {});
  }
}
