import 'dart:convert';

import 'package:http/http.dart' as http;

class Utilisateur {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;

  Utilisateur({required this.id, required this.firstName, required this.avatar, required this.lastName, required this.email});

  factory Utilisateur.fromJson(json) {
    return Utilisateur(
      id: json['id'], 
      firstName: json['first_name'], 
      avatar: json['avatar'], 
      lastName: json['last_name'], 
      email: json['email']
    );
  }
}

Future<List<Utilisateur>> getUsers() async {
  List<Utilisateur> users = [];

  http.Response response = await http.get(Uri.parse("https://reqres.in/api/users?page=1"));
  if(response.statusCode == 200) {
    var data = jsonDecode(response.body);

    List json = data['data'] as List;

    users = json.map((user) {
      return Utilisateur.fromJson(user);
    }).toList();
  }

  return users;
}