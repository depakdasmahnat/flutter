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
      id: fields[0] as num?,
      memberId: fields[1] as String?,
      firstName: fields[2] as String?,
      lastName: fields[3] as String?,
      mobile: fields[4] as String?,
      email: fields[5] as String?,
      enagicId: fields[6] as String?,
      profilePhoto: fields[7] as String?,
      path: fields[8] as dynamic,
      gender: fields[9] as String?,
      leadRefType: fields[10] as dynamic,
      sponsorId: fields[11] as num?,
      sponsorName: fields[12] as dynamic,
      salesFacilitatorId: fields[13] as dynamic,
      salesFacilitatorName: fields[14] as dynamic,
      occupation: fields[15] as dynamic,
      dob: fields[16] as dynamic,
      noOfFamilyMembers: fields[17] as dynamic,
      illnessInFamily: fields[18] as dynamic,
      disability: fields[19] as dynamic,
      monthlyIncome: fields[20] as dynamic,
      stateId: fields[21] as dynamic,
      stateName: fields[22] as dynamic,
      cityId: fields[23] as dynamic,
      cityName: fields[24] as dynamic,
      pincode: fields[25] as dynamic,
      address: fields[26] as dynamic,
      referralCode: fields[27] as String?,
      role: fields[28] as String?,
      url: fields[29] as String?,
      accessToken: fields[30] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MemberData obj) {
    writer
      ..writeByte(31)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.memberId)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.mobile)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.enagicId)
      ..writeByte(7)
      ..write(obj.profilePhoto)
      ..writeByte(8)
      ..write(obj.path)
      ..writeByte(9)
      ..write(obj.gender)
      ..writeByte(10)
      ..write(obj.leadRefType)
      ..writeByte(11)
      ..write(obj.sponsorId)
      ..writeByte(12)
      ..write(obj.sponsorName)
      ..writeByte(13)
      ..write(obj.salesFacilitatorId)
      ..writeByte(14)
      ..write(obj.salesFacilitatorName)
      ..writeByte(15)
      ..write(obj.occupation)
      ..writeByte(16)
      ..write(obj.dob)
      ..writeByte(17)
      ..write(obj.noOfFamilyMembers)
      ..writeByte(18)
      ..write(obj.illnessInFamily)
      ..writeByte(19)
      ..write(obj.disability)
      ..writeByte(20)
      ..write(obj.monthlyIncome)
      ..writeByte(21)
      ..write(obj.stateId)
      ..writeByte(22)
      ..write(obj.stateName)
      ..writeByte(23)
      ..write(obj.cityId)
      ..writeByte(24)
      ..write(obj.cityName)
      ..writeByte(25)
      ..write(obj.pincode)
      ..writeByte(26)
      ..write(obj.address)
      ..writeByte(27)
      ..write(obj.referralCode)
      ..writeByte(28)
      ..write(obj.role)
      ..writeByte(29)
      ..write(obj.url)
      ..writeByte(30)
      ..write(obj.accessToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
