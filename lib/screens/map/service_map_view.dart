import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaas/controllers/services_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controllers/location/location_controller.dart';
import '../../core/config/app_images.dart';
import '../../core/constant/colors.dart';
import '../../core/enums/enums.dart';
import '../../core/services/database/local_database.dart';
import '../../models/dashboard/filters_model.dart';
import '../../models/dashboard/service/service_provider_detail.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/data_widget_builder.dart';
import '../../utils/widgets/image_view.dart';
import '../services/service_provider_detail.dart';
import '../services/utils/map_services_card.dart';

class ServiceMapViewHome extends StatefulWidget {
  const ServiceMapViewHome({
    super.key,
    this.latitude,
    this.longitude,
    this.updateLocation,
    required this.categoryId,
    required this.type,
    this.allOrderTypes,
    this.subcategoryId,
    this.sortBy,
    this.selectedFilterIds,
    this.filterOptions,
    this.otherFilterBy,
    this.bannerId,
    this.partnerIds,
  });

  final double? latitude;
  final double? longitude;
  final bool? updateLocation;
  final ServiceType? type;
  final AllOrderTypes? allOrderTypes;
  final num? categoryId;
  final num? subcategoryId;
  final String? sortBy;
  final List<num?>? selectedFilterIds;
  final List<FilterOptions?>? filterOptions;
  final List<String>? otherFilterBy;
  final num? bannerId;
  final String? partnerIds;

  @override
  _ServiceMapViewHomeState createState() => _ServiceMapViewHomeState();
}

class _ServiceMapViewHomeState extends State<ServiceMapViewHome> {
  Completer<GoogleMapController> mapController = Completer();
  late bool updateUserLocation = widget.updateLocation ?? false;
  late double? latitude = widget.latitude;
  late double? longitude = widget.longitude;
  bool showAddressPath = false;
  bool updatingLocation = false;

  late num? radius = 10;
  late Set<Circle> circles = {
    Circle(
      circleId: const CircleId("radarCircle"),
      center: LatLng(latitude!, longitude!),
      radius: (radius ?? 1) * 1000,
      strokeColor: primaryColor,
      strokeWidth: 1,
      fillColor: primaryColor.withOpacity(0.2),
    )
  };

  late CameraPosition initialCameraPositionIs = CameraPosition(
    target: LatLng(latitude!, longitude!),
    tilt: 80,
    bearing: 30,
    zoom: 13,
  );

  late ServiceType type = widget.type ?? ServiceType.freshProduce;
  bool isAuthenticated = LocalDatabase().accessToken != null;
  TextEditingController searchCtrl = TextEditingController();
  List<ServiceProviderData>? mapServiceProvidersData;

  animateToLocation({
    required ServiceProviderData? data,
  }) {
    LocationController controller = Provider.of<LocationController>(context, listen: false);
    debugPrint("Animating to ");

    double latitude = double.parse("${data?.latitude ?? 0}");
    double longitude = double.parse("${data?.longitude ?? 0}");
    debugPrint("Service Latitude => $latitude");
    debugPrint("Service Longitude => $longitude");
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14,
    );

    if (controller.mapController != null) {
      controller.mapController?.showMarkerInfoWindow(MarkerId("$latitude$longitude"));
    }

    controller.setServiceProviderMarkers(
      lat: latitude,
      long: longitude,
      id: data?.id,
      title: data?.name,
      snippet: data?.address,
      imageUrl: data?.profilePhoto,
      context: context,
    );

