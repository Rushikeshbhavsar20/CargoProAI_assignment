import 'package:cargoproai/app/controllers/auth_controller.dart';
import 'package:cargoproai/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final codeCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isVerifying = false.obs;

  AuthController get auth => Get.find<AuthController>();

  Future<void> verify() async {
    final code = codeCtrl.text.trim();
    if (code.length != 6) {
      Get.snackbar('Invalid code', 'Enter exactly 6 digits');
      return;
    }

    isVerifying.value = true;
    try {
      final ok = await auth.verifyOtp(code);
      if (ok && auth.user.value != null) {
        Get.offAllNamed(Routes.home);
      }
    } finally {
      isVerifying.value = false;
    }
  }

  @override
  void onClose() {
    codeCtrl.dispose();
    super.onClose();
  }
}
