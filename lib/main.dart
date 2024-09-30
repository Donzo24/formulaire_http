import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:formulaire_http/database.dart';
import 'package:formulaire_http/entity/tache.dart';
import 'package:formulaire_http/screens/audio_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  await database.tacheDao.insertTache(Tache(1, "Tahe 1", "hsjjjsl"));

  List<Tache> taches = await database.tacheDao.findAllTaches();

  print(taches);

    
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
      home: AudioPage(),
      builder: FlutterSmartDialog.init(),
      navigatorObservers: [
        FlutterSmartDialog.observer
      ],
    );
  }
}