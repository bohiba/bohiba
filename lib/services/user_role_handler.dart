String getUserRoleName(int? value) {
  switch (value) {
    case 1:
      return "Truck Owner";
    case 2:
      return "Manager";
    case 3:
      return "Driver";
    default:
      return "Unknown";
  }
}
