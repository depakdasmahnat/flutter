import 'dart:convert';

class DummyMembershipData {
  DummyMembershipData({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.image,
    required this.price,
    required this.discountedPrice,
    required this.perks,
  });

  String? id;
  String? title;
  String? description;
  String? duration;
  String? image;
  num? price;
  num? discountedPrice;
  List<PerksData>? perks; // Change to List<PerksData>

  DummyMembershipData.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    duration = json['duration'];
    image = json['image'];
    price = json['price'];
    discountedPrice = json['discountedPrice'];

    if (json['perks'] != null) {
      perks = [];
      json['perks'].forEach((perk) {
        perks!.add(PerksData.fromJson(perk));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['duration'] = duration;
    map['image'] = image;
    map['price'] = price;
    map['discountedPrice'] = discountedPrice;

    if (perks != null) {
      map['perks'] = perks!.map((perk) => perk.toJson()).toList();
    }

    return map;
  }
}

PerksData perksFromJson(String str) => PerksData.fromJson(json.decode(str));

String perksToJson(PerksData data) => json.encode(data.toJson());

class PerksData {
  PerksData({
    required this.title,
    required this.description,
    required this.image,
  });

  PerksData.fromJson(dynamic json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }

  String? title;
  String? description;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    return map;
  }
}
