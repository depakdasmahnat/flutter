// import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mrwebbeast/core/config/api_config.dart';
// import 'package:mrwebbeast/core/services/api/api_service.dart';
// import 'package:mrwebbeast/core/services/database/local_database.dart';
//
// import '../../../core/config/app_config.dart';
// import '../../../utils/widgets/custom_bottom_sheet.dart';
// import '../../../utils/widgets/custom_button.dart';
// import '../../../utils/widgets/custom_text_field.dart';
// import '../../../utils/widgets/widgets.dart';
// import 'location_model.dart';
// import 'places_detail_model.dart';
//
// class LocationController with ChangeNotifier {
//   Position? _position;
//
//   Position? get getPosition => _position;
//
//   double? defaultLatitude = 28.633367546680592;
//   double? defaultLongitude = 77.20818763910721;
//
//   double? previousLatitude() {
//     return LocalDatabase().latitude ?? defaultLatitude;
//   }
//
//   double? previousLongitude() {
//     return LocalDatabase().longitude ?? defaultLongitude;
//   }
//
//   late double? _latitude = previousLatitude();
//   late double? _longitude = previousLongitude();
//
//   double? get latitude => _latitude;
//
//   double? get longitude => _longitude;
//
//   Future setLatLong({
//     required BuildContext context,
//     double? latitude,
//     double? longitude,
//     bool updateDestination = false,
//     bool updateLocation = false,
//   }) async {
//     if (latitude != null && longitude != null) {
//       _latitude = latitude;
//       _longitude = longitude;
//     }
//
//     notifyListeners();
//
//     if (updateLocation) {
//       try {
//         // updateUserLocation(context: context);
//       } catch (error) {
//         debugPrint('Updating User Location Failed...');
//         debugPrint('Error is $error');
//       }
//     }
//
//     notifyListeners();
//   }
//
//   late Set<Polyline> polyline = {
//     Polyline(
//       polylineId: const PolylineId('polylineId'),
//       points: [
//         if (_latitude != null) LatLng(_latitude!, _longitude!),
//       ],
//     ),
//   };
//
//   setPolyline({required List<LatLng> polylinePoints}) {
//     polyline = {
//       Polyline(
//         polylineId: const PolylineId('polylineId'),
//         width: 2,
//         points: polylinePoints,
//       ),
//     };
//     notifyListeners();
//   }
//
//   Address? _address;
//
//   Address? get address => _address;
//
//   setAddress({required Address address}) {
//     _address = address;
//     notifyListeners();
//   }
//
//   String? getShortAddress() {
//     String shortAddress = 'Unknown Location';
//     if (address != null) {
//       shortAddress = '${address?.subLocality} ,${address?.locality}';
//     }
//     return shortAddress;
//   }
//
//   GoogleMapController? _mapController;
//
//   GoogleMapController? get mapController => _mapController;
//
//   Future setMapController(GoogleMapController controller) async {
//     _mapController = controller;
//     notifyListeners();
//   }
//
//   bool _haveLocationAccess = false;
//
//   bool get haveLocationAccess => _haveLocationAccess;
//
//   /// Check Location is Enabled or Not...
//
//   Future<bool> checkPermission({required BuildContext context}) async {
//     await Geolocator.isLocationServiceEnabled().then((value) {
//       _haveLocationAccess = value;
//       notifyListeners();
//       if (!_haveLocationAccess) {
//         showLocationPopup(context: context).then((value) {
//           closeLocationPopupStatus();
//         });
//       }
//     });
//
//     return _haveLocationAccess;
//   }
//
//   Future<bool> openLocationSettings({required BuildContext context}) async {
//     showSnackBar(context: context, text: 'Please enable Your Location Service');
//     return await Geolocator.openLocationSettings().then((value) => value);
//   }
//
//   Future<Position?> determinePosition({
//     required BuildContext context,
//     bool updateLocation = false,
//     bool updateDestination = false,
//   }) async {
//     debugPrint('Fetching Location...');
//     Position? position;
//
//     await checkPermission(context: context).then((value) async {
//       bool haveLocation = value;
//
//       await requestPermission(context: context);
//       if (haveLocation == true) {
//         await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) async {
//           position = value;
//           if (position != null) {
//             await setLatLong(
//               latitude: position?.latitude,
//               longitude: position?.longitude,
//               context: context,
//               updateDestination: updateDestination,
//               updateLocation: updateLocation,
//             );
//             List<Address> address = await Geocoder.local
//                 .findAddressesFromCoordinates(Coordinates(position!.latitude, position!.longitude));
//             debugPrint('Address.first ${address.first}');
//             setAddress(address: address.first);
//
//             List<Placemark>? placeMarks =
//                 await placemarkFromCoordinates(position!.latitude, position!.longitude);
//             debugPrint('$placeMarks');
//           }
//         });
//       } else {
//         debugPrint('Location Access Denied');
//         if (context.mounted) {
//           requestPermission(context: context);
//         }
//       }
//     });
//
//     return position;
//   }
//
//   Future<bool> requestPermission({required BuildContext context}) async {
//     LocationPermission permission;
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     } else if (permission == LocationPermission.deniedForever) {}
//
//     return _haveLocationAccess;
//   }
//
//   Future<List<Location>?> getSearchedLocation({
//     required String searchAddress,
//     required BuildContext context,
//     bool updateLocation = false,
//   }) async {
//     List<Location>? addressLocations;
//     await locationFromAddress(searchAddress).then((value) async {
//       addressLocations = value;
//       if (addressLocations != null) {
//         setLatLong(
//           latitude: addressLocations?.first.latitude,
//           longitude: addressLocations?.first.longitude,
//           context: context,
//           updateLocation: updateLocation,
//         );
//         List<Address> address = await Geocoder.local.findAddressesFromCoordinates(
//             Coordinates(addressLocations!.first.latitude, addressLocations!.first.longitude));
//         debugPrint('Address.first ${address.first.addressLine}');
//         setAddress(address: address.first);
//         // List<Placemark>? placeMarks =
//         //     await placemarkFromCoordinates(addressLocations.first.latitude, addressLocations.first.longitude);
//         // Placemark placeMark = placeMarks.first;
//         // setPlaceMark(placeMark: placeMark);
//         if (mapController != null) {
//           locateCameraPosition();
//           setNewCameraPosition(
//             CameraPosition(
//                 target: LatLng(addressLocations!.first.latitude, addressLocations!.first.longitude),
//                 zoom: 18),
//           );
//           markers.clear();
//           setMarkers(
//             lat: addressLocations!.first.latitude,
//             long: addressLocations!.first.longitude,
//           );
//         }
//       }
//     });
//
//     return addressLocations;
//   }
//
//   Future animateTo({
//     required BuildContext context,
//     CameraPosition? cameraPosition,
//   }) async {
//     debugPrint('Going To Location');
//     if (cameraPosition == null) {
//       debugPrint('Getting Current Location');
//       await determinePosition(context: context, updateLocation: true);
//     }
//
//     late CameraPosition myCameraPosition = cameraPosition ??
//         CameraPosition(
//           target: LatLng(_latitude!, _longitude!),
//           zoom: 15,
//         );
//     if (_mapController != null) {
//       _mapController?.animateCamera(CameraUpdate.newCameraPosition(myCameraPosition));
//     }
//     notifyListeners();
//   }
//
//   late CameraPosition? _newCameraPosition = CameraPosition(target: LatLng(_latitude!, _longitude!), zoom: 15);
//
//   setNewCameraPosition(CameraPosition newLocation) {
//     _newCameraPosition = newLocation;
//     notifyListeners();
//   }
//
//   Future locateCameraPosition() async {
//     if (_mapController != null && _newCameraPosition != null) {
//       _mapController?.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition!));
//     }
//   }
//
//   Map<MarkerId, Marker> markers = {};
//
//   setMarkers({
//     required double lat,
//     required double long,
//     String? title,
//     String? snippet,
//   }) async {
//     MarkerId markerId = MarkerId(lat.toString() + long.toString());
//     // BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
//     //   const ImageConfiguration(size: Size(24, 24)),
//     //   userPointerIcon,
//     // );
//     Marker marker = Marker(
//       markerId: markerId,
//       icon: BitmapDescriptor.defaultMarker,
//       position: LatLng(lat, long),
//       infoWindow: InfoWindow(
//         title: title,
//         snippet: snippet,
//       ),
//     );
//     markers[markerId] = marker;
//     notifyListeners();
//   }
//
//   setRestaurantMarkers({
//     required double lat,
//     required double long,
//     required String? title,
//     required String? snippet,
//     required int? restaurantId,
//     required BuildContext? context,
//   }) async {
//     MarkerId markerId = MarkerId(lat.toString() + long.toString());
//
//     // BitmapDescriptor markerIcon =
//     //     await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(24, 24)), restaurantPointerIcon);
//     Marker marker = Marker(
//       markerId: markerId,
//       icon: BitmapDescriptor.defaultMarker,
//       position: LatLng(lat, long),
//       infoWindow: InfoWindow(
//         title: title,
//         snippet: snippet,
//         onTap: () {},
//       ),
//     );
//     markers[markerId] = marker;
//     notifyListeners();
//   }
//
//   /// 1) Search Location  API...
//
//   TextEditingController searchLocationController = TextEditingController();
//   bool? loadingSearchLocations = true;
//   LocationModel? locationModel;
//
//   Future<LocationModel?> searchLocation({
//     required BuildContext context,
//     required String? query,
//     int? radius,
//   }) async {
//     debugPrint('Fetching LocationModel...');
//     loadingSearchLocations = true;
//
//     notifyListeners();
//     String? finalQuery = query?.isNotEmpty == true ? query : _address?.locality;
//     Map<String, String> body = {
//       'input': finalQuery ?? '',
//       'location': '$_latitude,$_longitude',
//       'radius': '${radius ?? 1000}',
//       'key': AppConfig.mapAddressesApiKey,
//     };
//
//     var response = await ApiService().get(
//       baseUrl: ApiConfig.mapsBaseUrl,
//       endPoint: '/place/autocomplete/json',
//       queryParameters: body,
//     );
//
//     Map<String, dynamic> json = response;
//     LocationModel responseData = LocationModel.fromJson(json);
//     if (responseData.status == 'OK') {
//       locationModel = responseData;
//     } else {}
//     loadingSearchLocations = false;
//     notifyListeners();
//     return locationModel;
//   }
//
//   /// 2) PlacesDetailModel  API...
//
//   bool? loadingPlacesDetailModel = true;
//   PlacesDetailModel? placesDetailModel;
//
//   Future<PlacesDetailModel?> fetchPlacesDetail({
//     required BuildContext context,
//     required String? placeId,
//     GestureTapCallback? onComplete,
//     int? radius,
//   }) async {
//     debugPrint('Fetching PlacesDetailModel...');
//     loadingPlacesDetailModel = true;
//     // locationModel = null;
//
//     notifyListeners();
//
//     Map<String, String> body = {
//       'place_id': placeId ?? '',
//       'key': AppConfig.mapAddressesApiKey,
//     };
//
//     await loadingDialog(
//       context: context,
//       future: ApiService().get(
//         baseUrl: ApiConfig.mapsBaseUrl,
//         endPoint: '/place/details/json',
//         queryParameters: body,
//       ),
//     ).then((response) {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//         PlacesDetailModel responseData = PlacesDetailModel.fromJson(json);
//         if (responseData.status == 'OK') {
//           placesDetailModel = responseData;
//           notifyListeners();
//
//           if (onComplete != null) {
//             onComplete();
//           }
//         } else {}
//       } else {
//         debugPrint('Empty Response');
//       }
//     });
//
//     loadingSearchLocations = false;
//     notifyListeners();
//     return placesDetailModel;
//   }
//
// //   /// 4) Updating User Location to Server...
// //   Future updateUserLocation({
// //     double? latitude,
// //     double? longitude,
// //     required BuildContext context,
// //   }) async {
// //     Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
// //
// //     Map<String, dynamic> body = {
// //       "latitude": "${latitude ?? _latitude}",
// //       "longitude": "${longitude ?? _longitude}",
// //       "address": "${getAddress()}",
// //     };
// //     debugPrint(" /// 4) Updating User Location to Server... Data is $body");
// //     var response = BaseClient().post(
// //       context: context,
// //       api: "update-user-location",
// //       body: body,
// //       headers: headers,
// //     );
// // //Processing API...
// //     response.then((response) {
// //       if (response != null) {
// //         // Map<String, dynamic> json = jsonDecode(response);
// //       }
// //     });
// //   }
//
//   TextEditingController searchCtrl = TextEditingController();
//
//   bool locationPopupActive = false;
//
//   closeLocationPopupStatus() {
//     locationPopupActive = false;
//     debugPrint('Closed Location Popup');
//     notifyListeners();
//   }
//
//   Future showLocationPopup({required BuildContext context}) async {
//     Size size = MediaQuery.of(context).size;
//
//     if (locationPopupActive == false) {
//       locationPopupActive = true;
//       notifyListeners();
//       return CustomBottomSheet.show(
//           context: context,
//           isScrollControlled: true,
//           enableDrag: true,
//           constraints: BoxConstraints(minHeight: size.height * 0.6, maxHeight: size.height * 0.9),
//           physics: const ScrollPhysics(),
//           bottomNavBarAlignment: Alignment.topCenter,
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (!_haveLocationAccess)
//                   Column(
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.only(top: 24, bottom: 8),
//                         child: Row(
//                           children: [
//                             Text(
//                               '${AppConfig.name} does not have location\naccess',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Row(
//                           children: [
//                             Text(
//                               'Location helps us access your near......',
//                               style: TextStyle(
//                                 color: Colors.grey.shade600,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                       CustomButton(
//                         height: 45,
//                         icon: const Icon(
//                           Icons.my_location_rounded,
//                           color: Colors.white,
//                         ),
//                         text: 'Grant location access',
//                         onPressed: () {
//                           openLocationSettings(context: context).then((value) {
//                             _haveLocationAccess = value;
//                             notifyListeners();
//                           });
//                         },
//                         margin: const EdgeInsets.only(top: 36, bottom: 16),
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.only(top: 12, bottom: 12),
//                         child: Divider(color: Colors.grey, height: 1),
//                       ),
//                     ],
//                   )
//                 else
//                   Column(
//                     children: [
//                       CustomButton(
//                         height: 45,
//                         icon: const Icon(
//                           Icons.my_location_rounded,
//                           color: Colors.white,
//                         ),
//                         text: 'Fetch Current location',
//                         onPressed: () {
//                           loadingDialog(
//                             context: context,
//                             future: determinePosition(context: context),
//                           ).then((value) {
//                             if (value != null) {
//                               context.pop();
//                             }
//                           });
//                         },
//                         margin: const EdgeInsets.only(top: 36, bottom: 16),
//                       )
//                     ],
//                   ),
//                 const Text(
//                   'Select your location',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 CustomTextField(
//                   controller: searchCtrl,
//                   hintText: 'Search Location',
//                   onChanged: (val) {
//                     notifyListeners();
//                   },
//                   borderColor: Colors.grey.shade200,
//                   margin: const EdgeInsets.only(top: 16, bottom: 24),
//                 )
//               ],
//             ),
//           ));
//     } else {
//       debugPrint('Location Popup Already Active');
//     }
//   }
// }
