// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TruckModelAdapter extends TypeAdapter<TruckModel> {
  @override
  final int typeId = 14;

  @override
  TruckModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TruckModel(
      id: fields[0] as int?,
      truckImage: fields[1] as String?,
      regdNumber: fields[2] as String?,
      driver: fields[3] as TruckDriverModel?,
      owner: fields[4] as TruckOwnerModel?,
      registration: fields[5] as RegistrationModel?,
      specs: fields[6] as SpecsModel?,
      validity: fields[7] as ValidityModel?,
      createdAt: fields[8] as String?,
      updatedAt: fields[9] as String?,
      isFav: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TruckModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.truckImage)
      ..writeByte(2)
      ..write(obj.regdNumber)
      ..writeByte(3)
      ..write(obj.driver)
      ..writeByte(4)
      ..write(obj.owner)
      ..writeByte(5)
      ..write(obj.registration)
      ..writeByte(6)
      ..write(obj.specs)
      ..writeByte(7)
      ..write(obj.validity)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.isFav);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TruckModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TruckDriverModelAdapter extends TypeAdapter<TruckDriverModel> {
  @override
  final int typeId = 15;

  @override
  TruckDriverModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TruckDriverModel(
      id: fields[0] as int?,
      uuid: fields[1] as String?,
      profileImage: fields[2] as String?,
      name: fields[3] as String?,
      mobileNumber: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TruckDriverModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.profileImage)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.mobileNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TruckDriverModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TruckOwnerModelAdapter extends TypeAdapter<TruckOwnerModel> {
  @override
  final int typeId = 16;

  @override
  TruckOwnerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TruckOwnerModel(
      id: fields[0] as int?,
      uuid: fields[1] as String?,
      profileImage: fields[2] as String?,
      name: fields[3] as String?,
      mobileNumber: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TruckOwnerModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.profileImage)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.mobileNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TruckOwnerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RegistrationModelAdapter extends TypeAdapter<RegistrationModel> {
  @override
  final int typeId = 17;

  @override
  RegistrationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegistrationModel(
      place: fields[0] as String?,
      registrationDate: fields[1] as String?,
      rcStatus: fields[2] as String?,
      rcModel: fields[3] as String?,
      rcOwnerSr: fields[4] as int?,
      rcVhClassDesc: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RegistrationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.place)
      ..writeByte(1)
      ..write(obj.registrationDate)
      ..writeByte(2)
      ..write(obj.rcStatus)
      ..writeByte(3)
      ..write(obj.rcModel)
      ..writeByte(4)
      ..write(obj.rcOwnerSr)
      ..writeByte(5)
      ..write(obj.rcVhClassDesc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegistrationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpecsModelAdapter extends TypeAdapter<SpecsModel> {
  @override
  final int typeId = 18;

  @override
  SpecsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpecsModel(
      brand: fields[0] as String?,
      model: fields[1] as String?,
      engineNo: fields[2] as String?,
      chassisNo: fields[3] as String?,
      fuelType: fields[4] as String?,
      unladenWeight: fields[5] as double?,
      financer: fields[6] as String?,
      insurancePolicyNo: fields[7] as String?,
      insuranceCompany: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SpecsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.brand)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.engineNo)
      ..writeByte(3)
      ..write(obj.chassisNo)
      ..writeByte(4)
      ..write(obj.fuelType)
      ..writeByte(5)
      ..write(obj.unladenWeight)
      ..writeByte(6)
      ..write(obj.financer)
      ..writeByte(7)
      ..write(obj.insurancePolicyNo)
      ..writeByte(8)
      ..write(obj.insuranceCompany);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ValidityModelAdapter extends TypeAdapter<ValidityModel> {
  @override
  final int typeId = 19;

  @override
  ValidityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ValidityModel(
      insuranceUpto: fields[0] as String?,
      taxUpto: fields[1] as String?,
      puccUpto: fields[2] as String?,
      fitnessUpto: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ValidityModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.insuranceUpto)
      ..writeByte(1)
      ..write(obj.taxUpto)
      ..writeByte(2)
      ..write(obj.puccUpto)
      ..writeByte(3)
      ..write(obj.fitnessUpto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
