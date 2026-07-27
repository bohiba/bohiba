enum AppThemeMode { light, dark, system, timeBased }

enum ActionType { view, add, edit, delete, route, share, sync, other }

enum UserRoleType {
  superAdmin(1),
  truckOwner(6),
  manager(7),
  driver(8),
  guest(9);

  final int value;
  const UserRoleType(this.value);
}

enum UploadStatus { initial, uploading, editing, success, verified, failure }

enum AlertStatus { info, warning, failure, success, noInternet }

enum PickerType { camera, gallery }

enum InformationType { started, success, failed }

enum StatusMessage { failure, warning, success }

enum ServiceType { driver, trip, truck, expenses, manager }

enum AddAssetUsing { uuid, doc, scan }

enum TripActionType {
  document,
  expense,
  payment,
  reassignment,
  edit,
  share,
  delete,
  more
}

enum MethodType { api, local, other }

enum TransitionType {
  fade,
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  scale,
  rotation
}

enum ConnectionType { accept, reject }
