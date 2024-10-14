import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulaire_http/database.dart';
import 'package:formulaire_http/db.dart';
import 'package:formulaire_http/entity/classe.dart';
import 'package:formulaire_http/entity/eleve.dart';
import 'package:formulaire_http/screens/classe/add_classe.dart';
import 'package:get/get.dart';

class ClassePage extends StatefulWidget {
  const ClassePage({super.key, required this.database});
  final AppDatabase database;

  @override
  State<ClassePage> createState() => _ClassePageState();
}

class _ClassePageState extends State<ClassePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
        title: Text("Gestion des classes"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Get.to(() => AddClasse(database: widget.database));
        }
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: database.classeDao.findAllStream(), 
          builder: (context, snapshot) {

              if(snapshot.hasData) {
                List<Classe> classes = snapshot.data as List<Classe>;

                return ListView(
                  children: classes.map((classe) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        child: ListTile(
                          title: Text(classe.nom),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                            onPressed: () {
                              openEditModal(classe: classe);
                            },
                            icon: Icon(Icons.edit),
                          ),
                             IconButton(
                            onPressed: () {
                              deleteclasse(classe: classe);
                            },
                            icon: Icon(Icons.delete),
                          ),
                              ],
                            ),
                          )
                        ),
                      ),
                    );
                  }).toList(),
                );
              }

              return SizedBox();
          },
        )
      ),
    );
  }
  
  Future<void> openEditModal({required Classe classe}) async {

    var formKey = GlobalKey<FormBuilderState>();
    
    await Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        height: 200,
        width: double.infinity,
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: FormBuilderTextField(
                    name: "nom",
                    initialValue: classe.nom,
                    decoration: const InputDecoration(
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

                        Classe update = Classe(classe.id, value['nom']);

                        await widget.database.classeDao.updateClasse(update);

                        formKey.currentState!.reset();
                        Get.back();
                        SmartDialog.showToast("Classe modifier avec succes");
                      }
                    },
                    child: const Text("Modifier"),
                  )
                )
            ],
          ),
        ),
      )
    );
  }
  
  void deleteclasse({required Classe classe}) async {

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
      title: Text("Suppression"),
      content: Text("Voulez-vous supprimer cette classe ?"),
      actions: [
        TextButton(
                  onPressed: () async {
                    await widget.database.classeDao.deleteClasse(classe);
                    Get.back();
                  }, 
                  child: Text("OUI")
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: Text("NON")
          )
      ],
    );
      },
    );
    
    // Get.dialog(
    //   Container(
    //     child: Column(
    //       children: [
    //         Text("Voulez-vous supprimer cette classe ?"),
    //         Row(
    //           children: [
    //             TextButton(
    //               onPressed: () {

    //               }, 
    //               child: Text("OUI")
    //             ),
    //             TextButton(
    //               onPressed: () {

    //               }, 
    //               child: Text("NON")
    //             )
    //           ],
    //         )
    //       ],
    //     ),
    //   )
    // );

      // await widget.database.classeDao.deleteClasse(classe);

  }
}