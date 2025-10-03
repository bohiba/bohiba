import '/services/db_service.dart';
import 'package:hive/hive.dart';
part 'user_list_model.g.dart';

@HiveType(typeId: userListTypeId)
class UserListModel {
  @HiveField(0)
  final String? uuid;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? password;

  @HiveField(4)
  final bool? isLoggedIn;
  UserListModel({
    this.uuid,
    this.name,
    this.email,
    this.password,
    this.isLoggedIn,
  });
}
