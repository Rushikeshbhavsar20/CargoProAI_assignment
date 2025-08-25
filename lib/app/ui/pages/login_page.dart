import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../controllers/login_controller.dart';
import '../../ui/widgets/common.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LoginController()); // instead of Get.find()

    return GradientScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            color: Colors.black.withOpacity(0.3),
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: c.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text('Welcome 👋',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    const Text('Sign in with your phone number'),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Phone (+CountryCode)',
                      controller: c.phoneCtrl,
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]'))
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(() => PrimaryButton(
                          text: c.isSending.value ? 'Sending...' : 'Send OTP',
                          onPressed: c.isSending.value ? () {} : c.submit,
                        )),
                    const SizedBox(height: 8),
                    const Text(
                      'On web, you may see reCAPTCHA depending on settings.',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
