import 'dart:convert';

OrderDetailModel orderDetailModelFromJson(String str) => OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) => json.encode(data.toJson());

class OrderDetailModel {
  OrderDetailModel({
    this.status,
    this.message,
    this.data,
  });

  OrderDetailModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? OrderDetailData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  OrderDetailData? data;

  OrderDetailModel copyWith({
    bool? status,
    String? message,
    OrderDetailData? data,
  }) =>
      OrderDetailModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

OrderDetailData dataFromJson(String str) => OrderDetailData.fromJson(json.decode(str));

String dataToJson(OrderDetailData data) => json.encode(data.toJson());

class OrderDetailData {
  OrderDetailData({
    this.id,
    this.type,
    this.partnerId,
    this.userId,
    this.orderId,
    this.orderType,
    this.timeslotId,
    this.couponApplied,
    this.couponId,
    this.couponPrice,
    this.coinsApplied,
    this.coinsAmount,
    this.orderNumber,
    this.paymentMethod,
    this.actualAmount,
    this.subtotal,
    this.taxAmount,
    this.taxPercent,
    this.discount,
    this.totalAmount,
    this.paidAmount,
    this.comment,
    this.orderStatus,
    this.noOfPersons,
    this.eachPersonAmount,
    this.totalPersonAmount,
    this.createdAt,
    this.userLatitude,
    this.userLongitude,
    this.partnerName,
    this.path,
    this.profilePhoto,
    this.partnerEmail,
    this.partnerMobile,
    this.partnerLatitude,
    this.partnerLongitude,
    this.partnerAddress,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryAddress,
    this.partnerRating,
    this.partnerReviews,
    this.timeslotDay,
    this.fromTime,
    this.toTime,
    this.timeslotName,
    this.datetime,
    this.reviewAdded,
    this.ratings,
    this.reviewDetail,
    this.distanceNumber,
    this.distance,
    this.distanceLabel,
    this.rescheduleDate,
    this.rescheduleDay,
    this.products,
  });

  OrderDetailData.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    partnerId = json['partner_id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    orderType = json['order_type'];
    timeslotId = json['timeslot_id'];
    couponApplied = json['coupon_applied'];
    couponId = json['coupon_id'];
    couponPrice = json['coupon_price'];
    coinsApplied = json['coins_applied'];
    coinsAmount = json['coins_amount'];
    orderNumber = json['order_number'];
    paymentMethod = json['payment_method'];
    actualAmount = json['actual_amount'];
    subtotal = json['subtotal'];
    taxAmount = json['tax_amount'];
    taxPercent = json['tax_percent'];
    discount = json['discount'];
    totalAmount = json['total_amount'];
    paidAmount = json['paid_amount'];
    comment = json['comment'];
    orderStatus = json['order_status'];
    noOfPersons = json['no_of_persons'];
    eachPersonAmount = json['each_person_amount'];
    totalPersonAmount = json['total_person_amount'];
    createdAt = json['created_at'];
    userLatitude = json['user_latitude'];
    userLongitude = json['user_longitude'];
    partnerName = json['partner_name'];
    path = json['path'];
    profilePhoto = json['profile_photo'];
    partnerEmail = json['partner_email'];
    partnerMobile = json['partner_mobile'];
    partnerLatitude = json['partner_latitude'];
    partnerLongitude = json['partner_longitude'];
    partnerAddress = json['partner_address'];
    deliveryLatitude = json['delivery_latitude'];
    deliveryLongitude = json['delivery_longitude'];
    deliveryAddress = json['delivery_address'];
    partnerRating = json['partner_rating'];
    partnerReviews = json['partner_reviews'];
    timeslotDay = json['timeslot_day'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    timeslotName = json['timeslot_name'];
    datetime = json['datetime'];
    reviewAdded = json['review_added'];
    ratings = json['ratings'];
    reviewDetail = json['review_detail'] != null ? ReviewDetail.fromJson(json['review_detail']) : null;
    distanceNumber = json['distance_number'];
    distance = json['distance'];
    distanceLabel = json['distance_label'];
    rescheduleDate = json['reschedule_date'];
    rescheduleDay = json['reschedule_day'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(OrderDetailProducts.fromJson(v));
      });
    }
  }

