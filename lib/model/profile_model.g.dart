// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 0;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      uuid: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      mobileNumber: fields[3] as String?,
      dob: fields[4] as String?,
      roleId: fields[5] as int?,
      jobStatus: fields[6] as String?,
      verification: fields[7] as VerificationModel?,
      trucks: fields[8] as int?,
      drivers: fields[9] as int?,
      ratings: (fields[10] as List?)?.cast<RatingModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.mobileNumber)
      ..writeByte(4)
      ..write(obj.dob)
      ..writeByte(5)
      ..write(obj.roleId)
      ..writeByte(6)
      ..write(obj.jobStatus)
      ..writeByte(7)
      ..write(obj.verification)
      ..writeByte(8)
      ..write(obj.trucks)
      ..writeByte(9)
      ..write(obj.drivers)
      ..writeByte(10)
      ..write(obj.ratings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VerificationModelAdapter extends TypeAdapter<VerificationModel> {
  @override
  final int typeId = 1;

  @override
  VerificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerificationModel(
      id: fields[0] as int?,
      userUuid: fields[1] as String?,
      panNumber: fields[2] as String?,
      aadhaarNumber: fields[3] as String?,
      dlNumber: fields[4] as String?,
      verificationStatus: fields[5] as String?,
      houseNo: fields[6] as String?,
      locality: fields[7] as String?,
      street: fields[8] as String?,
      city: fields[9] as String?,
      district: fields[10] as String?,
      state: fields[11] as String?,
      country: fields[12] as String?,
      pinCode: fields[13] as String?,
      createdAt: fields[14] as String?,
      updatedAt: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VerificationModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userUuid)
      ..writeByte(2)
      ..write(obj.panNumber)
      ..writeByte(3)
      ..write(obj.aadhaarNumber)
      ..writeByte(4)
      ..write(obj.dlNumber)
      ..writeByte(5)
      ..write(obj.verificationStatus)
      ..writeByte(6)
      ..write(obj.houseNo)
      ..writeByte(7)
      ..write(obj.locality)
      ..writeByte(8)
      ..write(obj.street)
      ..writeByte(9)
      ..write(obj.city)
      ..writeByte(10)
      ..write(obj.district)
      ..writeByte(11)
      ..write(obj.state)
      ..writeByte(12)
      ..write(obj.country)
      ..writeByte(13)
      ..write(obj.pinCode)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
