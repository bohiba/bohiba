import '/bindings/all_recived_request_binding.dart';

import '/pages/jobs/driver/all_received_request_page.dart';

import '/bindings/all_applied_job_binding.dart';
import 'package:bohiba/bindings/change_password_binding.dart';
import 'package:bohiba/pages/jobs/driver/all_applied_job.dart';

import '/bindings/all_driver_job_binding.dart';
import '/pages/jobs/driver/all_driver_job.dart';

import '/pages/driver/driver_modals/driver_rating_page.dart';
import '/pages/welcome.dart';

import '/bindings/open_driver_binding.dart';
import '/pages/driver/open_driver_page.dart';

import '/bindings/news_binding.dart';
import '/bindings/owner_expense_binding.dart';
import '/pages/news/news_screen.dart';

import '/bindings/all_news_binding.dart';
import '/bindings/forgot_uuid_binding.dart';
import '/bindings/home_binding.dart';
import '/pages/news/all_news_screen.dart';

import '/bindings/address_auth_binding.dart';
import '/bindings/create_user_binding.dart';
import '/bindings/set_role_binding.dart';

import '/bindings/all_sent_connection_binding.dart';
import '/bindings/forgot_password_binding.dart';
import '/bindings/otp_binding.dart';

import '/pages/authentication/password_screen/forgot_uuid_page.dart';
import '/pages/jobs/owner/all_sent_request_page.dart';
import '/pages/expenses/add_owner_expenses_screen.dart';

import '/bindings/analytic_binding.dart';
import '/pages/analytic/analytic_page.dart';

import '/bindings/update_contact_binding.dart';
import '/pages/user/user_profile/update_contact_info_page.dart';

import '/pages/jobs/owner/add_jobs_page.dart';
import '/pages/jobs/job_detail_page.dart';
import '/pages/jobs/owner/all_job_page.dart';

import '/bindings/all_job_binding.dart';
import '/bindings/add_job_binding.dart';
import '/bindings/job_detail_binding.dart';
import '/bindings/security_binding.dart';

import '/bindings/setting_binding.dart';
import '/pages/security/security_page.dart';
import '/pages/setting/setting_page.dart';

import '/bindings/share_binding.dart';
import '/pages/share/share_earn_page.dart';

import '/pages/support/contact_support_page.dart';
import '/pages/support/privacy_policy_page.dart';
import '/pages/support/report_issue.dart';

import '/bindings/reassignment_binding.dart';
import '/pages/trips/reassignment_page.dart';

import '/bindings/trip_add_reassign_binding.dart';
import '/bindings/trip_expense_binding.dart';
import '/pages/trips/trip_expense_page.dart';

import '/bindings/trip_payment_binding.dart';
import '/pages/trips/add_reassignment_page.dart';
import '/pages/trips/trip_payment_page.dart';

import '/bindings/trip_payment_add_binding.dart';

import '/bindings/trip_expense_add_binding.dart';
import '/pages/trips/add_payment_page.dart';

import '/bindings/trip_binding.dart';
import '/bindings/trip_add_binding.dart';
import '/pages/trips/add_expense_page.dart';

import '/bindings/driver_add_binding.dart';
import '/bindings/driver_all_binding.dart';
import '/bindings/signup_binding.dart';
import '/bindings/truck_binding.dart';
import '/bindings/truck_edit_binding.dart';
import '/pages/driver/rating_all_page.dart';
import '/pages/driver/work_calender_detail.dart';

import '/bindings/trip_all_binding.dart';
import '/bindings/mines_binding.dart';
import '/bindings/auth_binding.dart';
import '/bindings/driver_binding.dart';
import '/bindings/truck_all_binding.dart';
import '/bindings/dasboard_binding.dart';
import '/bindings/splash_binding.dart';
import '/bindings/user_profile_congif_binding.dart';

