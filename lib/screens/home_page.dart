import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulaire_http/models/utilisateur.dart';
import 'package:formulaire_http/screens/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<Utilisateur> users = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _getUser();
  }

  _getUser() async {

    getUsers().then((data) {
        setState(() {
            users = data;
        });
    });      
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addUser();
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  Utilisateur user = users[index];

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
                          deleteUser(user: user);
                        }

                      },
                      confirmDismiss: (direction) async {
                        bool resultat = await Get.dialog(
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

                          return resultat;
                      },
                      key: UniqueKey(),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.avatar
                            ),
                          ),
                          title: Text("${user.firstName} ${user.lastName}"),
                          subtitle: Text(user.email),
                          trailing: SizedBox(
                            height: 100,
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    addUser(
                                      user: user
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,color: Colors.red),
                                  onPressed: () {
                                    confirmDeleteUser(user: user);
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
              )
    );
  }
  
  Future<void> addUser({Utilisateur? user}) async {
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
                        value: user?.firstName,
                        name: "name",
                        label: "Prenom",
                        validator: [
                          FormBuilderValidators.required(),
                          // FormBuilderValidators.min(2),
                          FormBuilderValidators.alphabetical()
                        ]
                      ),
                      createTextForm(
                        value: user?.firstName,
                        name: "job",
                        label: "Job",
                        validator: [
                          FormBuilderValidators.required(),
                          // FormBuilderValidators.min(2)
                        ]
                      ),
                      createTextForm(
                        value: user?.email,
                        name: "email",
                        label: "Email",
                        validator: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email()
                        ]
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: const Text("Enregistrer"),
                          onPressed: () async {
                            if(formKey.currentState!.saveAndValidate()) {
                              var data = formKey.currentState!.value;
          
                              if(user != null) {
                                //Update
                              } else {
                                //Ajout
                              }
          
                              http.Response response = await http.post(
                                Uri.parse("https://reqres.in/api/users"),
                                body: data
                              );
          
                              if(response.statusCode == 201) {
                                print(response.body);
                                var data = jsonDecode(response.body);
          
                                data['first_name'] = data['name'];
                                data['id'] = int.parse(data['id']);
                                data['last_name'] = data['name'];
                                data['avatar'] = "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png";
          
                                Utilisateur user = Utilisateur.fromJson(data);
          
                                setState(() {
                                  users.add(user);
                                });
          
                                Get.back();
          
                              } else {
                                Get.snackbar(
                                  "Une erreur s'est produit", 
                                  "Une erreur s'est produit"
                                );
                              }
          
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

  
}