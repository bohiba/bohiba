// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_driver_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OpenDriverModelAdapter extends TypeAdapter<OpenDriverModel> {
  @override
  final int typeId = 27;

  @override
  OpenDriverModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OpenDriverModel(
      id: fields[0] as int?,
      uuid: fields[1] as String?,
      profileImage: fields[5] as String?,
      name: fields[2] as String?,
      mobileNumber: fields[3] as String?,
      verified: fields[6] as String?,
      district: fields[7] as String?,
      state: fields[8] as String?,
      connect: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OpenDriverModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.mobileNumber)
      ..writeByte(5)
      ..write(obj.profileImage)
      ..writeByte(6)
      ..write(obj.verified)
      ..writeByte(7)
      ..write(obj.district)
      ..writeByte(8)
      ..write(obj.state)
      ..writeByte(9)
      ..write(obj.connect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpenDriverModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
