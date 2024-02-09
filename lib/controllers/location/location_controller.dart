import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/screens/dashboard/location_poup_body.dart';
import 'package:gaas/screens/services/service_provider_detail.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../models/location/location_model.dart';
import '../../../models/location/places_detail_model.dart';
import '../../core/config/app_config.dart';
import '../../core/constant/colors.dart';
import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth/authentication.dart';
import '../../route/route_paths.dart';
import '../../screens/home/view_producer.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../../utils/widgets/widgets.dart';

class LocationController with ChangeNotifier {
  List<num> locationRanges = [3, 5, 10];
  num locationRange = 5;

  setLocationRange({num? range}) {
    if (range != null) {
      locationRange = range;
      notifyListeners();
    }
  }

  Position? _position;

  Position? get getPosition => _position;

  double defaultLatitude = 28.633367546680592;
  double defaultLongitude = 77.20818763910721;

  double? previousLatitude() {
    return LocalDatabase().latitude ?? defaultLatitude;
  }

  double? previousLongitude() {
    return LocalDatabase().longitude ?? defaultLongitude;
  }

  late double? _latitude = previousLatitude();
  late double? _longitude = previousLongitude();

  double? get latitude => _latitude;

  double? get longitude => _longitude;
  late double? _tempLatitude = _latitude;
  late double? _tempLongitude = _longitude;

  double? get tempLatitude => _tempLatitude;

  double? get tempLongitude => _tempLongitude;

  Future setLatLong({
    required BuildContext context,
    double? latitude,
    double? longitude,
    Address? address,
    bool updateLocation = false,
    bool tempLocation = false,
  }) async {
    LocalDatabase localDatabase = LocalDatabase();
    if (latitude != null && longitude != null) {
      if (!tempLocation) {
        _latitude = latitude;
        _longitude = longitude;
        localDatabase.setLatLong(_latitude, _longitude);
      } else {
        _tempLatitude = latitude;
        _tempLongitude = longitude;
      }
    }

    if (address != null) {
      if (!tempLocation) {
        _address = address;
        localDatabase.setAddress(_address?.addressLine);
      } else {
        _tempAddress = address;
      }
    }

    notifyListeners();
    if (updateLocation) {
      try {
        if (LocalDatabase().accessToken != null) {
          return updateUserLocation(context: context);
        }
      } catch (error) {
        debugPrint("Updating User Location Failed...");
        debugPrint("Error is $error");
      }
    }

    notifyListeners();
  }

  bool? _showPlacesList = true;

  bool? get showPlacesList => _showPlacesList;

  Future setShowPlacesList({
    required bool data,
  }) async {
    _showPlacesList = data;
    notifyListeners();
  }

  late Set<Polyline> polyline = {
    Polyline(
      polylineId: const PolylineId("polylineId"),
      points: [
        if (_latitude != null) LatLng(_latitude!, _longitude!),
      ],
    ),
  };

  setPolyline({required List<LatLng> polylinePoints}) {
    polyline = {
      Polyline(
        polylineId: const PolylineId("polylineId"),
        color: primaryColor,
        width: 2,
        points: polylinePoints,
      ),
    };
    notifyListeners();
  }

  Address? _address;

  Address? get address => _address;

  Address? _tempAddress;

  Address? get tempAddress => _tempAddress;

  getLocalAddress() {
    LocalDatabase localDatabase = LocalDatabase();
    String? address = localDatabase.address;
    if (address != null) {
      _address = Address(
        addressLine: address,
        coordinates: Coordinates(
            localDatabase.latitude ?? defaultLatitude, localDatabase.longitude ?? defaultLongitude),
      );
      notifyListeners();
    }
  }

  setAddress({
    required Address address,
    bool tempLocation = false,
  }) {
    if (tempLocation == true) {
      _tempAddress = address;
    } else {
      _address = address;
    }
    notifyListeners();
  }

  String? getShortAddress() {
    String shortAddress = "Unknown Location";
    if (address != null) {
      shortAddress = "${address?.subLocality} ,${address?.locality}";
    }
    return shortAddress;
  }

  GoogleMapController? _mapController;

  GoogleMapController? get mapController => _mapController;

  Future setMapController(GoogleMapController controller) async {
    _mapController = controller;
    notifyListeners();
  }

  checkBothLocationPermission({
    required BuildContext context,
    bool? showPopup = true,
  }) async {
    await checkLocationAccess(context: context);
    if (context.mounted) {
      await checkLocationPermission(context: context, showPopup: showPopup);
      if (!_haveLocationAccess || !_haveLocationPermission || _address == null) {
        if (_address == null && showPopup == true && context.mounted) {
          showLocationPopup(context: context).then((value) {
            closeLocationPopupStatus();
          });
        }
      }
    }
  }

  bool _haveLocationAccess = false;

