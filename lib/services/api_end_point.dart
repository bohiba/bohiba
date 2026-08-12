import 'package:bohiba/config/app_config.dart';

class ApiEndPoint {
  static String get baseUrl => AppConfig.baseUrl;

  static const String apiPostalCode = 'https://api.postalpincode.in/pincode';

  static String get apiVerifyEmail => '$baseUrl/authentication/verify-email';
  static String get apiVerifyOtp => '$baseUrl/authentication/verify-otp';
  static String get apiResendOtp => '$baseUrl/authentication/resend-otp';
  static String get apiUpdatePassword =>
      '$baseUrl/authentication/update-password';
  static String get apiCreateUser => '$baseUrl/authentication/create-user';
  static String get apiAddAddress => '$baseUrl/add-address';
  static String get apiSetProfileImage => '$baseUrl/set-profile-image';
  static String get apiSetRole => '$baseUrl/set-role';
  static String get apiEditDoc => '$baseUrl/add-document';
  static String get apiEditUser => '$baseUrl/user-update';

  static String get apiForgotPassword =>
      '$baseUrl/authentication/forgot-password';
  static String get apiResetPassword =>
      '$baseUrl/authentication/reset-password';
  static String get apiVerifyForgotPasswordOtp =>
      '$baseUrl/authentication/verify-forgot-password-otp';
  static String get apiForgotUUID => '$baseUrl/authentication/forgot-uuid';

  static String get apiLogin => '$baseUrl/authentication/login';
  static String get apiLogout => '$baseUrl/logout';
  static String get apiRefreshToken => '$baseUrl/refresh-token';

  static String get firbaseToken => '$baseUrl/firebase/register-token';

  static String get apiProfile => '$baseUrl/profile';
  static String get apiMain => '$baseUrl/main';

  static String get apiLocations => '$baseUrl/locations';

  static String get apiCompanies => '$baseUrl/companies';
  static String apiCompaniesPaged(int page, int perPage) =>
      '$apiCompanies?page=$page&per_page=$perPage';
  static String get apiSearchCompany => '$apiCompanies/search';
  static String get apiSearchMines => '$apiCompanies/search/mines';
  static String get apiSearchPlants => '$apiCompanies/search/plants';
  static String get apiSearchTransporters => '$apiCompanies/search/transporter';

  static String get apiFavourite => '$baseUrl/favourite';

  static String get apiTrucks => '$baseUrl/trucks';
  static String get apiGetTruck => '$apiTrucks/info';
  static String get apiSetTruckImage => '$apiTrucks/set-image';
  static String get apiRemoveTruckImage => '$apiTrucks/remove-image';
  static String get apiAssignDriver => '$apiTrucks/assign-driver';
  static String get apiRemoveDriver => '$apiTrucks/remove-driver';

  static String get apiAnalytic => '$baseUrl/analytics';
  static String get apiAnalyticSummary => '$apiAnalytic/summary';
  static String get apiAnalyticTrips => '$apiAnalytic/trips';
  static String get apiAnalyticFuel => '$apiAnalytic/fuel';
  static String get apiAnalyticDriver => '$apiAnalytic/drivers';
  static String get apiAnalyticTruck => '$apiAnalytic/trucks';
  static String get apiAnalyticFinance => '$apiAnalytic/finance';

  static String get apiDriver => '$baseUrl/drivers';

  static String get apiRateDriver => '$baseUrl/rate-user';
  static String get apiGetRating => '$baseUrl/all-rating';
  static String get apiDeleteRating => '$baseUrl/delete-rating';

  static String get apiTrips => '$baseUrl/trips';

  static String get apiTripPayment => '$apiTrips/payments';

  static String get apiAddTripExpense => '$baseUrl/trip/add-expenses';
  static String get apiEditTripExpense => '$baseUrl/trip/update-expenses';
  static String get apiDeleteTripExpense => '$baseUrl/trip/delete-expenses';

  static String get apiTripReassign => '$apiTrips/reassignments';
  static String get apiEditTripReassign => '$apiTrips/update-reassignment';
  static String get apiDeleteTripReassign => '$apiTrips/delete-reassignment';

  static String get apiTripDoc => '$apiTrips/documents';

  static String get addOwnerExpense => '$baseUrl/add-expense';
  static String get allOwnerExpense => '$baseUrl/all-expense';
  static String get apiGetOwnerExpense => '$baseUrl/get-expense';
  static String get editOwnerExpense => '$baseUrl/post-expense';
  static String get deleteOwnerExpense => '$baseUrl/delete-expense';

  static String get apiAllJobs => '$baseUrl/owner/job-posted';
  static String get apiCreateJobs => '$baseUrl/owner/job-create';
  static String get apiGetJob => '$baseUrl/owner/job-detail';
  static String get apiApplicants => '$baseUrl/owner/job-applicants';
  static String get apiEditJob => '$baseUrl/owner/job-update';
  static String get apiDeleteJob => '$baseUrl/owner/job-delete';

  static String get apiOpenDriver => '$baseUrl/owner/open';
  static String get apiViewDriver => '$baseUrl/owner/view-driver';
  static String get apiSendConnectReq => '$baseUrl/owner/send';
  static String get apiAllSentReq => '$baseUrl/owner/all-requests';

  static String get apiDriverJob => '$baseUrl/driver/get-jobs';
  static String get apiAppliedJob => '$baseUrl/driver/applied-job';
  static String get apiApplyToJob => '$baseUrl/driver/apply-to-job';
  static String get apiAllRecvdReq => '$baseUrl/driver/requests';
  static String get apiAllRespond => '$baseUrl/driver/respond';

  static String get apiNewsAll => '$baseUrl/news-all';
  static String get apiNews => '$baseUrl/news';

  static String get apiSearchUser => '$baseUrl/search/user';

  static String get apiBankAccounts => '$baseUrl/bank/accounts';

  // Owner Company — role_id=6 only; one company per owner (BR-01)
  static String get apiOwnerCompany => '$baseUrl/companies/owner';
  static String get apiOwnerCompanyLogo => '$apiOwnerCompany/logo';
  static String get apiOwnerCompanyAddress => '$apiOwnerCompany/address';
  static String get apiOwnerCompanyContacts => '$apiOwnerCompany/contacts';
  static String apiOwnerCompanyContact(int id) =>
      '$apiOwnerCompanyContacts/$id';
  // BR-09: write-once endpoint — POST only, no PUT/DELETE
  static String get apiOwnerCompanyLegal => '$apiOwnerCompany/legal';

  static String get apiTripReport => '$baseUrl/report';
  static String get apiTripReportFilter => '$apiTripReport/filter';
  static String get apiTripReportGenerate => '$apiTripReport/generate';

  static String get apiTickets => '$baseUrl/tickets';

  // Google Maps
  static const String apiNearbySearch =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
}
