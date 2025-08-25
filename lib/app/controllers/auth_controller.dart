import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> user = Rxn<User>();
  String? _verificationId;
  ConfirmationResult? _webConfirmation;

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    _auth.authStateChanges().listen((u) => user.value = u);
  }

  Future<void> sendOtp(String phone) async {
    final raw = phone.trim();
    final sanitized =
        '+${raw.replaceFirst(RegExp(r'^\+'), '').replaceAll(RegExp(r'[^0-9]'), '')}';
    if (!raw.startsWith('+') ||
        sanitized.length < 10 ||
        sanitized.length > 16) {
      Get.snackbar('Error', 'Use +<country><number>, e.g. +919876543210');
      return;
    }
    try {
      if (kIsWeb) {
        _webConfirmation = await _auth.signInWithPhoneNumber(sanitized);
        return;
      }
      await _auth.verifyPhoneNumber(
        phoneNumber: sanitized,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (cred) async {
          await _auth.signInWithCredential(cred);
        },
        verificationFailed: (e) {
          debugPrint(
              'verifyPhoneNumber failed: code=${e.code}, msg=${e.message}');
          Get.snackbar('Error', e.message ?? 'Verification failed');
        },
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<bool> verifyOtp(String smsCode) async {
    try {
      if (kIsWeb) {
        final cred = await _webConfirmation!.confirm(smsCode);
        user.value = cred.user;
      } else {
        final cred = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: smsCode,
        );
        await _auth.signInWithCredential(cred);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Invalid code', e.message ?? 'Try again');
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  Future<void> logout() async => _auth.signOut();
}
