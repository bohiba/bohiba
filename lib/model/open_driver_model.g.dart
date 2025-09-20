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
      name: fields[2] as String?,
      profileImage: fields[3] as String?,
      mobileNumber: fields[4] as String?,
      jobStatus: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OpenDriverModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.profileImage)
      ..writeByte(4)
      ..write(obj.mobileNumber)
      ..writeByte(5)
      ..write(obj.jobStatus);
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
