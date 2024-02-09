import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:geocoder/geocoder.dart' as geocoder;
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../controllers/location/location_controller.dart';
import '../../core/constant/colors.dart';
import '../../utils/widgets/widgets.dart';

class ChangeMapLocation extends StatefulWidget {
  const ChangeMapLocation({
    Key? key,
    this.latitude,
    this.longitude,
    this.updateLocation,
    this.radius,
    this.tempLocation,
  }) : super(key: key);

  final double? latitude;
  final double? longitude;
  final num? radius;
  final bool? updateLocation;
  final bool? tempLocation;

  @override
  ChangeMapLocationState createState() => ChangeMapLocationState();
}

class ChangeMapLocationState extends State<ChangeMapLocation> {
  Completer<GoogleMapController> mapController = Completer();
  late bool updateUserLocation = widget.updateLocation ?? false;
  late bool tempLocation = widget.tempLocation ?? false;

  double? latitude;
  double? longitude;
  late num? radius = widget.radius;
  bool showAddressPath = false;
  bool updatingLocation = false;

  Set<Circle>? circles;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LocationController location = Provider.of<LocationController>(context, listen: false);

      latitude = widget.latitude ?? location.latitude ?? location.defaultLatitude;
      longitude = widget.longitude ?? location.longitude ?? location.defaultLongitude;
      setState(() {});

      debugPrint("widget.latitude ${widget.latitude} & widget.longitude $widget.longitude");
      debugPrint("latitude $latitude & longitude $longitude");
      if (latitude != null && longitude != null) {
        circles = {
          Circle(
            circleId: const CircleId("radarCircle"),
            center: LatLng(latitude!, longitude!),
            radius: (radius ?? 1) * 1000,
            strokeColor: primaryColor,
            strokeWidth: 1,
            fillColor: primaryColor.withOpacity(0.2),
          )
        };
        setState(() {});
        location.animateTo(
            context: context,
            cameraPosition: CameraPosition(
              target: LatLng(latitude!, longitude!),
              zoom: 18,
            ));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationController location = Provider.of<LocationController>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: (latitude != null && longitude != null)
          ? Stack(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      mapToolbarEnabled: true,
                      circles: circles ??
                          {
                            Circle(
                              circleId: const CircleId("radarCircle"),
                              center: LatLng(latitude!, longitude!),
                              radius: (radius ?? 1) * 1000,
                              strokeColor: primaryColor,
                              strokeWidth: 1,
                              fillColor: primaryColor.withOpacity(0.2),
                            )
                          },
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
                        LocationController location = Provider.of<LocationController>(context, listen: false);

                        location.setMapController(controller);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 120, top: 36),
                      child: Icon(
                        Icons.location_pin,
                        color: primaryColor,
                        size: 36,
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
            )
          : const Center(
              child: Column(
                children: [Text("data")],
              ),
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
                    location.address?.addressLine ?? "Select Location from Map",
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
                          text: updateUserLocation ? "Update" : "Pick Location",
                          mainAxisAlignment: MainAxisAlignment.center,
                          onPressed: updatingLocation
                              ? () {
                                  context.read<LocationController>().setShowPlacesList(data: false);
                                  updatingLocation = true;
                                  setState(() {});
                                  Navigator.pop(context);
                                  updatingLocation = false;
                                  setState(() {});
                                }
                              : () {
                                  updatePickerLocation(location: location);
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
                        future: updateLocation(
                          latitude: latitude!,
                          longitude: longitude!,
                        ),
                        message: "Fetching Address",
                        context: context,
                      ).whenComplete(() {
                        setState(() {
                          showAddressPath = true;
                        });
                      });
                    },
                  ),
                ],
              ),
            if (!showAddressPath)
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
    required double latitude,
    required double longitude,
  }) async {
    LocationController location = Provider.of<LocationController>(context, listen: false);
    debugPrint("latitude is $latitude");

    location.setLatLong(
        latitude: latitude,
        longitude: longitude,
        context: context,
        updateLocation: updateUserLocation,
        tempLocation: tempLocation);
    List<geocoder.Address> address =
        await geocoder.Geocoder.local.findAddressesFromCoordinates(Coordinates(latitude, longitude));

    debugPrint("Address.first ${address.first.toMap().toString()}");
    location.setAddress(address: address.first, tempLocation: tempLocation);
  }

  void updatePickerLocation({required LocationController location}) {
    context.read<LocationController>().setShowPlacesList(data: false);
    updatingLocation = false;
    setState(() {});
    Navigator.pop(context);
  }
}
