// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuestDataAdapter extends TypeAdapter<GuestData> {
  @override
  final int typeId = 2;

  @override
  GuestData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuestData(
      id: fields[0] as num?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      mobile: fields[3] as String?,
      email: fields[4] as String?,
      profilePhoto: fields[5] as String?,
      referredBy: fields[6] as num?,
      deviceToken: fields[7] as String?,
      role: fields[8] as String?,
      steps: fields[9] as num?,
      accessToken: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GuestData obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.profilePhoto)
      ..writeByte(6)
      ..write(obj.referredBy)
      ..writeByte(7)
      ..write(obj.deviceToken)
      ..writeByte(8)
      ..write(obj.role)
      ..writeByte(9)
      ..write(obj.steps)
      ..writeByte(10)
      ..write(obj.accessToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
