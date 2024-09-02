import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulaire_http/models/utilisateur.dart';
import 'package:formulaire_http/screens/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  Utilisateur user = users[index];

                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            user.avatar
                          ),
                        ),
                        title: Text("${user.firstName} ${user.lastName}"),
                        subtitle: Text(user.email),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            addUser(
                              user: user
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              )
    );
  }
  
  Future<void> addUser({Utilisateur? user}) async {
    var _formKey = GlobalKey<FormBuilderState>();
    await Get.bottomSheet(
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height/1.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
          )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
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
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Enregistrer"),
                      onPressed: () async {
                        if(_formKey.currentState!.saveAndValidate()) {
                          var data = _formKey.currentState!.value;

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
      )
    );
  }
  
  createTextForm({required String name, required String label, dynamic validator, required dynamic value}) {
    return Padding(
      padding: EdgeInsets.all(10),
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
}