import '/pages/dashboard/dash_page/dashboard_page.dart';
import '/pages/mines/all_mines_page.dart';
import '/pages/truck/truck_edit_page.dart';
import '/pages/user/user_profile/user_profile_screen/user_profile_page.dart';
import '/pages/user/user_kyc/kyc_screen.dart';
import '/pages/user/user_profile/edit_user_profile_screen.dart';
import 'package:get/get.dart';
import '/pages/mines/mines_page.dart';
import '/pages/favourite/favourite_page.dart';
import '/pages/manager/add_manager.dart';
import '/pages/manager/manager.dart';
import '/pages/truck/truck_page.dart';
import '/pages/manager/all_manager.dart';
import '/pages/user_authentication/screens/set_role_page.dart';
import '../pages/authentication/password_screen/change_password_page.dart';
import '/pages/authentication/signup_screen/create_user_page.dart';
import '/pages/user_authentication/screens/set_image_page.dart';
import '/pages/driver/driver_all_page.dart';
import '/pages/driver/driver_add_page.dart';
import '/pages/driver/driver_page.dart';
import '/bindings/doc_auth_binding.dart';
import '/pages/user_authentication/screens/user_doc_auth_page.dart';
import '/pages/user_authentication/screens/address_auth_page.dart';
import '/component/bohiba_navbar/bohiba_navbar.dart';
import '/pages/authentication/password_screen/forgot_password.dart';
import '/pages/authentication/otp_screen/otp_screen.dart';
import '/pages/authentication/signin_screen/signin_screen.dart';
import '/pages/authentication/signup_screen/signup_screen.dart';
import '/pages/challan/page/challan_screen.dart';
import '/pages/trips/trip_add_page.dart';
import '/pages/trips/trip_all_page.dart';
import '/pages/trips/trip_page.dart';

import '/pages/notification/notify_screen/notification_screen.dart';
import '/pages/order/screens/order_screen/order_screen.dart';
import '/pages/splashscreen.dart';
import '/pages/truck/truck_all_page.dart';
import '/pages/wallet/wallet_deposit/wallet_deposit_screen.dart';
import '/pages/wallet/wallet_screen/wallet_screen.dart';
import '/pages/info/info_screen.dart';
import '/pages/truck/truck_add_page.dart';

class AppRoute {
  // Auth Screen Strings
  static const String splashScreen = "/splash";
  static const String signUp = "/signup";
  static const String createUser = "/email-verify";
  static const String signIn = "/signin";
  static const String otpScreen = "/otp";
  static const String changePwd = "/change-pwd";
  static const String forgotPwd = "/forgot-password";
  static const String forgotUuid = "/forgot-uuid";

  // Status-sub Screen
  static const String viewChallan = "/view-challan";

  // User Auth Screen
  static const String userAddressAuthScreen = "/user-address-auth";
  static const String userAuthScreen = "/user-auth-screen";
  // static const String userBankAuthScreen = "/user-bank-auth";
  // static const String userDocAuthScreen = "/user-doc-auth";
  static const String imageAuth = "/image-auth";
  static const String updateContact = "/update-contact";
  static const String roleType = "/role-type";

  // NavBar
  static const String navBar = "/nav-bar";
  static const String favList = '/favList';

  // Vehicle
  static const String truck = "/vehicle";
  static const String addTruck = "/add-vehicle";
  static const String allTruck = "/all-vehicle";
  static const String editTruck = '/edit-truck';

  // Driver
  static const String allDriver = "/all-driver";
  static const String addDriver = "/add-driver";
  static const String driver = "/driver";

  static const String openDriver = "/open-driver";

  static const String workCalender = "/work-calender";
  static const String allRating = '/all-rating';
  static const String allSentReq = '/all-sent-req';

  static const String ratingDriver = '/rate-driver';

  static const String allRcvdRequest = '/all-rcvd-request';

  //Manager
  static const String manager = "/manger";
  static const String allManager = "/all-manager";
  static const String addManager = "/add-manager";

  // Trips
  static const String trips = "/trip";
  static const String allTrip = "/all-trip";
  static const String addTrip = "/add-trip";
  static const String addExpense = '/add-expense';
  static const String addPayment = '/add-payment';
  static const String addReassignment = '/add-reassign';
  static const String reassignment = '/reassign';

  static const String payment = '/payment';
  static const String expense = '/expense';

  // Main pages String
  // static const String homeScreen = "/home";
  static const String dashboardScreen = "/dashboard";
  static const String loadHistoryScreen = "/load-history";
  static const String analytics = "/analytics";
  static const String setting = "/setting";
  static const String security = "/security";
  static const String shareEarn = "/shareEarn";
  static const String policy = "/policy";
  static const String contact = "/contact";
  static const String reportIssue = "/reportIssue";
  static const String about = "/about";
  static const String addOwnerExpense = "/add-owner-expense";

  static const String allNewsScreen = "/all-news";
  static const String newsScreen = "/snews";
  static const String notifyScreen = "/notify";
  static const String orderScreen = "/order";
  static const String statusScreen = "/status";
  static const String walletScreen = "/wallet";

