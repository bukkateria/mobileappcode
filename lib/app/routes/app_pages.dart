import 'package:bukateria/app/modules/dashboard/views/vendor_dashboard.dart';
import 'package:bukateria/app/modules/splash/bindings/splash_binding.dart';
import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/favourites/bindings/favourites_binding.dart';
import '../modules/favourites/views/favourites_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/menus/bindings/menus_binding.dart';
import '../modules/menus/views/menus_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/profiles/bindings/profiles_binding.dart';
import '../modules/profiles/views/profiles_view.dart';
import '../modules/recipes/bindings/recipes_binding.dart';
import '../modules/recipes/views/recipes_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/vlog/bindings/vlog_binding.dart';
import '../modules/vlog/views/vlog_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;
  static const USER_DASHBOARD = Routes.DASHBOARD;
  static const VENDOR_DASHBOARD = Routes.VENDOR_DASHBOARD;
  static const REGISTER_VIEW = Routes.REGISTER;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.VENDOR_DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.RECIPES,
      page: () => const RecipesView(),
      binding: RecipesBinding(),
    ),
    GetPage(
      name: _Paths.MENUS,
      page: () => MenusView(),
      binding: MenusBinding(),
    ),
    GetPage(
      name: _Paths.PROFILES,
      page: () => ProfilesView(),
      binding: ProfilesBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => const HistoryWidget(),
      binding: OrdersBinding(),
    ),
    // GetPage(
    //   name: _Paths.ACCOUNT,
    //   page: () => const AccountPageWidget(),
    //   binding: AccountBinding(),
    // ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentWidget(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.VLOG,
      page: () => const VlogView(),
      binding: VlogBinding(),
    ),
    GetPage(
      name: _Paths.FAVOURITES,
      page: () => FavouritesView(),
      binding: FavouritesBinding(),
    ),
  ];
}
