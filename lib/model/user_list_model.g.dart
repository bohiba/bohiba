// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserListModelAdapter extends TypeAdapter<UserListModel> {
  @override
  final int typeId = 28;

  @override
  UserListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserListModel(
      uuid: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      password: fields[3] as String?,
      isLoggedIn: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserListModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.isLoggedIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
