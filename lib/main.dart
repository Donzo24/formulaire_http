import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:formulaire_http/screens/file_picker.dart';
import 'package:formulaire_http/screens/home_page.dart';
import 'package:formulaire_http/screens/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {

  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  GetStorage session = GetStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: session.hasData('token') ? const FilePickerPage():const LoginPage(),
      builder: FlutterSmartDialog.init(),
      navigatorObservers: [
        FlutterSmartDialog.observer
      ],
    );
  }
}