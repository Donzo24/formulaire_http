import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formulaire_http/database.dart';
import 'package:formulaire_http/screens/classe/classe_page.dart';
import 'package:get/get.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage>
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
        title: Text("Gestion ecole"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            createMenuItem(
              title: "Eleves",
              icon: Icons.person,
              onTap: () {

              }
            ),
            createMenuItem(
              title: "Classes",
              icon: Icons.home,
              onTap: () {
                Get.back();
                Get.to(() => ClassePage(database: widget.database));
              }
            ),
            createMenuItem(
              title: "Cours",
              icon: Icons.home,
              onTap: () {
                
              }
            ),
            createMenuItem(
              title: "Professeurs",
              icon: Icons.person_2_sharp,
              onTap: () {
                
              }
            )
          ],
        ),
      ),
      body: SizedBox(),
    );
  }
  
  createMenuItem({required String title, required IconData icon, void Function()? onTap}) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: ListTile(
        dense: false,
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        leading: Icon(icon),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}