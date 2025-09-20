// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RatingModelAdapter extends TypeAdapter<RatingModel> {
  @override
  final int typeId = 25;

  @override
  RatingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RatingModel(
      id: fields[0] as int?,
      reviewer: fields[1] as ReviewerModel?,
      role: fields[2] as int?,
      rating: fields[3] as double?,
      feedback: fields[4] as String?,
      createdAt: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RatingModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reviewer)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.feedback)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewerModelAdapter extends TypeAdapter<ReviewerModel> {
  @override
  final int typeId = 26;

  @override
  ReviewerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewerModel(
      id: fields[0] as int?,
      uuid: fields[1] as String?,
      profileImage: fields[2] as String?,
      name: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewerModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.profileImage)
      ..writeByte(3)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
