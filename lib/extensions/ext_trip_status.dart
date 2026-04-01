import '/dist/enums/enum_trip_status.dart';

extension TripStatusCodeExtension on int {
  String get tripStatusName {
    switch (this) {
      case 0:
        return 'Draft';
      case 1:
        return 'Pending';
      case 2:
        return 'Assigned';
      case 3:
        return 'Scheduled';
      case 4:
        return 'In Progress';
      case 5:
        return 'Completed';
      case 6:
        return 'Delayed';
      case 7:
        return 'On Hold';
      case 8:
        return 'Cancelled';
      case 9:
        return 'Aborted';
      case 10:
        return 'Failed';
      case 11:
        return 'Disputed';
      case 12:
        return 'Closed';
      case 13:
        return 'Archived';
      default:
        return 'Unknown';
    }
  }
}

extension TripStatusStringExtension on String {
  int get tripStatusCode {
    switch (toLowerCase()) {
      case 'draft':
        return 0;
      case 'pending':
        return 1;
      case 'assigned':
        return 2;
      case 'scheduled':
        return 3;
      case 'in progress':
        return 4;
      case 'completed':
        return 5;
      case 'delayed':
        return 6;
      case 'on hold':
        return 7;
      case 'cancelled':
        return 8;
      case 'aborted':
        return 9;
      case 'failed':
        return 10;
      case 'disputed':
        return 11;
      case 'closed':
        return 12;
      case 'archived':
        return 13;
      default:
        return -1; // invalid
    }
  }
}

extension TripStatusExtension on TripStatus {
  int get code {
    switch (this) {
      case TripStatus.draft:
        return 0;
      case TripStatus.pending:
        return 1;
      case TripStatus.assigned:
        return 2;
      case TripStatus.scheduled:
        return 3;
      case TripStatus.inProgress:
        return 4;
      case TripStatus.completed:
        return 5;
      case TripStatus.delayed:
        return 6;
      case TripStatus.onHold:
        return 7;
      case TripStatus.cancelled:
        return 8;
      case TripStatus.aborted:
        return 9;
      case TripStatus.failed:
        return 10;
      case TripStatus.disputed:
        return 11;
      case TripStatus.closed:
        return 12;
      case TripStatus.archived:
        return 13;
    }
  }

  String get name {
    switch (this) {
      case TripStatus.draft:
        return 'Draft';
      case TripStatus.pending:
        return 'Pending';
      case TripStatus.assigned:
        return 'Assigned';
      case TripStatus.scheduled:
        return 'Scheduled';
      case TripStatus.inProgress:
        return 'In Progress';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.delayed:
        return 'Delayed';
      case TripStatus.onHold:
        return 'On Hold';
      case TripStatus.cancelled:
        return 'Cancelled';
      case TripStatus.aborted:
        return 'Aborted';
      case TripStatus.failed:
        return 'Failed';
      case TripStatus.disputed:
        return 'Disputed';
      case TripStatus.closed:
        return 'Closed';
      case TripStatus.archived:
        return 'Archived';
    }
  }

  static TripStatus fromCode(int code) {
    return TripStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => TripStatus.draft,
    );
  }

  static TripStatus fromName(String name) {
    return TripStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => TripStatus.draft,
    );
  }
}
