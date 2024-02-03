import 'dart:convert';

Validatemobile validatemobileFromJson(String str) => Validatemobile.fromJson(json.decode(str));

String validatemobileToJson(Validatemobile data) => json.encode(data.toJson());

class Validatemobile {
  Validatemobile({
    bool? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Validatemobile.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;

  String? get message => _message;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    int? id,
    String? firstName,
    String? lastName,
    String? mobile,
    String? email,
    dynamic profilePhoto,
    dynamic path,
    int? stateId,
    int? cityId,
    String? address,
    String? role,
    dynamic emailVerifiedAt,
    dynamic deviceToken,
    String? createdAt,
    dynamic updatedAt,
    String? isActive,
    String? status,
    String? priority,
    dynamic deletedAt,
    int? steps,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _mobile = mobile;
    _email = email;
    _profilePhoto = profilePhoto;
    _path = path;
    _stateId = stateId;
    _cityId = cityId;
    _address = address;
    _role = role;
    _emailVerifiedAt = emailVerifiedAt;
    _deviceToken = deviceToken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _isActive = isActive;
    _status = status;
    _priority = priority;
    _deletedAt = deletedAt;
    _steps = steps;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _profilePhoto = json['profile_photo'];
    _path = json['path'];
    _stateId = json['state_id'];
    _cityId = json['city_id'];
    _address = json['address'];
    _role = json['role'];
    _emailVerifiedAt = json['email_verified_at'];
    _deviceToken = json['device_token'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isActive = json['is_active'];
    _status = json['status'];
    _priority = json['priority'];
    _deletedAt = json['deleted_at'];
    _steps = json['steps'];
  }

  int? _id;
  String? _firstName;
  String? _lastName;
  String? _mobile;
  String? _email;
  dynamic _profilePhoto;
  dynamic _path;
  int? _stateId;
  int? _cityId;
  String? _address;
  String? _role;
  dynamic _emailVerifiedAt;
  dynamic _deviceToken;
  String? _createdAt;
  dynamic _updatedAt;
  String? _isActive;
  String? _status;
  String? _priority;
  dynamic _deletedAt;
  int? _steps;

  int? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get mobile => _mobile;

  String? get email => _email;

  dynamic get profilePhoto => _profilePhoto;

  dynamic get path => _path;

  int? get stateId => _stateId;

  int? get cityId => _cityId;

  String? get address => _address;

  String? get role => _role;

  dynamic get emailVerifiedAt => _emailVerifiedAt;

  dynamic get deviceToken => _deviceToken;

  String? get createdAt => _createdAt;

  dynamic get updatedAt => _updatedAt;

  String? get isActive => _isActive;

  String? get status => _status;

  String? get priority => _priority;

  dynamic get deletedAt => _deletedAt;

  int? get steps => _steps;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['mobile'] = _mobile;
    map['email'] = _email;
    map['profile_photo'] = _profilePhoto;
    map['path'] = _path;
    map['state_id'] = _stateId;
    map['city_id'] = _cityId;
    map['address'] = _address;
    map['role'] = _role;
    map['email_verified_at'] = _emailVerifiedAt;
    map['device_token'] = _deviceToken;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['is_active'] = _isActive;
    map['status'] = _status;
    map['priority'] = _priority;
    map['deleted_at'] = _deletedAt;
    map['steps'] = _steps;
    return map;
  }
}
