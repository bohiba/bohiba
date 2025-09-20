// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_fav_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserFavouriteModelAdapter extends TypeAdapter<UserFavouriteModel> {
  @override
  final int typeId = 20;

  @override
  UserFavouriteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserFavouriteModel(
      id: fields[0] as int?,
      userUuid: fields[1] as String?,
      assetType: fields[2] as String?,
      assetId: fields[3] as int?,
      createdAt: fields[4] as String?,
      updatedAt: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserFavouriteModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userUuid)
      ..writeByte(2)
      ..write(obj.assetType)
      ..writeByte(3)
      ..write(obj.assetId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserFavouriteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
