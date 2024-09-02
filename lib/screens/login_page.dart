import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formulaire_http/screens/home_page.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: FormBuilderTextField(
                name: "email",
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.mail)
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: FormBuilderTextField(
                name: "password",
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  prefixIcon: Icon(Icons.lock
                  )
                ),
              ),

            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  // if()
                  if(_formKey.currentState!.saveAndValidate()) {
                    login(data: _formKey.currentState!.value);
                  }
                  // login();
                },
                child: Text("Connexion")
              ),
            )
          ],
        ),
      ),
    );
  }
  
  void login({required Map data}) async {

    http.Response response = await http.post(Uri.parse("https://reqres.in/api/login"), body: data);

    if(response.statusCode == 200) {
      var token = jsonDecode(response.body);
      //Stocker le jeton en local
      GetStorage session = GetStorage();
      session.write("token", token['token']);

      Get.offAll(() => HomePage());
    } else {
      //Erreur
      Get.snackbar(
        "Identifiant invalide", 
        "Email ou mot de passe invalide",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red
      );
    }

    print(response.statusCode);
    print(response.body);
    
  }
}