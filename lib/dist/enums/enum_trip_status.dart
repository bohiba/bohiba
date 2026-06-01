enum EnumTripStatus {
  draft(0),
  pending(1),
  assigned(2),
  scheduled(3),
  inProgress(4),
  completed(5),
  delayed(6),
  onHold(7),
  cancelled(8),
  aborted(9),
  failed(10),
  disputed(11),
  closed(12),
  archived(13);

  const EnumTripStatus(this.value);

  final int value;

  static EnumTripStatus? fromValue(int value) {
    try {
      return EnumTripStatus.values.firstWhere(
        (status) => status.value == value,
      );
    } catch (_) {
      return null;
    }
  }
}
