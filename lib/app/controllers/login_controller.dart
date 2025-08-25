import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

import '../routes/app_pages.dart';

class LoginController extends GetxController {
  final phoneCtrl = TextEditingController(text: '+91');
  final formKey = GlobalKey<FormState>();
  final isSending = false.obs;

  AuthController get auth => Get.find<AuthController>();

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isSending.value = true;
    try {
      await auth.sendOtp(phoneCtrl.text.trim());
      Get.toNamed(Routes.otp);
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    super.onClose();
  }
}
