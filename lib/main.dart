import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:formulaire_http/database.dart';
import 'package:formulaire_http/db.dart';
import 'package:formulaire_http/screens/audio_page.dart';
import 'package:formulaire_http/screens/home/school_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final db = await $FloorAppDatabase.databaseBuilder('gestion_ecole.db').build();

  database = db;

  // await database.tacheDao.insertTache(Tache(1, "Tahe 1", "hsjjjsl"));

  // List<Tache> taches = await database.tacheDao.findAllTaches();

  // print(taches);
    
  await GetStorage.init();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.database});

  GetStorage session = GetStorage();

  AppDatabase database;

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
      home: SchoolPage(database: database),
      builder: FlutterSmartDialog.init(),
      navigatorObservers: [
        FlutterSmartDialog.observer
      ],
    );
  }
}