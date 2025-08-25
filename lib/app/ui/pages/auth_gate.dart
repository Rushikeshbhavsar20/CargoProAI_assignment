import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'login_page.dart';
import 'home_page.dart';

class AuthGate extends GetWidget<AuthController> {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
        () => controller.user.value == null ? LoginPage() : const HomePage());
  }
}
