class PickedLocationData {
  PickedLocationData({
    required this.address,
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
  });

  PickedLocationData.fromJson(dynamic json) {
    address = json['address'];
    formattedAddress = json['formattedAddress'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
  String? address;
  String? formattedAddress;
  double? latitude;
  double? longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = address;
    map['formattedAddress'] = formattedAddress;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}