  // Wallet Screen
  static const String bankAccountScreen = "/bank-account";
  static const String walletDepositScreen = "/wallet-deposit";
  static const String walletTransactionHistoryScreen =
      "/wallet-transcation-history";
  static const String walletWithdrawScreen = "/wallet-withdraw";

  // static const String companyScreen = "/company";
  static const String infoScreen = "/info-screen";
  static const String allMines = "/all-mines";
  static const String mines = '/mines';

  // DASHBOARD
  static const String userProfile = '/user-profile';
  static const String editProfile = '/edit-profile';
  static const String kyc = '/kyc';

  static const String allJobs = '/all-jobs';
  static const String addJobs = '/add-jobs';
  static const String jobDetail = '/my-job-details';

  static const String allDriverJob = '/all-driver-job';
  static const String allAppliedJob = '/driver/applied-job';

  //TODO - It should be removed
  static const String welcome = '/welcome';

  static final List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      binding: SplashBinding(),
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: welcome,
      page: () => const WelcomeSceen(),
    ),
    // Auth
    GetPage(
      name: signIn,
      binding: AuthBinding(),
      page: () => const SignInScreen(),
    ),

    GetPage(
      name: signUp,
      binding: SignupBinding(),
      page: () => const SignupScreen(),
    ),

    GetPage(
      name: otpScreen,
      binding: OtpBinding(),
      page: () => const OtpScreen(),
    ),

    GetPage(
      name: createUser,
      binding: CreateUserBinding(),
      page: () => const CreateUserPage(),
    ),

    GetPage(
      name: addOwnerExpense,
      binding: OwnerExpenseBinding(),
      page: () => const AddOwnerExpensesScreen(),
    ),

    GetPage(
      name: forgotPwd,
      binding: ForgotPasswordBinding(),
      page: () => const ForgotPasswordPage(),
    ),

    GetPage(
      name: forgotUuid,
      binding: ForgotUuidBinding(),
      page: () => const ForgotUuidPage(),
    ),

    GetPage(
      binding: UpdateContactBinding(),
      name: updateContact,
      page: () => const UpdateContactInfoPage(),
    ),

    GetPage(
      name: changePwd,
      binding: ChangePasswordBinding(),
      page: () => const ChangePasswordPage(),
    ),

    GetPage(
      name: userAuthScreen,
      binding: DocAuthBinding(),
      page: () => const UserDocAuthPage(),
    ),

    GetPage(
      name: imageAuth,
      binding: UserProfileConfigBinding(),
      page: () => const SetImagePage(),
    ),

    GetPage(
      name: roleType,
      binding: SetRoleBinding(),
      page: () => const SetRolePage(),
    ),

    GetPage(
      name: userAddressAuthScreen,
      binding: AddressAuthBinding(),
      page: () => const AddressAuthPage(),
    ),

    // Main
    GetPage(
      name: navBar,
      // binding: MasterBinding(),
      bindings: [
        HomeBinding(),
        AllTripBinding(),
        AllDriverJobBinding(),
        DasboardBinding(),
      ],
      page: () => const BohibaNavBar(),
    ),

    GetPage(
      name: dashboardScreen,
      bindings: [AuthBinding(), DasboardBinding()],
      page: () => const DashboardPage(),
    ),

    GetPage(
      binding: AnalyticBinding(),
      name: analytics,
      page: () => AnalyticPage(),
    ),

    GetPage(
      name: loadHistoryScreen,
      page: () => const AllTripPage(),
    ),
    GetPage(
      name: allMines,
      binding: MinesBinding(),
      page: () => const AllMinesPage(),
    ),
    GetPage(
      name: allNewsScreen,
      binding: AllNewsBinding(),
      page: () => const AllNewsScreen(),
    ),
    GetPage(
      name: newsScreen,
      binding: NewsBinding(),
      page: () => const NewsScreen(),
    ),
    GetPage(
      name: notifyScreen,
      page: () => const NotificationScreen(),
    ),

    /*
     ====================================
     ||             Driver             ||
     ====================================
     */
    GetPage(
      name: driver,
      binding: DriverBinding(),
      page: () => DriverPage(),
    ),
    GetPage(
      name: allDriver,
      binding: DriverAllBinding(),
      page: () => const DriverAllPage(),
    ),

    GetPage(
      name: addDriver,
      binding: DriverAddBinding(),
      page: () => DriverAddPage(),
    ),

    GetPage(
      name: openDriver,
      binding: OpenDriverBinding(),
      page: () => OpenDriverPage(),
    ),

    GetPage(
      name: workCalender,
      // binding: DriverBinding(),
      page: () => WorkCalendarPage(),
    ),

    GetPage(
      name: allRating,
      binding: DriverBinding(),
      page: () => RatingAllPage(),
    ),

    GetPage(
      name: allSentReq,
      binding: AllSentRequestBinding(),
      page: () => AllSentRequestPage(),
    ),

    GetPage(
      name: ratingDriver,
      // binding: DriverBinding(),
      page: () => DriverRatingPage(),
    ),

    // Manager
    GetPage(name: manager, page: () => const ManagerPage()),
    GetPage(name: allManager, page: () => const AllManagerPage()),
    GetPage(name: addManager, page: () => const AddManagerPage()),

    // Truck
    GetPage(
      name: truck,
      binding: TruckBinding(),
      page: () => const TruckPage(),
    ),

    GetPage(
      name: allTruck,
      binding: TruckAllBinding(),
      page: () => const AllTruckPage(),
    ),

    GetPage(
      name: addTruck,
      binding: TruckAllBinding(),
      page: () => const AddTruckPage(),
    ),

    GetPage(
      name: editTruck,
      binding: TruckEditBinding(),
      page: () => TruckEditPage(),
    ),

    // Trips
    GetPage(
      name: allTrip,
      binding: AllTripBinding(),
      page: () => const AllTripPage(),
    ),

    GetPage(
      name: addTrip,
      binding: TripAddBinding(),
      page: () => const AddTripPage(),
    ),

    GetPage(
      binding: TripExpenseAddBinding(),
      name: addExpense,
      page: () => AddExpensePage(),
    ),

    GetPage(
      binding: TripExpenseBinding(),
      name: expense,
      page: () => TripExpensePage(),
    ),

    GetPage(
      binding: AddTripPaymentBinding(),
      name: addPayment,
      page: () => AddPaymentPage(),
    ),

    GetPage(
      name: payment,
      binding: TripPaymentBinding(),
      page: () => TripPaymentPage(),
    ),

    GetPage(name: trips, binding: TripBinding(), page: () => const TripPage()),

    GetPage(
      binding: TripAddReassignBinding(),
      name: addReassignment,
      page: () => AddReassignementPage(),
    ),

    // ReassignmentBinding
    GetPage(
      binding: ReassignmentBinding(),
      name: reassignment,
      page: () => ReassignmentPage(),
    ),

    // Mines
    GetPage(name: mines, binding: MinesBinding(), page: () => MinesPage()),
    GetPage(name: viewChallan, page: () => const ChallanScreen()),
    GetPage(name: orderScreen, page: () => const OrderScreen()),

    // Wallet
    GetPage(
      name: walletScreen,
      page: () => const WalletScreen(),
    ),
    GetPage(
      name: walletDepositScreen,
      page: () => const WalletDepositScreen(),
    ),

    // Others
    GetPage(
      name: kyc,
      page: () => KYCScreen(),
    ),
    GetPage(
      name: infoScreen,
      page: () => const InfoScreen(),
    ),
    GetPage(
      name: favList,
      page: () => const FavouritePage(),
    ),

    // DASHBOARD
    GetPage(name: userProfile, page: () => UserProfilePage()),

    GetPage(
      name: editProfile,
      binding: DasboardBinding(),
      page: () => EditUserProfilePage(),
    ),
    GetPage(
      name: setting,
      binding: SettingBinding(),
      page: () => SettingPage(),
    ),
    GetPage(
      name: security,
      binding: SecurityBinding(),
      page: () => SecurityPage(),
    ),
    GetPage(
      name: shareEarn,
      binding: ShareBinding(),
      page: () => ShareEarnPage(),
    ),

    GetPage(name: policy, page: () => PolicyPage()),
    GetPage(name: contact, page: () => ContactSupportPage()),
    GetPage(name: reportIssue, page: () => ReportIssuePage()),

    GetPage(binding: AllJobBinding(), name: allJobs, page: () => AllJobPage()),

    GetPage(binding: AddJobBinding(), name: addJobs, page: () => AddJobsPage()),

    GetPage(
      binding: JobDetailBinding(),
      name: jobDetail,
      page: () => JobDetailPage(),
    ),

    GetPage(
      name: allDriverJob,
      binding: AllDriverJobBinding(),
      page: () => AllDriverJobPage(),
    ),

    GetPage(
      name: allAppliedJob,
      binding: AllAppliedJobBinding(),
      page: () => AllAppliedJobPage(),
    ),

    GetPage(
      name: allRcvdRequest,
      binding: AllRecivedRequestBinding(),
      page: () => AllReceivedRequestPage(),
    ),
  ];
}
