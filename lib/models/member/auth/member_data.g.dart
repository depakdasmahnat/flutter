// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberDataAdapter extends TypeAdapter<MemberData> {
  @override
  final int typeId = 1;

  @override
  MemberData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberData(
      memberId: fields[0] as String?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      mobile: fields[3] as String?,
      email: fields[4] as String?,
      enagicId: fields[5] as String?,
      profilePhoto: fields[6] as String?,
      path: fields[7] as String?,
      gender: fields[8] as String?,
      leadRefType: fields[9] as String?,
      sponsorId: fields[10] as num?,
      salesFacilitatorId: fields[11] as num?,
      occupation: fields[12] as String?,
      dob: fields[13] as String?,
      noOfFamilyMembers: fields[14] as num?,
      illnessInFamily: fields[15] as String?,
      disability: fields[16] as String?,
      monthlyIncome: fields[17] as String?,
      stateId: fields[18] as num?,
      cityId: fields[19] as num?,
      pincode: fields[20] as String?,
      address: fields[21] as String?,
      referralCode: fields[22] as String?,
      role: fields[23] as String?,
      url: fields[24] as String?,
      accessToken: fields[25] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MemberData obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.memberId)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.enagicId)
      ..writeByte(6)
      ..write(obj.profilePhoto)
      ..writeByte(7)
      ..write(obj.path)
      ..writeByte(8)
      ..write(obj.gender)
      ..writeByte(9)
      ..write(obj.leadRefType)
      ..writeByte(10)
      ..write(obj.sponsorId)
      ..writeByte(11)
      ..write(obj.salesFacilitatorId)
      ..writeByte(12)
      ..write(obj.occupation)
      ..writeByte(13)
      ..write(obj.dob)
      ..writeByte(14)
      ..write(obj.noOfFamilyMembers)
      ..writeByte(15)
      ..write(obj.illnessInFamily)
      ..writeByte(16)
      ..write(obj.disability)
      ..writeByte(17)
      ..write(obj.monthlyIncome)
      ..writeByte(18)
      ..write(obj.stateId)
      ..writeByte(19)
      ..write(obj.cityId)
      ..writeByte(20)
      ..write(obj.pincode)
      ..writeByte(21)
      ..write(obj.address)
      ..writeByte(22)
      ..write(obj.referralCode)
      ..writeByte(23)
      ..write(obj.role)
      ..writeByte(24)
      ..write(obj.url)
      ..writeByte(25)
      ..write(obj.accessToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
