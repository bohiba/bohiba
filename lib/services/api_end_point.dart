class ApiEndPoint {
  // static const String baseUrl = 'https://bohiba.com/api';
  static const String baseUrl = "https://beta-server-t1.bohiba.com/api";
  static const String apiPostalCode = 'https://api.postalpincode.in/pincode';
  static const String apiVerifyEmail = '$baseUrl/authentication/verify-email';
  static const String apiVerifyOtp = '$baseUrl/authentication/verify-otp';
  static const String apiResendOtp = '$baseUrl/authentication/resend-otp';
  static const String apiUpdatePassword =
      '$baseUrl/authentication/update-password';
  static const String apiCreateUser = '$baseUrl/authentication/create-user';
  static const String apiAddAddress = '$baseUrl/add-address';
  static const String apiSetProfileImage = '$baseUrl/set-profile-image';
  static const String apiSetRole = '$baseUrl/set-role';
  static const String apiEditDoc = '$baseUrl/add-document';
  static const String apiEditUser = '$baseUrl/user-update';

  static const String apiForgotPassword =
      '$baseUrl/authentication/forgot-password';
  static const String apiResetPassword =
      '$baseUrl/authentication/reset-password';
  static const String apiVerifyForgotPasswordOtp =
      '$baseUrl/authentication/verify-forgot-password-otp';

  static const String apiLogin = '$baseUrl/authentication/login';
  static const String apiLogout = '$baseUrl/logout';
  static const String apiRefreshToken = '$baseUrl/refresh-token';

  static const String firbaseToken = '$baseUrl/firebase/register-token';

  static const String apiProfile = '$baseUrl/profile';
  static const String apiMain = '$baseUrl/main';

  static const String apiCompanies = '$baseUrl/companies';
  static const String apiSearchCompany = '$apiCompanies/search';

  static const String apiAllFav = '$baseUrl/all-favourite';
  static const String apiAddFav = '$baseUrl/add-favourite';
  static const String apiDeleteFav = '$baseUrl//delete-favourite';

  static const String apiTrucks = '$baseUrl/trucks';
  static const String apiGetTruck = '$apiTrucks/info';
  static const String apiSetTruckImage = '$apiTrucks/set-image';
  static const String apiRemoveTruckImage = '$apiTrucks/remove-image';
  static const String apiAssignDriver = '$apiTrucks/assign-driver';
  static const String apiRemoveDriver = '$apiTrucks/remove-driver';

  static const String apiAnalytic = '$baseUrl/analytics';
  static const String apiAnalyticSummary = '$apiAnalytic/summary';
  static const String apiAnalyticTrips = '$apiAnalytic/trips';
  static const String apiAnalyticFuel = '$apiAnalytic/fuel';
  static const String apiAnalyticDriver = '$apiAnalytic/drivers';
  static const String apiAnalyticTruck = '$apiAnalytic/trucks';
  static const String apiAnalyticFinance = '$apiAnalytic/finance';

  static const String apiDriver = '$baseUrl/drivers';

  static const String apiRateDriver = '$baseUrl/rate-user';
  static const String apiGetRating = '$baseUrl/all-rating';
  static const String apiDeleteRating = '$baseUrl/delete-rating';

  static const String apiTrips = '$baseUrl/trips';

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

  static const String apiAddTripDoc = '$baseUrl/trip/add-document';
  static const String apiGetAllTripDoc = '$baseUrl/trip/all-document';
  static const String apiGetTripDoc = '$baseUrl/trip/get-document';

  static const String addOwnerExpense = '$baseUrl/add-expense';
  static const String allOwnerExpense = '$baseUrl/all-expense';
  static const String apiGetOwnerExpense = '$baseUrl/get-expense';
  static const String editOwnerExpense = '$baseUrl/post-expense';
  static const String deleteOwnerExpense = '$baseUrl/delete-expense';

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

  static const String apiSearchUser = '$baseUrl/search/user';

  // Google Maps
  static const String apiNearbySearch =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
}
