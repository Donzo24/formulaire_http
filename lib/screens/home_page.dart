import 'package:flutter/material.dart';
import 'package:formulaire_http/models/utilisateur.dart';
import 'package:formulaire_http/screens/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GetStorage storage = GetStorage();

          await storage.remove("token");

          Get.offAll(() => LoginPage());
        },
        child: Icon(Icons.logout),
      ),
      body: FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasData) {

              List<Utilisateur> users = snapshot.data!;

              return ListView.builder(
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
                          onPressed: () => true,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}