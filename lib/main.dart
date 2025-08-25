import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/theme/app_theme.dart';
import 'app/controllers/auth_controller.dart';
import 'app/controllers/object_controller.dart';
import 'app/data/services/api_service.dart';
import 'app/routes/app_pages.dart';
import 'app/ui/pages/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CargoProAi',
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
        Get.put(ObjectController(ApiService()), permanent: true);
      }),
    );
  }
}
