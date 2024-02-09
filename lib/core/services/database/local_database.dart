import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gaas/core/config/app_config.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../../controllers/orders/cart_controller.dart';
import '../../../models/auth/user_data.dart';
import '../../../models/dashboard/producer_details_model.dart';

class LocalDatabase extends ChangeNotifier {
  ///Hive Database Initialization....

  static Future initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(AppConfig.databaseName);
  }

  ///Hive Database Box....
  Box database = Hive.box(AppConfig.databaseName);

  ///Access Local Database data...
  late bool? isSkipped = database.get("isSkipped");

  late bool? isFreshProducer = database.get("isFreshProducer");
  late bool? isNursery = database.get("isNursery");
  late bool? isServiceProvider = database.get("isServiceProvider");

  late num? id = database.get("id");
  late String? name = database.get("name");
  late String? email = database.get("email");
  late String? mobile = database.get("mobile");
  late String? profilePhoto = database.get("profilePhoto");
  late String? providerId = database.get("providerId");
  late String? referralCode = database.get("referralCode");
  late String? address = database.get("address");
  late String? countryCode = database.get("countryCode");
  late String? countryId = database.get("countryId");
  late String? stateId = database.get("stateId");
  late String? cityId = database.get("cityId");
  late String? countryName = database.get("countryName");
  late String? stateName = database.get("stateName");
  late String? cityName = database.get("cityName");
  late String? photoUrl = database.get("photoUrl");
  late num? balanceCoins = database.get("balanceCoins");
  late num? eachCoinAmount = database.get("eachCoinAmount");

  late String? role = database.get("role");
  late double? latitude = database.get("latitude");
  late double? longitude = database.get("longitude");
  late String? locAddress = database.get("locAddress");
  late String? accessToken = database.get("accessToken");
  late String? deviceToken = database.get("deviceToken");
  late String? cartItems = database.get("cartItems");

  ///Setting Local Database data...

  Future saveUser({required UserData? user}) async {
    database.put("id", user?.id ?? id);
    database.put("name", user?.name ?? name);
    database.put("email", user?.email ?? email);
    database.put("mobile", user?.mobile ?? mobile);
    database.put("profilePhoto", user?.profilePhoto ?? profilePhoto);
    database.put("providerId", user?.providerId ?? providerId);
    database.put("referralCode", user?.referralCode ?? referralCode);
    database.put("address", user?.address ?? address);
    database.put("locAddress", user?.locAddress ?? locAddress);
    database.put("countryCode", user?.countryCode ?? countryCode);
    database.put("countryId", user?.countryId ?? countryId);
    database.put("stateId", user?.stateId ?? stateId);
    database.put("cityId", user?.cityId ?? cityId);
    database.put("countryId", user?.countryName ?? countryName);
    database.put("stateId", user?.stateName ?? stateName);
    database.put("cityId", user?.cityName ?? cityName);
    database.put("role", user?.role ?? role);
    database.put("balanceCoins", user?.balanceCoins ?? balanceCoins);
    database.put("eachCoinAmount", user?.eachCoinAmount ?? eachCoinAmount);
    database.put("accessToken", user?.accessToken ?? accessToken);
  }

  setDeviceToken(String? token) {
    deviceToken = token;
    database.put("deviceToken", token ?? "");
    notifyListeners();
  }

  setAccessToken(String? token) {
    accessToken = token;
    database.put("accessToken", token ?? "");
    notifyListeners();
  }

  setIsSkipped(bool? newBool) {
    isSkipped = newBool;
    database.put("isSkipped", newBool);
    notifyListeners();
  }

  setIsFreshProducer(bool? newBool) {
    isFreshProducer = newBool;
    database.put("isFreshProducer", newBool);
    notifyListeners();
  }

  setIsNursery(bool? newBool) {
    isNursery = newBool;
    database.put("isNursery", newBool);
    notifyListeners();
  }

  setIsServiceProvider(bool? newBool) {
    isServiceProvider = newBool;
    database.put("isServiceProvider", newBool);
    notifyListeners();
  }

  setGaasCoins(num? coins) {
    balanceCoins = coins;
    database.put("balanceCoins", coins);
    notifyListeners();
  }

  setCartItems(List<ProducerDetailsData?>? items) {
    String encodedData = jsonEncode(items);
    database.put("cartItems", encodedData);
    notifyListeners();
    debugPrint("Setting Cart Items $cartItems");
  }

  List<ProducerDetailsData?>? getCartItems(BuildContext context) {
    debugPrint("Getting Cart Items ");
    List<dynamic>? dynamicItems;
    List<ProducerDetailsData?>? items;

    if (cartItems != null) {
      dynamicItems = jsonDecode("$cartItems");
      items = dynamicItems?.map((e) => producerDetailsDataFromJson(jsonEncode(e))).toList();
      notifyListeners();
    }

    context.read<CartController>().setCartItems(items);

    return items;
  }

  setLatLong(
    double? latitude,
    double? longitude,
  ) {
    latitude = latitude;
    longitude = longitude;
    database.put("latitude", latitude);
    database.put("longitude", longitude);
    notifyListeners();
  }

  setAddress(
    String? address,
  ) {
    this.address = address;
    database.put("address", address);

    notifyListeners();
  }
}