  num? id;
  String? type;
  num? partnerId;
  num? userId;
  num? orderId;
  String? orderType;
  num? timeslotId;
  String? couponApplied;
  num? couponId;
  num? couponPrice;
  String? coinsApplied;
  num? coinsAmount;
  String? orderNumber;
  String? paymentMethod;
  num? actualAmount;
  num? subtotal;
  num? taxAmount;
  num? taxPercent;
  num? discount;
  num? totalAmount;
  num? paidAmount;
  String? orderStatus;
  String? comment;
  num? noOfPersons;
  num? eachPersonAmount;
  num? totalPersonAmount;
  String? createdAt;
  String? userLatitude;
  String? userLongitude;
  String? partnerName;
  String? path;
  String? profilePhoto;
  String? partnerEmail;
  String? partnerMobile;
  String? partnerLatitude;
  String? partnerLongitude;
  String? partnerAddress;
  dynamic deliveryLatitude;
  dynamic deliveryLongitude;
  dynamic deliveryAddress;
  num? partnerRating;
  num? partnerReviews;
  String? timeslotDay;
  String? fromTime;
  String? toTime;
  String? timeslotName;
  String? datetime;
  bool? reviewAdded;
  num? ratings;
  ReviewDetail? reviewDetail;
  num? distanceNumber;
  num? distance;
  String? distanceLabel;
  String? rescheduleDate;
  String? rescheduleDay;
  List<OrderDetailProducts>? products;

