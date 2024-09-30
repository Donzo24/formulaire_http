import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulaire_http/database.dart';
import 'package:formulaire_http/entity/tache.dart';
import 'package:formulaire_http/models/utilisateur.dart';
import 'package:formulaire_http/screens/login_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.database});
  
  AppDatabase database;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // List<Utilisateur> users = [];

  // List<Tache> taches = [];


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // _getUser();

    // getTaches();
  }

  // _getUser() async {

  //   getUsers().then((data) {
  //       setState(() {
  //           users = data;
  //       });
  //   });      
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("GPS"),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                getPosition();
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addUser();

           // Check mic permission (also called during record)
          // await controller.pause();                                  // Pause recording
          // final path = await controller.stop(); 
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: widget.database.tacheDao.findAllTaches(), 
        builder: (context, snapshot) {

          if(!snapshot.hasData) {
            return SizedBox();
          }

          List<Tache> taches = snapshot.data!;
          
          return ListView.builder(
                itemCount: taches.length,
                itemBuilder: (context, index) {

                  Tache tache = taches[index];

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Dismissible(
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {}, 
                            icon: const Icon(Icons.edit)
                          ),
                          IconButton(
                            onPressed: () {}, 
                            icon: const Icon(Icons.delete)
                          )
                        ],
                      ),
                      onDismissed: (direction) {

                        if(direction == DismissDirection.startToEnd) {
                          //Edition
                          print("Edit");
                          
                        } else if(direction == DismissDirection.endToStart) {
                          //Supression
                          // deleteUser(user: user);
                        }

                      },
                      confirmDismiss: (direction) async {
                        bool resultat = await Get.dialog(
                            CupertinoAlertDialog(
                              title: const Text("Confirmation"),
                              content: Text("Merci de confirmer la suppression de l'utisation?"),
                              actions: [

                                TextButton(
                                  onPressed: () {
                                    Get.back(result: false);
                                  }, 
                                  child: const Text("NON"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back(result: true);
                                  },
                                  child: const Text("OUI"),
                                )
                              ],
                            ),
                            barrierDismissible: false
                          );

                          return resultat;
                      },
                      key: UniqueKey(),
                      child: Card(
                        child: ListTile(
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(
                          //     user.avatar
                          //   ),
                          // ),
                          title: Text(tache.title),
                          subtitle: Text(tache.description),
                          trailing: SizedBox(
                            height: 100,
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // addUser(
                                    //   user: user
                                    // );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,color: Colors.red),
                                  onPressed: () {
                                    // confirmDeleteUser(user: user);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
        },
      )
    );
  }
  
  Future<void> addUser({Tache? tache}) async {
    var formKey = GlobalKey<FormBuilderState>();

    XFile? image;
    String imagePath = "";

    await Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height/1.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
              )
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [

                      //Circle avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: image != null ? FileImage(File(imagePath)):null,
                        child: image == null ? const Icon(Icons.person):null,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () async {

                            image = await takeImage();
                            setState(() {
                              imagePath = image!.path;
                            });

                          },
                          child: Text("Prendre une photo"),
                        ),
                      ),

                      createTextForm(
                        value: tache?.title,
                        name: "titre",
                        label: "Titre",
                        validator: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.alphabetical()
                        ]
                      ),
                      createTextForm(
                        value: tache?.description,
                        name: "description",
                        label: "Description",
                        validator: [
                          FormBuilderValidators.required(),
                        ]
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: const Text("Enregistrer"),
                          onPressed: () async {
                            if(formKey.currentState!.saveAndValidate()) {
                              var data = formKey.currentState!.value;

                              // print(data);

                              var tache = Tache(title: data['titre'], description: data['description']);

                              await widget.database.tacheDao.insertTache(tache);
                              formKey.currentState!.reset();
                              this.setState(() {});
                              // getTaches();

                              // print("Succes");
          
                              // print(data);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              )
            ),
        );
        },
      )
    );
  }
  
  createTextForm({required String name, required String label, dynamic validator, required dynamic value}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FormBuilderTextField(
        name: name,
        initialValue: value,
        validator: FormBuilderValidators.compose(validator),
        decoration: InputDecoration(
          labelText: label
        ),
      ),
    );
  }
  
  Future<void> confirmDeleteUser({required Utilisateur user}) async {
    var resultat = await Get.dialog(
      CupertinoAlertDialog(
        title: const Text("Confirmation"),
        content: Text("Merci de confirmer la suppression de l'utisation ${user.firstName} ?"),
        actions: [

          TextButton(
            onPressed: () {
              Get.back(result: false);
            }, 
            child: const Text("NON"),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text("OUI"),
          )
        ],
      ),
      barrierDismissible: false
    );
    
    if(resultat == true) {
      deleteUser(user: user);
    }
  }
  
  Future<void> deleteUser({required Utilisateur user}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse("https://reqres.in/api/users/${user.id}")
      );

      if(response.statusCode == 204) {
        Get.snackbar(
          "Succes", 
          "Utilisateur suprimer avec succes",
          backgroundColor: Colors.green
        );
        setState(() {});
      } else {

      }
    } catch (e) {
      
    }
  }
  
  Future<XFile?> takeImage() async {

    ImagePicker picker = ImagePicker();
    XFile? image;

    await Get.bottomSheet(
      CupertinoActionSheet(
        title: Text("Selectionner une source"),
        message: Text("Source"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              image = await picker.pickImage(source: ImageSource.camera);
              Get.back();
            }, 
            child: Text("Camera")
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              image = await picker.pickImage(source: ImageSource.gallery);
              Get.back();
            }, 
            child: Text("Galery")
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back();
          },
          child: Text("Annuler"),
        ),

      )
    );

    return image;
  }
  
  Future<void> getPosition() async {

    SmartDialog.showLoading(
      msg: "Patienter..."
    );

    bool locationServiceStatus = await Geolocator.isLocationServiceEnabled();

    if(!locationServiceStatus) {
      Get.snackbar("Erreur GPS", "Merci d'activer la geolocalisation");
      return;
    }

    await Geolocator.requestPermission();

    var permision = await Geolocator.checkPermission();
    

    if(permision == LocationPermission.denied) {
      Get.snackbar("Erreur GPS", "Meci d'autoriser");
      await Geolocator.openAppSettings();
    }

    //Recuperer la position
    Position position = await Geolocator.getCurrentPosition();

    SmartDialog.dismiss();

    openMap(position: position);

  }
  
  Future<void> openMap({required Position position}) async {
    await Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height/1.5,
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14
            ),
            onMapCreated: (controller) {
              
            },

          ),
        ),
      )
    );
  }

  
}