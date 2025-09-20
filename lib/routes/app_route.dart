import 'package:bohiba/bindings/security_binding.dart';

import '/bindings/setting_binding.dart';
import '/pages/security/security_page.dart';
import '/pages/setting/setting_page.dart';
import '/pages/share/share_earn_page.dart';
import '/pages/support/contact_support_page.dart';
import '/pages/support/privacy_policy_page.dart';
import '/pages/support/report_issue.dart';

import '/bindings/reassignment_binding.dart';
import '/pages/trips/reassignment_page.dart';

import '/bindings/trip_add_reassign_binding.dart';
import '/bindings/trip_expense_binding.dart';
import '/pages/trips/trip_expense_page.dart';

import '/bindings/fav_binding.dart';
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
import '/pages/driver/rating_page.dart';
import '/pages/driver/work_calender_detail.dart';

import '/bindings/trip_all_binding.dart';
import '/bindings/mines_binding.dart';
import '/bindings/auth_binding.dart';
import '/bindings/driver_binding.dart';
import '/bindings/navbar_binding.dart';
import '/bindings/truck_all_binding.dart';
import '/bindings/dasboard_binding.dart';
import '/bindings/master_binding.dart';
import '/bindings/splash_binding.dart';
import '/bindings/user_profile_congif_binding.dart';

import '/pages/dashboard/dash_page/dashboard_page.dart';
import '/pages/mines/all_mines_page.dart';
import '/pages/truck/truck_edit_page.dart';
import '/pages/user/user_profile/user_profile_screen/user_profile.dart';
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
import '/pages/authentication/password_screen/set_password.dart';
import '/pages/authentication/signup_screen/create_user.dart';
import '/pages/user_authentication/screens/set_image_page.dart';
import '/pages/driver/driver_all_page.dart';
import '/pages/driver/driver_add_page.dart';
import '/pages/driver/driver_page.dart';
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
import '/pages/news/news_screen.dart';
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
  static const String setPwd = "/set-pwd";
  static const String forgotScreen = "/forgot-password";

  // Status-sub Screen
  static const String viewChallan = "/view-challan";

  // User Auth Screen
  static const String userAddressAuthScreen = "/user-address-auth";
  static const String userAuthScreen = "/user-auth-screen";
  static const String userBankAuthScreen = "/user-bank-auth";
  // static const String userDocAuthScreen = "/user-doc-auth";
  static const String imageAuth = "/image-auth";

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
  static const String workCalender = "/work-calender";
  static const String allRating = '/all-rating';
  static const String rating = '/rating';

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
  static const String homeScreen = "/home";
  static const String dashboardScreen = "/dashboard";
  static const String loadHistoryScreen = "/load-history";
  static const String setting = "/setting";
  static const String security = "/security";
  static const String shareEarn = "/shareEarn";
  static const String policy = "/policy";
  static const String contact = "/contact";
  static const String reportIssue = "/reportIssue";
  static const String about = "/about";

  static const String newsScreen = "/news";
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

  static final List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      bindings: [
        SplashBinding(),
        MasterBinding(),
      ],
      page: () => const SplashScreen(),
    ),

    // Auth
    GetPage(
      name: signIn,
      binding: AuthBinding(),
      bindings: [
        MasterBinding(),
      ],
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: signUp,
      binding: SignupBinding(),
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: otpScreen,
      binding: AuthBinding(),
      page: () => const OtpScreen(),
    ),
    GetPage(
      name: createUser,
      binding: AuthBinding(),
      page: () => const CreateUserPage(),
    ),

    GetPage(
      name: forgotScreen,
      binding: AuthBinding(),
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: setPwd,
      binding: AuthBinding(),
      page: () => const ResetSetPasswordPage(),
    ),

    GetPage(
      name: userAuthScreen,
      binding: UserProfileConfigBinding(),
      page: () => const UserDocAuthPage(),
    ),
    GetPage(
      name: imageAuth,
      binding: UserProfileConfigBinding(),
      page: () => const SetImagePage(),
    ),
    GetPage(
      name: roleType,
      binding: UserProfileConfigBinding(),
      page: () => const SetRolePage(),
    ),
    GetPage(
      name: userAddressAuthScreen,
      binding: UserProfileConfigBinding(),
      page: () => const AddressAuthPage(),
    ),

    // Main
    GetPage(
      name: navBar,
      binding: NavBarBinding(),
      page: () => const BohibaNavBar(),
    ),
    GetPage(
      name: dashboardScreen,
      bindings: [
        AuthBinding(),
        DasboardBinding(),
      ],
      page: () => const DashboardPage(),
    ),

    GetPage(name: loadHistoryScreen, page: () => const AllTripPage()),
    GetPage(name: allMines, page: () => const AllMinesPage()),
    GetPage(name: newsScreen, page: () => const NewsScreen()),
    GetPage(name: notifyScreen, page: () => const NotificationScreen()),

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
      name: rating,
      // binding: DriverBinding(),
      page: () => RatingPage(),
    ),

    // Manager
    GetPage(
      name: manager,
      page: () => const ManagerPage(),
    ),
    GetPage(
      name: allManager,
      page: () => const AllManagerPage(),
    ),
    GetPage(
      name: addManager,
      page: () => const AddManagerPage(),
    ),

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

    GetPage(
      name: trips,
      binding: TripBinding(),
      page: () => const TripPage(),
    ),

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
    GetPage(
      name: mines,
      binding: MinesBinding(),
      page: () => MinesPage(),
    ),
    GetPage(
      name: viewChallan,
      page: () => const ChallanScreen(),
    ),
    GetPage(
      name: orderScreen,
      page: () => const OrderScreen(),
    ),

    // Wallet
    GetPage(name: walletScreen, page: () => const WalletScreen()),
    GetPage(name: walletDepositScreen, page: () => const WalletDepositScreen()),

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
      binding: FavBinding(),
      page: () => const FavouritePage(),
    ),

    // DASHBOARD
    GetPage(
      name: userProfile,
      page: () => UserProfilePage(),
    ),

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
      page: () => ShareEarnPage(),
    ),

    GetPage(
      name: policy,
      page: () => PolicyPage(),
    ),
    GetPage(
      name: contact,
      page: () => ContactSupportPage(),
    ),
    GetPage(
      name: reportIssue,
      page: () => ReportIssuePage(),
    ),
  ];
}
