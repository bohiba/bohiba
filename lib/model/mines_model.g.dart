// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mines_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MinesModelAdapter extends TypeAdapter<MinesModel> {
  @override
  final int typeId = 3;

  @override
  MinesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MinesModel(
      id: fields[0] as int?,
      logo: fields[1] as String?,
      mineName: fields[2] as String?,
      location: fields[3] as String?,
      materialType: fields[4] as String?,
      materialGrade: fields[5] as String?,
      ownershipType: fields[6] as String?,
      penaltyRisk: fields[7] as String?,
      safetyGearMandate: fields[8] as String?,
      shiftTiming: fields[9] as String?,
      waitingPeriod: fields[10] as int?,
      roadConditions: fields[11] as String?,
      isFav: fields[14] as bool?,
      createdAt: fields[12] as String?,
      updatedAt: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MinesModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.logo)
      ..writeByte(2)
      ..write(obj.mineName)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.materialType)
      ..writeByte(5)
      ..write(obj.materialGrade)
      ..writeByte(6)
      ..write(obj.ownershipType)
      ..writeByte(7)
      ..write(obj.penaltyRisk)
      ..writeByte(8)
      ..write(obj.safetyGearMandate)
      ..writeByte(9)
      ..write(obj.shiftTiming)
      ..writeByte(10)
      ..write(obj.waitingPeriod)
      ..writeByte(11)
      ..write(obj.roadConditions)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.isFav);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