  OrderDetailData copyWith({
    num? id,
    String? type,
    num? partnerId,
    num? userId,
    num? orderId,
    String? orderType,
    num? timeslotId,
    String? couponApplied,
    num? couponId,
    num? couponPrice,
    String? coinsApplied,
    num? coinsAmount,
    String? orderNumber,
    String? paymentMethod,
    num? actualAmount,
    num? subtotal,
    num? taxAmount,
    num? taxPercent,
    num? discount,
    num? totalAmount,
    num? paid_amount,
    String? comment,
    String? orderStatus,
    num? noOfPersons,
    num? eachPersonAmount,
    num? totalPersonAmount,
    String? createdAt,
    String? userLatitude,
    String? userLongitude,
    String? partnerName,
    String? path,
    String? profilePhoto,
    String? partnerEmail,
    String? partnerMobile,
    String? partnerLatitude,
    String? partnerLongitude,
    String? partnerAddress,
    dynamic deliveryLatitude,
    dynamic deliveryLongitude,
    dynamic deliveryAddress,
    num? partnerRating,
    num? partnerReviews,
    String? timeslotDay,
    String? fromTime,
    String? toTime,
    String? timeslotName,
    String? datetime,
    bool? reviewAdded,
    num? ratings,
    ReviewDetail? reviewDetail,
    num? distanceNumber,
    num? distance,
    String? distanceLabel,
    String? reschedule_date,
    String? reschedule_day,
    List<OrderDetailProducts>? products,
  }) =>
      OrderDetailData(
        id: id ?? this.id,
        type: type ?? this.type,
        partnerId: partnerId ?? this.partnerId,
        userId: userId ?? this.userId,
        orderId: orderId ?? this.orderId,
        orderType: orderType ?? this.orderType,
        timeslotId: timeslotId ?? this.timeslotId,
        couponApplied: couponApplied ?? this.couponApplied,
        couponId: couponId ?? this.couponId,
        couponPrice: couponPrice ?? this.couponPrice,
        coinsApplied: coinsApplied ?? this.coinsApplied,
        coinsAmount: coinsAmount ?? this.coinsAmount,
        orderNumber: orderNumber ?? this.orderNumber,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        actualAmount: actualAmount ?? this.actualAmount,
        subtotal: subtotal ?? this.subtotal,
        taxAmount: taxAmount ?? this.taxAmount,
        taxPercent: taxPercent ?? this.taxPercent,
        discount: discount ?? this.discount,
        totalAmount: totalAmount ?? this.totalAmount,
        paidAmount: paid_amount ?? this.paidAmount,
        comment: comment ?? this.comment,
        orderStatus: orderStatus ?? this.orderStatus,
        noOfPersons: noOfPersons ?? this.noOfPersons,
        eachPersonAmount: eachPersonAmount ?? this.eachPersonAmount,
        totalPersonAmount: totalPersonAmount ?? this.totalPersonAmount,
        createdAt: createdAt ?? this.createdAt,
        userLatitude: userLatitude ?? this.userLatitude,
        userLongitude: userLongitude ?? this.userLongitude,
        partnerName: partnerName ?? this.partnerName,
        path: path ?? this.path,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        partnerEmail: partnerEmail ?? this.partnerEmail,
        partnerMobile: partnerMobile ?? this.partnerMobile,
        partnerLatitude: partnerLatitude ?? this.partnerLatitude,
        partnerLongitude: partnerLongitude ?? this.partnerLongitude,
        partnerAddress: partnerAddress ?? this.partnerAddress,
        deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
        deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        partnerRating: partnerRating ?? this.partnerRating,
        partnerReviews: partnerReviews ?? this.partnerReviews,
        timeslotDay: timeslotDay ?? this.timeslotDay,
        fromTime: fromTime ?? this.fromTime,
        toTime: toTime ?? this.toTime,
        timeslotName: timeslotName ?? this.timeslotName,
        datetime: datetime ?? this.datetime,
        reviewAdded: reviewAdded ?? this.reviewAdded,
        ratings: ratings ?? this.ratings,
        reviewDetail: reviewDetail ?? this.reviewDetail,
        distanceNumber: distanceNumber ?? this.distanceNumber,
        distance: distance ?? this.distance,
        distanceLabel: distanceLabel ?? this.distanceLabel,
        rescheduleDate: reschedule_date ?? this.rescheduleDate,
        rescheduleDay: reschedule_day ?? this.rescheduleDay,
        products: products ?? this.products,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['partner_id'] = partnerId;
    map['user_id'] = userId;
    map['order_id'] = orderId;
    map['order_type'] = orderType;
    map['timeslot_id'] = timeslotId;
    map['coupon_applied'] = couponApplied;
    map['coupon_id'] = couponId;
    map['coupon_price'] = couponPrice;
    map['coins_applied'] = coinsApplied;
    map['coins_amount'] = coinsAmount;
    map['order_number'] = orderNumber;
    map['payment_method'] = paymentMethod;
    map['actual_amount'] = actualAmount;
    map['subtotal'] = subtotal;
    map['tax_amount'] = taxAmount;
    map['tax_percent'] = taxPercent;
    map['discount'] = discount;

    map['total_amount'] = totalAmount;
    map['paid_amount'] = paidAmount;

    map['comment'] = comment;
    map['order_status'] = orderStatus;
    map['no_of_persons'] = noOfPersons;
    map['each_person_amount'] = eachPersonAmount;
    map['total_person_amount'] = totalPersonAmount;
    map['created_at'] = createdAt;
    map['user_latitude'] = userLatitude;
    map['user_longitude'] = userLongitude;
    map['partner_name'] = partnerName;
    map['path'] = path;
    map['profile_photo'] = profilePhoto;
    map['partner_email'] = partnerEmail;
    map['partner_mobile'] = partnerMobile;
    map['partner_latitude'] = partnerLatitude;
    map['partner_longitude'] = partnerLongitude;
    map['partner_address'] = partnerAddress;
    map['delivery_latitude'] = deliveryLatitude;
    map['delivery_longitude'] = deliveryLongitude;
    map['delivery_address'] = deliveryAddress;
    map['partner_rating'] = partnerRating;
    map['partner_reviews'] = partnerReviews;
    map['timeslot_day'] = timeslotDay;
    map['from_time'] = fromTime;
    map['to_time'] = toTime;
    map['timeslot_name'] = timeslotName;
    map['datetime'] = datetime;
    map['review_added'] = reviewAdded;
    map['ratings'] = ratings;
    if (reviewDetail != null) {
      map['review_detail'] = reviewDetail?.toJson();
    }
    map['distance_number'] = distanceNumber;
    map['distance'] = distance;
    map['distance_label'] = distanceLabel;
    map['reschedule_date'] = rescheduleDate;
    map['reschedule_day'] = rescheduleDay;
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

OrderDetailProducts productsFromJson(String str) => OrderDetailProducts.fromJson(json.decode(str));

String productsToJson(OrderDetailProducts data) => json.encode(data.toJson());

class OrderDetailProducts {
  OrderDetailProducts({
    this.id,
    this.productName,
    this.image,
    this.path,
    this.quantity,
    this.mrpAmount,
    this.totalMrpAmount,
    this.regularAmount,
    this.totalRegularAmount,
    this.remarks,
    this.unitName,
  });

  OrderDetailProducts.fromJson(dynamic json) {
    id = json['id'];
    productName = json['product_name'];
    image = json['image'];
    path = json['path'];
    quantity = json['quantity'];
    mrpAmount = json['mrp_amount'];
    totalMrpAmount = json['total_mrp_amount'];
    regularAmount = json['regular_amount'];
    totalRegularAmount = json['total_regular_amount'];
    remarks = json['remarks'];
    unitName = json['unit_name'];
  }

  num? id;
  String? productName;
  String? image;
  String? path;
  num? quantity;
  num? mrpAmount;
  num? totalMrpAmount;
  num? regularAmount;
  num? totalRegularAmount;
  String? remarks;
  String? unitName;

  OrderDetailProducts copyWith({
    num? id,
    String? productName,
    String? image,
    String? path,
    num? quantity,
    num? mrpAmount,
    num? totalMrpAmount,
    num? regularAmount,
    num? totalRegularAmount,
    String? remarks,
    String? unitName,
  }) =>
      OrderDetailProducts(
        id: id ?? this.id,
        productName: productName ?? this.productName,
        image: image ?? this.image,
        path: path ?? this.path,
        quantity: quantity ?? this.quantity,
        mrpAmount: mrpAmount ?? this.mrpAmount,
        totalMrpAmount: totalMrpAmount ?? this.totalMrpAmount,
        regularAmount: regularAmount ?? this.regularAmount,
        totalRegularAmount: totalRegularAmount ?? this.totalRegularAmount,
        remarks: remarks ?? this.remarks,
        unitName: unitName ?? this.unitName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['product_name'] = productName;
    map['image'] = image;
    map['path'] = path;
    map['quantity'] = quantity;
    map['mrp_amount'] = mrpAmount;
    map['total_mrp_amount'] = totalMrpAmount;
    map['regular_amount'] = regularAmount;
    map['total_regular_amount'] = totalRegularAmount;
    map['remarks'] = remarks;
    map['unit_name'] = unitName;
    return map;
  }
}

ReviewDetail reviewDetailFromJson(String str) => ReviewDetail.fromJson(json.decode(str));

String reviewDetailToJson(ReviewDetail data) => json.encode(data.toJson());

class ReviewDetail {
  ReviewDetail({
    this.id,
    this.rating,
    this.review,
  });

  ReviewDetail.fromJson(dynamic json) {
    id = json['id'];
    rating = json['rating'];
    review = json['review'];
  }

  num? id;
  num? rating;
  String? review;

  ReviewDetail copyWith({
    num? id,
    num? rating,
    String? review,
  }) =>
      ReviewDetail(
        id: id ?? this.id,
        rating: rating ?? this.rating,
        review: review ?? this.review,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['rating'] = rating;
    map['review'] = review;
    return map;
  }
}
