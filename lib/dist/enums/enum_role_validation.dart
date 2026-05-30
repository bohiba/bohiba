enum EnumRoleValidation {
  none,
  whileSignIn,
  whileSignUp,
  whileUpdating,
}

extension EnumRoleValidationExtension on EnumRoleValidation {
  bool get isNone => this == EnumRoleValidation.none;
  bool get isWhileSignIn => this == EnumRoleValidation.whileSignIn;
  bool get isWhileSignUp => this == EnumRoleValidation.whileSignUp;
  bool get isUpdatingRole => this == EnumRoleValidation.whileUpdating;
}
