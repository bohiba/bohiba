class LoggedInAccountModel {
  final String? uuid;
  final String? name;
  final String? email;
  final int? roleId;
  final String? token;
  LoggedInAccountModel({
    this.uuid,
    this.name,
    this.email,
    this.token,
    this.roleId = 9,
  });

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'email': email,
        'token': token,
        'roleId': roleId,
      };

  LoggedInAccountModel toMap(Map<String, dynamic> dbMap) =>
      LoggedInAccountModel(
        uuid: dbMap['uuid'],
        name: dbMap['name'],
        email: dbMap['email'],
        token: dbMap['token'],
        roleId: dbMap['roleId'],
      );
}
