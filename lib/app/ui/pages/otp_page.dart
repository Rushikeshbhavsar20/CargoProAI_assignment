import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../controllers/otp_controller.dart';
import '../widgets/common.dart';
import 'package:flutter/services.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(OtpController());
    return GradientScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            color: Colors.black.withValues(alpha: 0.3),
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
                    Text('Enter OTP',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: '6-digit Code',
                      controller: c.codeCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v ?? '').trim().length == 6
                          ? null
                          : 'Enter 6 digits',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(() => PrimaryButton(
                          text: c.isVerifying.value ? 'Verifying...' : 'Verify',
                          onPressed: c.isVerifying.value ? () {} : c.verify,
                        )),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Edit phone number'),
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
