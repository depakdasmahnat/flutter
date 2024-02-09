import 'dart:convert';

PartnerReviews partnerReviewsFromJson(String str) => PartnerReviews.fromJson(json.decode(str));

String partnerReviewsToJson(PartnerReviews data) => json.encode(data.toJson());

class PartnerReviews {
  PartnerReviews({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  PartnerReviews.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    data = json['data'] != null ? PartnerReviewsData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  num? totalPage;
  PartnerReviewsData? data;

  PartnerReviews copyWith({
    bool? status,
    String? message,
    num? totalPage,
    PartnerReviewsData? data,
  }) =>
      PartnerReviews(
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

PartnerReviewsData dataFromJson(String str) => PartnerReviewsData.fromJson(json.decode(str));

String dataToJson(PartnerReviewsData data) => json.encode(data.toJson());

class PartnerReviewsData {
  PartnerReviewsData({
    this.id,
    this.rating,
    this.reviews,
    this.type,
    this.oneRatingPercent,
    this.twoRatingPercent,
    this.threeRatingPercent,
    this.fourRatingPercent,
    this.fiveRatingPercent,
    this.reviewList,
  });

  PartnerReviewsData.fromJson(dynamic json) {
    id = json['id'];
    rating = json['rating'];
    reviews = json['reviews'];
    type = json['type'];
    oneRatingPercent = json['one_rating_percent'];
    twoRatingPercent = json['two_rating_percent'];
    threeRatingPercent = json['three_rating_percent'];
    fourRatingPercent = json['four_rating_percent'];
    fiveRatingPercent = json['five_rating_percent'];
    if (json['review_list'] != null) {
      reviewList = [];
      json['review_list'].forEach((v) {
        reviewList?.add(ReviewList.fromJson(v));
      });
    }
  }

  num? id;
  num? rating;
  num? reviews;
  String? type;
  num? oneRatingPercent;
  num? twoRatingPercent;
  num? threeRatingPercent;
  num? fourRatingPercent;
  num? fiveRatingPercent;
  List<ReviewList>? reviewList;

  PartnerReviewsData copyWith({
    num? id,
    num? rating,
    num? reviews,
    String? type,
    num? oneRatingPercent,
    num? twoRatingPercent,
    num? threeRatingPercent,
    num? fourRatingPercent,
    num? fiveRatingPercent,
    List<ReviewList>? reviewList,
  }) =>
      PartnerReviewsData(
        id: id ?? this.id,
        rating: rating ?? this.rating,
        reviews: reviews ?? this.reviews,
        type: type ?? this.type,
        oneRatingPercent: oneRatingPercent ?? this.oneRatingPercent,
        twoRatingPercent: twoRatingPercent ?? this.twoRatingPercent,
        threeRatingPercent: threeRatingPercent ?? this.threeRatingPercent,
        fourRatingPercent: fourRatingPercent ?? this.fourRatingPercent,
        fiveRatingPercent: fiveRatingPercent ?? this.fiveRatingPercent,
        reviewList: reviewList ?? this.reviewList,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['rating'] = rating;
    map['reviews'] = reviews;
    map['type'] = type;
    map['one_rating_percent'] = oneRatingPercent;
    map['two_rating_percent'] = twoRatingPercent;
    map['three_rating_percent'] = threeRatingPercent;
    map['four_rating_percent'] = fourRatingPercent;
    map['five_rating_percent'] = fiveRatingPercent;
    if (reviewList != null) {
      map['review_list'] = reviewList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

ReviewList reviewListFromJson(String str) => ReviewList.fromJson(json.decode(str));

String reviewListToJson(ReviewList data) => json.encode(data.toJson());

class ReviewList {
  ReviewList({
    this.id,
    this.userId,
    this.userType,
    this.partnerId,
    this.type,
    this.name,
    this.orderId,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.datetime,
    this.userName,
    this.userPhoto,
  });

  ReviewList.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    userType = json['user_type'];
    partnerId = json['partner_id'];
    type = json['type'];
    name = json['name'];
    orderId = json['order_id'];
    rating = json['rating'];
    review = json['review'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    datetime = json['datetime'];
    userName = json['user_name'];
    userPhoto = json['user_photo'];
  }

  num? id;
  num? userId;
  String? userType;
  num? partnerId;
  String? type;
  dynamic name;
  num? orderId;
  String? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? datetime;
  String? userName;
  String? userPhoto;

  ReviewList copyWith({
    num? id,
    num? userId,
    String? userType,
    num? partnerId,
    String? type,
    dynamic name,
    num? orderId,
    String? rating,
    String? review,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    String? datetime,
    String? userName,
    String? userPhoto,
  }) =>
      ReviewList(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        userType: userType ?? this.userType,
        partnerId: partnerId ?? this.partnerId,
        type: type ?? this.type,
        name: name ?? this.name,
        orderId: orderId ?? this.orderId,
        rating: rating ?? this.rating,
        review: review ?? this.review,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        datetime: datetime ?? this.datetime,
        userName: userName ?? this.userName,
        userPhoto: userPhoto ?? this.userPhoto,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['user_type'] = userType;
    map['partner_id'] = partnerId;
    map['type'] = type;
    map['name'] = name;
    map['order_id'] = orderId;
    map['rating'] = rating;
    map['review'] = review;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['datetime'] = datetime;
    map['user_name'] = userName;
    map['user_photo'] = userPhoto;
    return map;
  }
}