  bool get haveLocationAccess => _haveLocationAccess;

  /// Check Location is Enabled or Not...

  Future<bool> checkLocationAccess({required BuildContext context}) async {
    debugPrint("Checking Location...");
    try {
      await Geolocator.isLocationServiceEnabled().then((value) async {
        _haveLocationAccess = value;
        notifyListeners();
      });
    } catch (e, s) {
      debugPrint("Checking Location Error $e $s & locationPopupActive $locationPopupActive");
      if (locationPopupActive == true) {
        requestLocationPermission(context: context);
      }

      // else {
      //   if (showPopup == true) {
      //     showLocationPopup(context: context);
      //   }
      // }
    }

    debugPrint("_haveLocationAccess $_haveLocationAccess");
    return _haveLocationAccess;
  }

  bool _haveLocationPermission = false;

  bool get haveLocationPermission => _haveLocationPermission;

  Future<bool> checkLocationPermission({required BuildContext context, bool? showPopup = true}) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    debugPrint("Check Location Permission ${permission.name}");

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      _haveLocationPermission = true;
    } else if (permission == LocationPermission.denied) {
      _haveLocationPermission = false;
    } else if (permission == LocationPermission.deniedForever) {
      _haveLocationPermission = false;
    } else {
      _haveLocationPermission = false;
    }
    notifyListeners();

    return _haveLocationAccess;
  }

  Future<bool> requestLocationPermission({required BuildContext context}) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    debugPrint("requestPermission ${permission.name}");

    if (context.mounted) {
      bool hasLocationAccess = await checkLocationAccess(context: context);
      if (!hasLocationAccess) {
        await openLocationSettings(context: context);
      }
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      _haveLocationPermission = true;
    } else if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      _haveLocationPermission = false;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        bool openAppSettings = await Geolocator.openAppSettings();
        _isLocationPopupOpened = true;
        notifyListeners();

        debugPrint("openAppSettings $openAppSettings");
      }
    } else {
      _haveLocationPermission = false;
      permission = await Geolocator.requestPermission();
    }

    debugPrint("New requestPermission ${permission.name}");
    return _haveLocationAccess;
  }

  late bool _isLocationPopupOpened = false;

  bool get isLocationPopupOpened => _isLocationPopupOpened;

  setLocationPopupOpened({required bool isLocationSettingsOpened}) {
    _isLocationPopupOpened = isLocationSettingsOpened;
    notifyListeners();
  }

  Future<bool> openLocationSettings({
    required BuildContext context,
  }) async {
    showSnackBar(context: context, text: "Please enable Your Location Service");
    _isLocationPopupOpened = await Geolocator.openLocationSettings();
    notifyListeners();
    debugPrint("Location Settings Opened :- $_isLocationPopupOpened");
    return _isLocationPopupOpened;
  }

  Future<Position?> determinePosition({
    required BuildContext context,
    bool updateLocation = false,
    bool showPopup = true,
    bool forceRequest = false,
  }) async {
    debugPrint("Fetching Location...");
    _isLocationPopupOpened = false;
    notifyListeners();

    await checkBothLocationPermission(context: context, showPopup: showPopup);

    if (_haveLocationAccess == true && _haveLocationPermission == true) {
      try {
        return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) async {
          _position = value;
          if (_position != null) {
            List<Address> address = await Geocoder.local
                .findAddressesFromCoordinates(Coordinates(_position!.latitude, _position!.longitude));
            Address? firstAddress = address.first;
            debugPrint("Address.first $firstAddress");

            if (context.mounted) {
              await setLatLong(
                latitude: _position?.latitude,
                longitude: _position?.longitude,
                address: firstAddress,
                context: context,
                updateLocation: updateLocation,
              );
              setMarkers(
                lat: _position!.latitude,
                long: _position!.latitude,
                currentLocation: true,
              );
            }
          }
          notifyListeners();
          return _position;
        });
      } catch (e, s) {
        debugPrint("Fetching Location Error $e $s & locationPopupActive $locationPopupActive");
        if (locationPopupActive == true) {
          requestLocationPermission(context: context);
        } else {
          // if (showPopup == true) {
          //   showLocationPopup(context: context);
          // }
        }
      }
    } else {
      debugPrint("Location Access Denied");
      debugPrint("_haveLocationAccess $_haveLocationAccess");
      debugPrint("haveLocationPermission $haveLocationPermission");

      if (context.mounted && forceRequest == true) {
        if (_haveLocationAccess == false) {
          openLocationSettings(context: context);
        } else if (haveLocationPermission == false) {
          LocationPermission permission = await Geolocator.requestPermission();

          if (permission != LocationPermission.always || permission != LocationPermission.whileInUse) {
            Geolocator.openAppSettings();
            if (context.mounted) {
              showSnackBar(context: context, text: "Enable Location Permission");
            }
          }
        }
      }
    }

    notifyListeners();
    return _position;
  }

  Future<List<Location>?> getSearchedLocation({
    required String searchAddress,
    required BuildContext context,
    bool updateLocation = false,
  }) async {
    List<Location>? addressLocations;
    await locationFromAddress(searchAddress).then((value) async {
      addressLocations = value;
      if (addressLocations != null) {
        setLatLong(
          latitude: addressLocations?.first.latitude,
          longitude: addressLocations?.first.longitude,
          context: context,
          updateLocation: updateLocation,
        );
        List<Address> address = await Geocoder.local.findAddressesFromCoordinates(
            Coordinates(addressLocations!.first.latitude, addressLocations!.first.longitude));
        debugPrint("Address.first ${address.first.addressLine}");
        setAddress(address: address.first);
        // List<Placemark>? placeMarks =
        //     await placemarkFromCoordinates(addressLocations.first.latitude, addressLocations.first.longitude);
        // Placemark placeMark = placeMarks.first;
        // setPlaceMark(placeMark: placeMark);
        if (mapController != null) {
          locateCameraPosition();
          setNewCameraPosition(
            CameraPosition(
                target: LatLng(addressLocations!.first.latitude, addressLocations!.first.longitude),
                zoom: 18),
          );
          markers.clear();
          setMarkers(
            lat: addressLocations!.first.latitude,
            long: addressLocations!.first.longitude,
          );
          notifyListeners();
        }
      }
    });

    return addressLocations;
  }

  Future animateTo({
    required BuildContext context,
    CameraPosition? cameraPosition,
  }) async {
    debugPrint("Going To Location ${cameraPosition?.target}");
    if (cameraPosition == null) {
      debugPrint("Getting Current Location");
      await determinePosition(context: context, updateLocation: true);
    }

    late CameraPosition myCameraPosition = cameraPosition ??
        CameraPosition(
          target: LatLng(_latitude!, _longitude!),
          zoom: 14,
        );

    if (_mapController != null) {
      debugPrint("myCameraPosition Location ${myCameraPosition.target}");
      debugPrint("myCameraPosition Location ${_mapController?.mapId}");
      try {
        _mapController?.animateCamera(CameraUpdate.newCameraPosition(myCameraPosition));
      } catch (e, s) {
        debugPrint("Error $e $s");
      }
    }
    notifyListeners();
  }

  late CameraPosition? _newCameraPosition = CameraPosition(target: LatLng(_latitude!, _longitude!), zoom: 15);

  setNewCameraPosition(CameraPosition newLocation) {
    _newCameraPosition = newLocation;
    notifyListeners();
  }

  Future locateCameraPosition() async {
    if (_mapController != null && _newCameraPosition != null) {
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition!));
    }
  }

  Map<MarkerId, Marker> markers = {};

  clearMarkers() {
    markers.clear();
    if (_latitude != null && _longitude != null) {
      setMarkers(lat: _latitude!, long: _longitude!, currentLocation: true, title: "Your Location");
    }

    notifyListeners();
  }

  setMarkers({
    required double lat,
    required double long,
    String? title,
    String? snippet,
    bool? currentLocation,
  }) async {
    MarkerId markerId = currentLocation == true
        ? const MarkerId("currentLocation")
        : MarkerId(lat.toString() + long.toString());
    BitmapDescriptor? markerIcon = currentLocation == true
        ? await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(24, 24)),
            AppImages.currentLocation,
          )
        : null;

    Marker marker = Marker(
      markerId: markerId,
      icon: markerIcon ?? BitmapDescriptor.defaultMarker,
      position: LatLng(lat, long),
      infoWindow: InfoWindow(title: title, snippet: snippet, onTap: () {}),
    );
    markers[markerId] = marker;
    notifyListeners();
  }

  setProducerMarkers({
    required double lat,
    required double long,
    required String? title,
    required String? snippet,
    required String? imageUrl,
    required num? id,
    required BuildContext? context,
  }) async {
    BitmapDescriptor? markerImage;
    MarkerId markerId = MarkerId(lat.toString() + long.toString());

    Uint8List? resizedImageMarker = await ApiService().getMarkerNetworkImage("$imageUrl");
    if (resizedImageMarker != null) {
      markerImage = BitmapDescriptor.fromBytes(resizedImageMarker);
    }

    Marker marker = Marker(
      markerId: markerId,
      icon: markerImage ?? BitmapDescriptor.defaultMarker,
      position: LatLng(lat, long),
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
        onTap: () {
          if (context != null && id != null) {
            context.pushNamed(Routs.viewProducer, extra: ViewProducer(partnerId: "$id"));
          }
        },
      ),
    );
    markers[markerId] = marker;
    notifyListeners();
  }

  setServiceProviderMarkers({
    required double lat,
    required double long,
    required String? title,
    required String? snippet,
    required String? imageUrl,
    required num? id,
    required BuildContext? context,
  }) async {
    BitmapDescriptor? markerImage;
    MarkerId markerId = MarkerId(lat.toString() + long.toString());

    Uint8List? resizedImageMarker = await ApiService().getMarkerNetworkImage("$imageUrl");
    if (resizedImageMarker != null) {
      markerImage = BitmapDescriptor.fromBytes(resizedImageMarker);
    }
    Marker marker = Marker(
      markerId: markerId,
      icon: markerImage ?? BitmapDescriptor.defaultMarker,
      position: LatLng(lat, long),
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
        onTap: () {
          if (context != null && id != null) {
            context.pushNamed(Routs.serviceProviderDetail, extra: ServiceProviderDetailScreen(id: id));
          }
        },
      ),
    );
    markers[markerId] = marker;
    notifyListeners();
  }

  /// 1) Search Location  API...

  TextEditingController searchLocationController = TextEditingController();
  bool? loadingSearchLocation = true;
  LocationModel? locationModel;

  Future<LocationModel?> searchLocation({
    required BuildContext context,
    required String? query,
    num? radius,
  }) async {
    debugPrint("Fetching LocationModel...");
    loadingSearchLocation = true;
    // locationModel = null;

    notifyListeners();
    String? finalQuery = query?.isNotEmpty == true ? query : _address?.locality;
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "input": finalQuery ?? "",
      "location": "$_latitude,$_longitude",
      "radius": "${radius ?? 1000}",
      "key": AppConfig.mapAddressesApiKey,
    };

    var response = await ApiService().get(
      context: context,
      baseUrl: AppConfig.mapsBaseUrl,
      endPoint: "/place/autocomplete/json${queryParameter(body: body)}",
      headers: headers,
    );

    if (response != null) {
      Map<String, dynamic> json = response;
      LocationModel responseData = LocationModel.fromJson(json);
      if (responseData.status == "OK") {
        locationModel = responseData;
      } else {}
    }

    loadingSearchLocation = false;
    notifyListeners();
    return locationModel;
  }

  /// 2) PlacesDetailModel  API...

  bool? loadingPlacesDetailModel = true;
  PlacesDetailModel? placesDetailModel;

  Future<PlacesDetailModel?> fetchPlacesDetail({
    required BuildContext context,
    required String? placeId,
    GestureTapCallback? onComplete,
    int? radius,
  }) async {
    debugPrint("Fetching PlacesDetailModel...");
    loadingPlacesDetailModel = true;
    // locationModel = null;
    notifyListeners();

    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "place_id": placeId ?? "",
      "key": AppConfig.mapAddressesApiKey,
    };

    await loadingDialog(
      context: context,
      future: ApiService().get(
        context: context,
        baseUrl: AppConfig.mapsBaseUrl,
        endPoint: "/place/details/json${queryParameter(body: body)}",
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        PlacesDetailModel responseData = PlacesDetailModel.fromJson(json);
        if (responseData.status == "OK") {
          placesDetailModel = responseData;
          notifyListeners();

          if (onComplete != null) {
            onComplete();
          }
        } else {}
      } else {
        debugPrint("Empty Response");
      }
    });

    loadingSearchLocation = false;
    notifyListeners();
    return placesDetailModel;
  }

  ///4)Updating User Location to Server...

  Future updateUserLocation({required BuildContext context}) async {
    Map<String, String> body = {
      "latitude": "${latitude ?? ""}",
      "longitude": "${longitude ?? ""}",
      "address": address?.addressLine ?? "",
      "loc_range": "$locationRange",
    };
    debugPrint("Sent Data is $body");
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    ApiService()
        .post(
      context: context,
      endPoint: "/update_user_location",
      headers: defaultHeaders,
      body: body,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        AuthenticationModel responseData = AuthenticationModel.fromJson(json);

        if (responseData.status == true) {
          notifyListeners();
        }
      }
    });
  }

  bool locationPopupActive = false;

  closeLocationPopupStatus() {
    locationPopupActive = false;
    debugPrint("Closed Location Popup");
    notifyListeners();
  }

  Future showLocationPopup({
    required BuildContext context,
    GestureTapCallback? onSuccess,
  }) async {
    Size size = MediaQuery.of(context).size;

    if (locationPopupActive == false) {
      locationPopupActive = true;
      notifyListeners();
      return CustomBottomSheet.show(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        constraints: BoxConstraints(minHeight: size.height * 0.6, maxHeight: size.height * 0.9),
        physics: const ScrollPhysics(),
        mainAxisSize: MainAxisSize.min,
        bottomNavBarAlignment: Alignment.topCenter,
        body: LocationPopupBody(onSuccess: onSuccess),
      );
    } else {
      debugPrint("Location Popup Already Active");
    }
  }
}
