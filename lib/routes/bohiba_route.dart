import 'package:bohiba/utils/bohiba_navbar/bohiba_navbar.dart';
import 'package:bohiba/pages/authentication/forgot_screen/forgot_password.dart';
import 'package:bohiba/pages/authentication/otp_screen/otp_screen.dart';
import 'package:bohiba/pages/authentication/signin_screen/signin_screen.dart';
import 'package:bohiba/pages/company/company_screen/company_screen.dart';
import 'package:bohiba/pages/dashboard/dash_screen/dashboard_screen.dart';
import 'package:bohiba/pages/load/screen/add_load_screen.dart';
import 'package:bohiba/pages/load/screen/all_load_screen.dart';
import 'package:bohiba/pages/load/screen/load_screen.dart';
import 'package:bohiba/pages/load_history/load_history_screen/load_history_screen.dart';
import 'package:bohiba/pages/market/market_component/market_card/market_card.dart';
import 'package:bohiba/pages/market/market_screen/market_screen.dart';
import 'package:bohiba/pages/news/news_screen.dart';
import 'package:bohiba/pages/notification/notify_screen/notification_screen.dart';
import 'package:bohiba/pages/order/screens/order_screen/order_screen.dart';
import 'package:bohiba/pages/splashscreen.dart';
import 'package:bohiba/pages/status/tabs/complete_status/screen/challan_screen/challan_screen.dart';
import 'package:bohiba/pages/user_authentication/screens/user_auth_screen/user_auth_screen.dart';
import 'package:bohiba/pages/vehicle/all_vechile_screen/all_vehicle_screen.dart';
import 'package:get/get.dart';

import '../pages/authentication/signup_screen/signup_screen.dart';

class BohibaRoute {
  // Auth Screen Strings
  static const String splashScreen = "/splash";
  static const String signUp = "/signup";
  static const String signIn = "/signin";
  static const String otpScreen = "/otp";
  static const String forgotScreen = "/forgot-password";

  // Status-sub Screen
  static const String viewChallan = "/view-challan";

  // User Auth Screen
  static const String userAddressAuthScreen = "/user-address-auth";
  static const String userAuthScreen = "/user-auth-screen";
  static const String userBankAuthScreen = "/user-bank-auth";
  static const String userDocAuthScreen = "/user-doc-auth";

  // NavBar
  static const String navBar = "/nav-bar";

  // Vechile pages Strings
  static const String addVehicle = "/add-vehicle";

  // Main pages String
  static const String homeScreen = "/home";
  static const String dashboardScreen = "/dashboard";
  static const String loadHistoryScreen = "/load-history";
  static const String marketScreen = "/market";
  static const String newsScreen = "/news";
  static const String notifyScreen = "/notify";
  static const String orderScreen = "/order";
  static const String statusScreen = "/status";
  static const String walletScreen = "/wallet";

  // Load Screen
  static const String addLoadScreen = "/add-load";
  static const String allLoadScreen = "/all-screen";
  static const String loadScreen = "/load-screen";

  // Wallet Screen
  static const String bankAccountScreen = "/bank-account";
  static const String walletDepositScreen = "/wallet-deposit";
  static const String walletTransactionHistoryScreen =
      "/wallet-transcation-history";
  static const String walletWithdrawScreen = "/wallet-withdraw";

  // Other's
  static const String marketCard = "/market-card";
  static const String companyScreen = "/company";

  static List<GetPage> pages = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: signIn,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: signUp,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: otpScreen,
      page: () => const OtpScreen(),
    ),
    GetPage(
      name: forgotScreen,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: navBar,
      page: () => const BohibaNavBar(),
    ),
    GetPage(
      name: dashboardScreen,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: loadHistoryScreen,
      page: () => const LoadHistoryScreen(),
    ),
    GetPage(
      name: marketScreen,
      page: () => const MarketPage(),
    ),
    GetPage(
      name: newsScreen,
      page: () => const NewsScreen(),
    ),
    GetPage(
      name: notifyScreen,
      page: () => const NotificationScreen(),
    ),
    GetPage(
      name: addVehicle,
      page: () => const AllVehicleScreen(),
    ),
    GetPage(
      name: orderScreen,
      page: () => const OrderScreen(),
    ),
    GetPage(
      name: marketCard,
      page: () => const MarketHorizonCard(),
    ),
    GetPage(
      name: companyScreen,
      page: () => const CompanyScreen(),
    ),
    GetPage(
      name: userAuthScreen,
      page: () => const UserAuthScreen(),
    ),
    GetPage(
      name: viewChallan,
      page: () => const ChallanScreen(),
    ),
    GetPage(
      name: allLoadScreen,
      page: () => const AllLoadScreen(),
    ),
    GetPage(
      name: addLoadScreen,
      page: () => const AddLoadScreen(),
    ),
    GetPage(
      name: loadScreen,
      page: () => const LoadScreen(),
    )
  ];
}
