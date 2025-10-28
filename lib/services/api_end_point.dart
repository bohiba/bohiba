class ApiEndPoint {
  static const String baseUrl = 'https://bohiba.com/api';
  static const String apiPostalCode = 'https://api.postalpincode.in/pincode';
  static const String apiVerifyEmail = '$baseUrl/verify-email';
  static const String apiVerifyOtp = '$baseUrl/verify-otp';
  static const String apiResendOtp = '$baseUrl/resend-otp';
  static const String apiCreateUser = '$baseUrl/create-user';
  static const String apiAddAddress = '$baseUrl/add-address';
  static const String apiSetProfileImage = '$baseUrl/set-profile-image';
  static const String apiSetRole = '$baseUrl/set-role';
  static const String apiEditDoc = '$baseUrl/add-document';
  static const String addOwnerExpense = '$baseUrl/add-expense';
  static const String apiEditUser = '$baseUrl/user-update';

  static const String apiForgotPassword = '$baseUrl/forgot-password';
  static const String apiResetPassword = '$baseUrl/reset-password';

  static const String apiLogin = '$baseUrl/login';
  static const String apiLogout = '$baseUrl/logout';
  static const String apiRefreshToken = '$baseUrl/refresh-token';
  static const String apiProfile = '$baseUrl/profile';
  static const String apiMain = '$baseUrl/main';

  static const String apiAllFav = '$baseUrl/all-favourite';
  static const String apiAddFav = '$baseUrl/add-favourite';
  static const String apiDeleteFav = '$baseUrl//delete-favourite';

  static const String apiAddTruck = '$baseUrl/truck-add';
  static const String apiAllTruck = '$baseUrl/truck-all';
  static const String apiGetTruck = '$baseUrl/truck-get';
  static const String apiSetTruckImage = '$baseUrl/set-truck-image';
  static const String apiDeleteTruck = '$baseUrl/truck-delete';

  static const String apiAddDriver = '$baseUrl/driver-add';
  static const String apiGetDriver = '$baseUrl/driver-get';
  static const String apiAllDriver = '$baseUrl/driver-all';
  static const String apiDeleteDriver = '$baseUrl/driver-delete';

  static const String apiAssignDriver = '$baseUrl/driver-assign';
  static const String apiRemoveDriver = '$baseUrl/driver-remove';

  static const String apiRateDriver = '$baseUrl/rate-user';
  static const String apiGetRating = '$baseUrl/all-rating';
  static const String apiDeleteRating = '$baseUrl/delete-rating';

  static const String apiAddTrip = '$baseUrl/trip-add';
  static const String apiAllTrip = '$baseUrl/trip-all';
  static const String apiGetTrip = '$baseUrl/trip-get';
  static const String apiEditTrip = '$baseUrl/trip-edit';
  static const String apiDeleteTrip = '$baseUrl/trip-delete';

  static const String apiAddTripPayment = '$baseUrl/trip/add-payment';
  static const String apiEditTripPayment = '$baseUrl/trip/update-payment';
  static const String apiDeleteTripPayment = '$baseUrl/trip/delete-payment';

  static const String apiAddTripExpense = '$baseUrl/trip/add-expenses';
  static const String apiEditTripExpense = '$baseUrl/trip/update-expenses';
  static const String apiDeleteTripExpense = '$baseUrl/trip/delete-expenses';

  static const String apiAddTripReassign = '$baseUrl/trip/add-reassignment';
  static const String apiEditTripReassign = '$baseUrl/trip/update-reassignment';
  static const String apiDeleteTripReassign =
      '$baseUrl/trip/delete-reassignment';

  static const String apiAllJobs = '$baseUrl/owner/job-posted';
  static const String apiCreateJobs = '$baseUrl/owner/job-create';
  static const String apiGetJob = '$baseUrl/owner/job-detail';
  static const String apiApplicants = '$baseUrl/owner/job-applicants';
  static const String apiEditJob = '$baseUrl/owner/job-update';
  // static const String apiUpdateJobStatus = '$baseUrl/owner/status-update';
  static const String apiDeleteJob = '$baseUrl/owner/job-delete';

  static const String apiOpenDriver = '$baseUrl/owner/open';
  static const String apiViewDriver = '$baseUrl/owner/view-driver';
  static const String apiSendConnectReq = '$baseUrl/owner/send';
  static const String apiAllSentReq = '$baseUrl/owner/all-requests';

  static const String apiDriverJob = '$baseUrl/driver/get-jobs';
  static const String apiAppliedJob = '$baseUrl/driver/applied-job';
  static const String apiApplyToJob = '$baseUrl/driver/apply-to-job';
  static const String apiAllRecvdReq = '$baseUrl/driver/requests';
  static const String apiAllRespond = '$baseUrl/driver/respond';

  static const String apiNewsAll = '$baseUrl/news-all';
  static const String apiNews = '$baseUrl/news';
}
