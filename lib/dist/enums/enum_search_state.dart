enum EnumSearchState {
  /// Waiting for the user to start typing — no API call has been made yet.
  idle,

  /// A search request is in-flight.
  searching,

  /// Search completed and at least one result was returned.
  success,

  /// Search completed but the API returned an empty list.
  noDataFound,

  /// The API call failed.
  error,
}
