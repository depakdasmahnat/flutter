import 'dart:convert';

import '../orders/order_addresses.dart';
import '../orders/partner_timeslote_dates_model.dart';
import '../partner/setup/delivery_zones_model.dart';
import '../partner/setup/timeslots_model.dart';

ProducerDetailsModel producerDetailsModelFromJson(String str) =>
    ProducerDetailsModel.fromJson(json.decode(str));

String producerDetailsModelToJson(ProducerDetailsModel data) => json.encode(data.toJson());

class ProducerDetailsModel {
  ProducerDetailsModel({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  ProducerDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    data = json['data'] != null ? ProducerDetailsData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  num? totalPage;
  ProducerDetailsData? data;

  ProducerDetailsModel copyWith({
    bool? status,
    String? message,
    num? totalPage,
    ProducerDetailsData? data,
  }) =>
      ProducerDetailsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        totalPage: totalPage ?? this.totalPage,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['total_page'] = totalPage;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

ProducerDetailsData producerDetailsDataFromJson(String str) => ProducerDetailsData.fromJson(json.decode(str));

String dataToJson(ProducerDetailsData data) => json.encode(data.toJson());

class ProducerDetailsData {
  ProducerDetailsData({
    this.id,
    this.userId,
    this.type,
    this.profilePhoto,
    this.path,
    this.name,
    this.email,
    this.countryCode,
    this.orderType,
    this.mobile,
    this.latitude,
    this.longitude,
    this.address,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryAddress,
    this.countryId,
    this.stateId,
    this.cityId,
    this.pincode,
    this.categories,
    this.reason,
    this.orderTypes,
    this.rating,
    this.eachPersonAmount,
    this.isFreeSelfPicking,
    this.reviews,
    this.isLive,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
    this.distanceNumber,
    this.distance,
    this.distanceLabel,
    this.inWishlist,
    this.wishlistId,
    this.selectedOrderMethod,
    this.noOfPersons,
    this.selectedDeliveryZone,
    this.deliveryAddressOrder,
    this.selectedTimeSlot,
    this.homeAddress,
    this.billingAddress,
    this.selectedDateSlot,
    this.serviceTypes,
    this.products,
    this.offers,
    this.isSameAddress,
  });

  ProducerDetailsData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    orderType = json['order_type'];
    mobile = json['mobile'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    deliveryLatitude = json['delivery_latitude'];
    deliveryLongitude = json['delivery_longitude'];
    deliveryAddress = json['delivery_address'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    pincode = json['pincode'];
    categories = json['categories'];
    reason = json['reason'];
    orderTypes = json['order_types'] != null ? json['order_types'].cast<String>() : [];
    rating = json['rating'];
    eachPersonAmount = json['each_person_amount'];
    isFreeSelfPicking = json['is_free_self_picking'];
    reviews = json['reviews'];
    isLive = json['is_live'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    distanceNumber = json['distance_number'];
    distance = json['distance'];
    distanceLabel = json['distance_label'];
    inWishlist = json['in_wishlist'];
    wishlistId = json['wishlist_id'];
    selectedOrderMethod = json['selectedOrderMethod'];
    noOfPersons = json['no_of_persons'];
    selectedDeliveryZone = json['selectedDeliveryZone'];
    deliveryAddressOrder = json['deliveryAddressOrder'];
    homeAddress = json['homeAddress'];
    billingAddress = json['billingAddress'];
    selectedDateSlot = json['selectedDateSlot'];
    selectedTimeSlot = json['selectedTimeSlot'];
    isSameAddress = json['is_same_address'];
    if (json['service_types'] != null) {
      serviceTypes = [];
      json['service_types'].forEach((v) {
        serviceTypes?.add(ProducerServiceTypes.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProducerProducts.fromJson(v));
      });
    }
    if (json['offers'] != null) {
      offers = [];
      json['offers'].forEach((v) {
        offers?.add(ProducerOffers.fromJson(v));
      });
    }
  }

  num? id;
  num? userId;
  String? type;
  String? profilePhoto;
  String? path;
  String? name;
  String? email;
  String? countryCode;
  String? orderType;
  String? mobile;
  String? latitude;
  String? longitude;
  String? address;
  String? deliveryLatitude;
  String? deliveryLongitude;
  String? deliveryAddress;
  num? countryId;
  num? stateId;
  num? cityId;
  String? pincode;
  dynamic categories;
  dynamic reason;
  List<String>? orderTypes;
  num? rating;
  num? eachPersonAmount;
  String? isFreeSelfPicking;
  num? reviews;
  String? isLive;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic deletedAt;
  num? distanceNumber;
  num? distance;
  String? distanceLabel;
  bool? inWishlist;
  dynamic wishlistId;
  String? selectedOrderMethod;
  bool? isSameAddress;
  num? noOfPersons;
  DeliveryZonesData? selectedDeliveryZone;
  OrderAddress? homeAddress;
  OrderAddress? deliveryAddressOrder;
  OrderAddress? billingAddress;
  PartnerTimeSlotDates? selectedDateSlot;
  TimeSlotsData? selectedTimeSlot;

  List<ProducerServiceTypes>? serviceTypes;
  List<ProducerProducts?>? products;
  List<ProducerOffers>? offers;

  ProducerDetailsData copyWith({
    required ProducerDetailsData? copy,
    num? id,
    num? userId,
    String? type,
    String? profilePhoto,
    String? path,
    String? name,
    String? email,
    String? countryCode,
    String? orderType,
    String? mobile,
    String? latitude,
    String? longitude,
    String? address,
    String? deliveryLatitude,
    String? deliveryLongitude,
    String? deliveryAddress,
    num? countryId,
    num? stateId,
    num? cityId,
    String? pincode,
    dynamic categories,
    dynamic reason,
    List<String>? orderTypes,
    num? rating,
    num? eachPersonAmount,
    String? isFreeSelfPicking,
    num? reviews,
    String? isLive,
    String? createdAt,
    String? updatedAt,
    String? status,
    dynamic deletedAt,
    num? distanceNumber,
    num? distance,
    String? distanceLabel,
    bool? inWishlist,
    dynamic wishlistId,
    String? selectedOrderMethod,
    bool? is_same_address,
    num? noOfPersons,
    DeliveryZonesData? selectedDeliveryZone,
    OrderAddress? homeAddress,
    OrderAddress? deliveryAddressOrder,
    OrderAddress? billingAddress,
    PartnerTimeSlotDates? selectedDateSlot,
    TimeSlotsData? selectedTimeSlot,
    List<ProducerServiceTypes>? serviceTypes,
    List<ProducerProducts?>? products,
    List<ProducerOffers>? offers,
  }) =>
      ProducerDetailsData(
        id: id ?? copy?.id,
        userId: userId ?? copy?.userId,
        type: type ?? copy?.type,
        profilePhoto: profilePhoto ?? copy?.profilePhoto,
        path: path ?? copy?.path,
        name: name ?? copy?.name,
        email: email ?? copy?.email,
        countryCode: countryCode ?? copy?.countryCode,
        orderType: orderType ?? copy?.orderType,
        mobile: mobile ?? copy?.mobile,
        latitude: latitude ?? copy?.latitude,
        longitude: longitude ?? copy?.longitude,
        address: address ?? copy?.address,
        deliveryLatitude: deliveryLatitude ?? copy?.deliveryLatitude,
        deliveryLongitude: deliveryLongitude ?? copy?.deliveryLongitude,
        deliveryAddress: deliveryAddress ?? copy?.deliveryAddress,
        countryId: countryId ?? copy?.countryId,
        stateId: stateId ?? copy?.stateId,
        cityId: cityId ?? copy?.cityId,
        pincode: pincode ?? copy?.pincode,
        categories: categories ?? copy?.categories,
        reason: reason ?? copy?.reason,
        orderTypes: orderTypes ?? copy?.orderTypes,
        rating: rating ?? copy?.rating,
        eachPersonAmount: eachPersonAmount ?? copy?.eachPersonAmount,
        isFreeSelfPicking: isFreeSelfPicking ?? copy?.isFreeSelfPicking,
        reviews: reviews ?? copy?.reviews,
        isLive: isLive ?? copy?.isLive,
        createdAt: createdAt ?? copy?.createdAt,
        updatedAt: updatedAt ?? copy?.updatedAt,
        status: status ?? copy?.status,
        deletedAt: deletedAt ?? copy?.deletedAt,
        distanceNumber: distanceNumber ?? copy?.distanceNumber,
        distance: distance ?? copy?.distance,
        distanceLabel: distanceLabel ?? copy?.distanceLabel,
        inWishlist: inWishlist ?? copy?.inWishlist,
        wishlistId: wishlistId ?? copy?.wishlistId,
        selectedOrderMethod: selectedOrderMethod ?? copy?.selectedOrderMethod,
        isSameAddress: is_same_address ?? copy?.isSameAddress,
        noOfPersons: noOfPersons ?? copy?.noOfPersons,
        selectedDateSlot: selectedDateSlot ?? copy?.selectedDateSlot,
        selectedTimeSlot: selectedTimeSlot ?? copy?.selectedTimeSlot,
        selectedDeliveryZone: selectedDeliveryZone ?? copy?.selectedDeliveryZone,
        homeAddress: homeAddress ?? copy?.homeAddress,
        billingAddress: billingAddress ?? copy?.billingAddress,
        deliveryAddressOrder: deliveryAddressOrder ?? copy?.deliveryAddressOrder,
        serviceTypes: serviceTypes ?? copy?.serviceTypes,
        products: products ?? copy?.products,
        offers: offers ?? copy?.offers,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['type'] = type;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['name'] = name;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['order_type'] = orderType;
    map['mobile'] = mobile;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['address'] = address;
    map['delivery_latitude'] = deliveryLatitude;
    map['delivery_longitude'] = deliveryLongitude;
    map['delivery_address'] = deliveryAddress;
    map['country_id'] = countryId;
    map['state_id'] = stateId;
    map['city_id'] = cityId;
    map['pincode'] = pincode;
    map['categories'] = categories;
    map['reason'] = reason;
    map['order_types'] = orderTypes;
    map['rating'] = rating;
    map['each_person_amount'] = eachPersonAmount;
    map['is_free_self_picking'] = isFreeSelfPicking;
    map['reviews'] = reviews;
    map['is_live'] = isLive;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    map['distance_number'] = distanceNumber;
    map['distance'] = distance;
    map['distance_label'] = distanceLabel;
    map['in_wishlist'] = inWishlist;
    map['wishlist_id'] = wishlistId;
    map['selectedOrderMethod'] = selectedOrderMethod;
    map['is_same_address'] = isSameAddress;
    map['no_of_persons'] = noOfPersons;
    map['selectedDateSlot'] = selectedDateSlot;
    map['selectedTimeSlot'] = selectedTimeSlot;
    map['selectedDeliveryZone'] = selectedDeliveryZone;
    map['deliveryAddressOrder'] = deliveryAddressOrder;
    map['homeAddress'] = homeAddress;
    map['billingAddress'] = billingAddress;
    if (serviceTypes != null) {
      map['service_types'] = serviceTypes?.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v?.toJson()).toList();
    }
    if (offers != null) {
      map['offers'] = offers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

ProducerProducts productsFromJson(String str) => ProducerProducts.fromJson(json.decode(str));

String productsToJson(ProducerProducts data) => json.encode(data.toJson());

class ProducerProducts {
  ProducerProducts({
    this.id,
    this.name,
    this.description,
    this.image,
    this.path,
    this.price,
    this.mrpPrice,
    this.unitId,
    this.initialInventory,
    this.quantity,
    this.unitName,
    this.discount,
    this.inWishlist,
    this.wishlistId,
  });

  ProducerProducts.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    path = json['path'];
    price = json['price'];
    mrpPrice = json['mrp_price'];
    unitId = json['unit_id'];
    initialInventory = json['initial_inventory'];
    quantity = json['quantity'] ?? 1;
    unitName = json['unit_name'];
    discount = json['discount'];
    inWishlist = json['in_wishlist'];
    wishlistId = json['wishlist_id'];
  }

  num? id;
  String? name;
  String? description;
  String? image;
  String? path;
  String? price;
  String? mrpPrice;
  num? unitId;
  int? initialInventory;
  int? quantity;
  num? discount;
  String? unitName;
  bool? inWishlist;
  num? wishlistId;

  ProducerProducts copyWith({
    ProducerProducts? copy,
    num? id,
    String? name,
    String? description,
    String? image,
    String? path,
    String? price,
    String? mrpPrice,
    num? unitId,
    int? initialInventory,
    int? quantity,
    String? unitName,
    num? discount,
    bool? inWishlist,
    num? wishlistId,
  }) =>
      ProducerProducts(
        id: id ?? copy?.id,
        name: name ?? copy?.name,
        description: description ?? copy?.description,
        image: image ?? copy?.image,
        path: path ?? copy?.path,
        price: price ?? copy?.price,
        mrpPrice: mrpPrice ?? copy?.mrpPrice,
        unitId: unitId ?? copy?.unitId,
        initialInventory: initialInventory ?? copy?.initialInventory ?? 1,
        quantity: (quantity ?? copy?.quantity) ?? 1,
        unitName: unitName ?? copy?.unitName,
        discount: discount ?? copy?.discount,
        inWishlist: inWishlist ?? this.inWishlist,
        wishlistId: wishlistId ?? this.wishlistId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['image'] = image;
    map['path'] = path;
    map['price'] = price;
    map['mrp_price'] = mrpPrice;
    map['unit_id'] = unitId;
    map['initial_inventory'] = initialInventory;
    map['quantity'] = quantity ?? 1;
    map['unit_name'] = unitName;
    map['discount'] = discount;
    map['in_wishlist'] = inWishlist;
    map['wishlist_id'] = wishlistId;

    return map;
  }
}

ProducerServiceTypes serviceTypesFromJson(String str) => ProducerServiceTypes.fromJson(json.decode(str));

String serviceTypesToJson(ProducerServiceTypes data) => json.encode(data.toJson());

class ProducerServiceTypes {
  ProducerServiceTypes({
    this.type,
    this.timeslots,
  });

  ProducerServiceTypes.fromJson(dynamic json) {
    type = json['type'];
    if (json['timeslots'] != null) {
      timeslots = [];
      json['timeslots'].forEach((v) {
        timeslots?.add(TimeSlotsData.fromJson(v));
      });
    }
  }

  String? type;
  List<TimeSlotsData>? timeslots;

  ProducerServiceTypes copyWith({
    String? type,
    List<TimeSlotsData>? timeslots,
  }) =>
      ProducerServiceTypes(
        type: type ?? this.type,
        timeslots: timeslots ?? this.timeslots,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;

    if (timeslots != null) {
      map['timeslots'] = timeslots?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

ProducerOffers offersFromJson(String str) => ProducerOffers.fromJson(json.decode(str));

String offersToJson(ProducerOffers data) => json.encode(data.toJson());

class ProducerOffers {
  ProducerOffers({
    this.id,
    this.couponFor,
    this.title,
    this.description,
    this.name,
    this.code,
    this.startDate,
    this.endDate,
    this.maxUser,
    this.eligibilityType,
    this.categoryId,
    this.claimType,
    this.percent,
    this.discountUpto,
    this.amount,
    this.creatorId,
    this.creatorType,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
  });

  ProducerOffers.fromJson(dynamic json) {
    id = json['id'];
    couponFor = json['coupon_for'];
    title = json['title'];
    description = json['description'];
    name = json['name'];
    code = json['code'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    maxUser = json['max_user'];
    eligibilityType = json['eligibility_type'];
    categoryId = json['category_id'];
    claimType = json['claim_type'];
    percent = json['percent'];
    discountUpto = json['discount_upto'];
    amount = json['amount'];
    creatorId = json['creator_id'];
    creatorType = json['creator_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
  }

  num? id;
  String? couponFor;
  String? title;
  String? description;
  String? name;
  String? code;
  String? startDate;
  String? endDate;
  num? maxUser;
  String? eligibilityType;
  dynamic categoryId;
  String? claimType;
  num? percent;
  String? discountUpto;
  String? amount;
  num? creatorId;
  String? creatorType;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic deletedAt;

  ProducerOffers copyWith({
    num? id,
    String? couponFor,
    String? title,
    String? description,
    String? name,
    String? code,
    String? startDate,
    String? endDate,
    num? maxUser,
    String? eligibilityType,
    dynamic categoryId,
    String? claimType,
    num? percent,
    String? discountUpto,
    String? amount,
    num? creatorId,
    String? creatorType,
    String? createdAt,
    String? updatedAt,
    String? status,
    dynamic deletedAt,
  }) =>
      ProducerOffers(
        id: id ?? this.id,
        couponFor: couponFor ?? this.couponFor,
        title: title ?? this.title,
        description: description ?? this.description,
        name: name ?? this.name,
        code: code ?? this.code,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        maxUser: maxUser ?? this.maxUser,
        eligibilityType: eligibilityType ?? this.eligibilityType,
        categoryId: categoryId ?? this.categoryId,
        claimType: claimType ?? this.claimType,
        percent: percent ?? this.percent,
        discountUpto: discountUpto ?? this.discountUpto,
        amount: amount ?? this.amount,
        creatorId: creatorId ?? this.creatorId,
        creatorType: creatorType ?? this.creatorType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['coupon_for'] = couponFor;
    map['title'] = title;
    map['description'] = description;
    map['name'] = name;
    map['code'] = code;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['max_user'] = maxUser;
    map['eligibility_type'] = eligibilityType;
    map['category_id'] = categoryId;
    map['claim_type'] = claimType;
    map['percent'] = percent;
    map['discount_upto'] = discountUpto;
    map['amount'] = amount;
    map['creator_id'] = creatorId;
    map['creator_type'] = creatorType;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['deleted_at'] = deletedAt;

    return map;
  }
}