    controller.animateTo(context: context, cameraPosition: cameraPosition);
  }

  fetchNearbyMapProducers() {
    ServicesController servicesController = Provider.of<ServicesController>(context, listen: false);
    servicesController.fetchMapServiceProducers(
      context: context,
      type: type,
      searchKey: searchCtrl.text,
      categoryId: widget.categoryId,
      subcategoryId: widget.subcategoryId,
      bannerId: widget.bannerId,
      partnerIds: widget.partnerIds,
      sortBy: widget.sortBy,
      selectedFilterIds: widget.selectedFilterIds?.toList(),
      filterOptions: widget.filterOptions,
      otherFilterBy: widget.otherFilterBy,
      allOrderTypes: widget.allOrderTypes,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LocationController location = Provider.of<LocationController>(context, listen: false);
      location.markers.clear();
      latitude = location.latitude;
      longitude = location.longitude;

      if (latitude != null) {
        location.setMarkers(
          lat: latitude!,
          long: longitude!,
          title: "Your Location",
        );
      }
      fetchNearbyMapProducers();
      location.checkLocationAccess(context: context);
    });
  }

  bool showOptions = true;

  @override
  Widget build(BuildContext context) {
    LocationController location = Provider.of<LocationController>(context);
    latitude = location.latitude;
    longitude = location.longitude;
    ServicesController controller = Provider.of<ServicesController>(context);
    mapServiceProvidersData = controller.mapServiceProvidersData;
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              // height: size.height * (mapServiceProvidersData.haveData ? 0.52 : 1),
              child: GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                mapToolbarEnabled: true,
                polylines: location.polyline,
                circles: circles,
                padding: const EdgeInsets.only(top: 48, bottom: 72, left: 36, right: 36),
                zoomControlsEnabled: false,
                onTap: (loc) {
                  showOptions = !showOptions;
                  setState(() {});
                },
                onCameraMoveStarted: () {
                  if (showAddressPath == true) {
                    setState(() {
                      showAddressPath = false;
                    });
                  }
                },
                onCameraMove: (loc) async {
                  if (mounted) {
                    setState(() {
                      latitude = loc.target.latitude;
                      longitude = loc.target.longitude;
                    });
                  }

                  debugPrint("latitude $latitude");
                  debugPrint("longitude $longitude");
                  debugPrint("Camera Moving");
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    location.latitude!,
                    location.longitude!,
                  ),
                  zoom: 13,
                ),
                markers: Set<Marker>.of(location.markers.values),
                onMapCreated: (GoogleMapController controller) async {
                  LocationController location = Provider.of<LocationController>(context, listen: false);
                  location.setMapController(controller);
                },
              ),
            ),

            // if (showOptions)
            Positioned(
              top: 36,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  backButton(context: context),
                  Flexible(
                    child: CustomTextField(
                      controller: searchCtrl,
                      height: 50,
                      prefixIcon: const ImageView(
                        height: 24,
                        width: 24,
                        assetImage: AppImages.search,
                      ),
                      fillColor: Colors.white,
                      hintText: "Search for Location",
                      onChanged: (val) async {
                        if (controller.loadingMapServiceProviders == false) {
                          await fetchNearbyMapProducers();
                        }
                      },
                      borderColor: primaryGrey,
                      margin: const EdgeInsets.only(left: 12, right: 12),
                    ),
                  ),
                ],
              ),
            ),

            if (mapServiceProvidersData.haveData)
              DraggableScrollableSheet(
                builder: (context, scrollController) {
                  return SafeArea(
                    child: Container(
                      width: size.width,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DataWidgetBuilder(
                        isLoading: controller.loadingMapServiceProviders,
                        haveData: mapServiceProvidersData.haveData,
                        heightFactor: 0.5,
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: mapServiceProvidersData?.length ?? 0,
                          padding: EdgeInsets.zero,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          itemBuilder: (BuildContext context, int index) {
                            ServiceProviderData? data = mapServiceProvidersData?.elementAt(index);

                            return VisibilityDetector(
                              key: const ObjectKey("services"),
                              onVisibilityChanged: (visibility) {
                                var visiblePercentage = visibility.visibleFraction * 100;
                                if (visiblePercentage >= 60 && mounted) {
                                  // animateToLocation(data: data);
                                  // debugPrint(
                                  //     "Station Card Visible Fraction ${visibility.visibleFraction} of ${data?.name}");
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: MapServiceProviderCard(
                                  width: size.width,
                                  serviceProvider: data,
                                  borderRadius: 16,
                                  margin: EdgeInsets.zero,
                                  onTap: () {
                                    animateToLocation(data: data);
                                    context.pushNamed(Routs.serviceProviderDetail,
                                        extra: ServiceProviderDetailScreen(id: data?.id));
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              )
          ],
        ),
        // bottomSheet: mapServiceProvidersData.haveData
        //     ? DraggableScrollableSheet(
        //         initialChildSize: 0.2,
        //         builder: (context, scrollController) {
        //           return Container(
        //             height: size.height * 0.5,
        //             width: size.width,
        //             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               border: Border.all(color: primaryColor),
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             child: DataWidgetBuilder(
        //               isLoading: controller.loadingMapServiceProviders,
        //               haveData: mapServiceProvidersData.haveData,
        //               heightFactor: 0.5,
        //               child: ListView.builder(
        //                 controller: scrollController,
        //                 shrinkWrap: true,
        //                 itemCount: mapServiceProvidersData?.length ?? 0,
        //                 padding: EdgeInsets.zero,
        //                 itemBuilder: (BuildContext context, int index) {
        //                   ServiceProviderData? data = mapServiceProvidersData?.elementAt(index);
        //
        //                   return VisibilityDetector(
        //                     key: const ObjectKey("services"),
        //                     onVisibilityChanged: (visibility) {
        //                       var visiblePercentage = visibility.visibleFraction * 100;
        //                       if (visiblePercentage >= 60 && mounted) {
        //                         animateToLocation(data: data);
        //                         debugPrint(
        //                             "Station Card Visible Fraction ${visibility.visibleFraction} of ${data?.name}");
        //                       }
        //                     },
        //                     child: Container(
        //                       margin: const EdgeInsets.only(top: 12),
        //                       decoration: BoxDecoration(
        //                         color: Colors.white,
        //                         borderRadius: BorderRadius.circular(8),
        //                       ),
        //                       child: MapServiceProviderCard(
        //                         width: size.width,
        //                         serviceProvider: data,
        //                         borderRadius: 16,
        //                         margin: EdgeInsets.zero,
        //                         onTap: () {
        //                           animateToLocation(data: data);
        //                           context.pushNamed(Routs.serviceProviderDetail,
        //                               extra: ServiceProviderDetailScreen(id: data?.id));
        //                         },
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               ),
        //             ),
        //           );
        //         },
        //       )
        //     : null,
      ),
    );
  }

  Future updateLatLong({required double latitude, required double longitude}) async {
    LocationController location = Provider.of<LocationController>(context, listen: false);
    location.setLatLong(latitude: latitude, longitude: longitude, context: context);
    debugPrint("latitude is $latitude");
  }

  Future updateLocation({required double latitude, required double longitude}) async {
    LocationController location = Provider.of<LocationController>(context, listen: false);
    debugPrint("latitude is $latitude");

    List<Placemark> placeMarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark placeMark = placeMarks.first;
    location.setLatLong(latitude: latitude, longitude: longitude, context: context);
    location.markers.clear();

    location.setMarkers(
      lat: latitude,
      long: longitude,
    );
    // location.setPlaceMark(placeMark: placeMark);
  }

// Future onMapSearch({required Place place}) async {
//   debugPrint("Searching Map Location Are");
//
//   FocusScope.of(context).unfocus();
//
//   await FetchLocation()
//       .getSearchedLocation(
//     searchAddress: "${place.description}",
//     context: context,
//     updateLocation: true,
//   )
//       .then((value) {
//     List<Location> location = value;
//     debugPrint("Got Place Location is  ${location.first}");
//     debugPrint("Got Place latitude ${location.first.latitude}");
//     debugPrint("Got Place longitude ${location.first.longitude}");
//     Provider.of<RestaurantsController>(context, listen: false).fetchMapRestaurants(
//       isRefresh: true,
//       context: context,
//       latitude: location.first.latitude,
//       longitude: location.first.longitude,
//     );
//   });
// }
}
