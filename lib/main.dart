import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<User> fetchUser() async {
  final response = await http.get(
    'http://192.168.1.102:3000/users/me',
    headers: {
      HttpHeaders
          .authorizationHeader: "Bearer t6MUQkL19O05RBUpUIHIse1nG5WOu95EXc7JU1jKBHq"
    },
  );

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return User.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class User {
  final String id;
  final String cpf;
  final String firstName;
  final String lastName;

  User({this.id, this.cpf, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'],
        cpf: json['cpf'],
        firstName: json['firstName'],
        lastName: json['lastName']
    );
  }
}

void main() => runApp(MyApp(user: fetchUser()));

class MyApp extends StatelessWidget {
  final Future<User> user;

  MyApp({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTitle = 'App Cash';

    return MaterialApp(
        title: appTitle,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Pop Cash'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<User>(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.firstName);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner
                  return CircularProgressIndicator();
                },
              ),
            )
        ),
    );
  }
}

/*
class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pop Cash'),
      ),
      body: _buildHomePage(),
    );
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.firstName);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      ),
    );
  }
}*/
