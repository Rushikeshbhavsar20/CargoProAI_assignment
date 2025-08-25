import 'dart:convert';
import 'package:flutter/services.dart';

class Validators {
  static String? phone(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'Phone is required';
    final digits =
        raw.replaceFirst(RegExp(r'^\+'), '').replaceAll(RegExp(r'[^0-9]'), '');
    if (!raw.startsWith('+')) return 'Start with + and country code';
    if (digits.length < 10 || digits.length > 15)
      return 'Enter 10–15 digits after +';
    return null;
  }

  static String? notEmpty(String? value, {String field = 'Field'}) {
    if ((value ?? '').trim().isEmpty) return '$field is required';
    return null;
  }

  static String? jsonText(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'JSON is required';
    try {
      jsonDecode(v);
    } catch (_) {
      return 'Enter valid JSON';
    }
    return null;
  }

  static String? dataFlexible(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Data is required';
    return null;
  }

  // ✅ Strict: must be VALID JSON OBJECT (starts { ... })
  static String? jsonObject(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Data is required';
    try {
      final decoded = jsonDecode(v);
      if (decoded is! Map<String, dynamic>) {
        return 'Enter a JSON object (must start with { and end with })';
      }
    } catch (_) {
      return 'Enter valid JSON (use double quotes for keys/strings)';
    }
    return null;
  }
}

final plusDigitsFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]'));
