import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_pages.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null && route != Routes.login && route != Routes.otp) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}
