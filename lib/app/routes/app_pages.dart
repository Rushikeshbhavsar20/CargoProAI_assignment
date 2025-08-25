import 'package:get/get.dart';
import '../ui/pages/login_page.dart';
import '../ui/pages/otp_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/detail_page.dart';
import '../ui/pages/edit_page.dart';
import 'auth_guard.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(name: Routes.login, page: () => LoginPage()),
    GetPage(name: Routes.otp, page: () => const OtpPage()),
    GetPage(
        name: Routes.home,
        page: () => const HomePage(),
        middlewares: [AuthGuard()]),
    GetPage(
        name: Routes.detail,
        page: () => const DetailPage(),
        middlewares: [AuthGuard()]),
    GetPage(
        name: Routes.edit,
        page: () => const EditPage(),
        middlewares: [AuthGuard()]),
  ];
}
