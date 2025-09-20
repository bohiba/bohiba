enum AppThemeMode { system, light, dark }

enum ActionType { view, add, edit, delete, route, other }

enum UserRoleType { driver, manager, truckowner, unknown }

enum UploadStatus { initial, uploading, success, verified, failure }

enum AlertStatus { info, warning, failure, success }

enum PickerType { camera, gallery }

enum InformationType { started, success, failed }

enum StatusMessage { failure, warning, success }

enum ServiceType { driver, trip, truck, manager }

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

enum MethodType { server, local, other }
