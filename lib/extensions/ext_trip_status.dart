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
