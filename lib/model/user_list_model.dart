import '/services/db_service.dart';
import 'package:hive/hive.dart';
part 'user_list_model.g.dart';

@HiveType(typeId: userListTypeId)
class LoggedInAccountModel {
  @HiveField(0)
  final String? uuid;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? token;

  @HiveField(4)
  final bool? isLoggedIn;
  LoggedInAccountModel({
    this.uuid,
    this.name,
    this.email,
    this.token,
    this.isLoggedIn,
  });

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'email': email,
        'token': token,
      };
}
