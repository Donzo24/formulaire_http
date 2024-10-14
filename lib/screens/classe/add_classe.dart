import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulaire_http/database.dart';
import 'package:formulaire_http/entity/classe.dart';

class AddClasse extends StatefulWidget {
  const AddClasse({super.key, required this.database});
  final AppDatabase database;

  @override
  State<AddClasse> createState() => _AddClasseState();
}

class _AddClasseState extends State<AddClasse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var formKey = GlobalKey<FormBuilderState>();

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
      appBar: AppBar(
        title: Text("Creer une classe"),
      ),
      body: SafeArea(
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: FormBuilderTextField(
                  name: "nom",
                  decoration: InputDecoration(
                    labelText: "Nom de la classe"
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required()
                  ]),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {

                    if(formKey.currentState!.saveAndValidate()) {

                      var value = formKey.currentState!.value;
                      print(value);

                      Classe classe = Classe(null, value['nom']);

                      await widget.database.classeDao.addClasse(classe);

                      formKey.currentState!.reset();
                      SmartDialog.showToast("Classe creer avec succes");
                    }
                  },
                  child: Text("Enregsister"),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}