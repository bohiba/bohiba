// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DriverModelAdapter extends TypeAdapter<DriverModel> {
  @override
  final int typeId = 21;

  @override
  DriverModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DriverModel(
      id: fields[0] as int?,
      isSynced: fields[1] as bool?,
      profile: fields[2] as DriverProfile?,
      licenseDetail: fields[3] as LicenseDetail?,
      rating: (fields[4] as List?)?.cast<RatingModel>(),
      isFav: fields[7] as bool?,
      createdAt: fields[5] as String?,
      updatedAt: fields[6] as String?,
      address: fields[8] as DriverAddress?,
      trips: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DriverModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isSynced)
      ..writeByte(2)
      ..write(obj.profile)
      ..writeByte(3)
      ..write(obj.licenseDetail)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.isFav)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.trips);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DriverProfileAdapter extends TypeAdapter<DriverProfile> {
  @override
  final int typeId = 22;

  @override
  DriverProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DriverProfile(
      driverUuid: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      mobileNumber: fields[3] as String?,
      image: fields[4] as String?,
      dob: fields[5] as String?,
      roleId: fields[6] as int?,
      isActive: fields[7] as String?,
      connect: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DriverProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.driverUuid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.mobileNumber)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.dob)
      ..writeByte(6)
      ..write(obj.roleId)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.connect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DriverAddressAdapter extends TypeAdapter<DriverAddress> {
  @override
  final int typeId = 23;

  @override
  DriverAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DriverAddress(
      id: fields[0] as int?,
      verified: fields[1] as String?,
      houseNo: fields[2] as String?,
      locality: fields[3] as String?,
      street: fields[4] as String?,
      city: fields[5] as String?,
      district: fields[6] as String?,
      state: fields[7] as String?,
      country: fields[8] as String?,
      pinCode: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DriverAddress obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.verified)
      ..writeByte(2)
      ..write(obj.houseNo)
      ..writeByte(3)
      ..write(obj.locality)
      ..writeByte(4)
      ..write(obj.street)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.district)
      ..writeByte(7)
      ..write(obj.state)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.pinCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LicenseDetailAdapter extends TypeAdapter<LicenseDetail> {
  @override
  final int typeId = 24;

  @override
  LicenseDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LicenseDetail(
      licenseNumber: fields[0] as String?,
      status: fields[1] as String?,
      rto: fields[2] as String?,
      cov: fields[3] as String?,
      validityFrom: fields[4] as String?,
      validityTill: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LicenseDetail obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.licenseNumber)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.rto)
      ..writeByte(3)
      ..write(obj.cov)
      ..writeByte(4)
      ..write(obj.validityFrom)
      ..writeByte(5)
      ..write(obj.validityTill);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LicenseDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
