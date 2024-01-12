class CountriesData {
  CountriesData({
    required this.id,
    required this.alpha2,
    required this.alpha3,
    required this.name,
  });

  CountriesData.fromJson(dynamic json) {
    id = json['id'];
    alpha2 = json['alpha2'];
    alpha3 = json['alpha3'];
    name = json['name'];
  }

  int? id;
  String? alpha2;
  String? alpha3;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['alpha2'] = alpha2;
    map['alpha3'] = alpha3;
    map['name'] = name;
    return map;
  }
}
