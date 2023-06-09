import 'dart:convert';

import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class LoginPage extends StatelessWidget {

  final emailController = TextEditingController();
  final mdpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  Future<String> veriflogin() async {
    var email = emailController.text;
    var mdp = mdpController.text;
    var url = Uri.http('192.168.1.12:8000', '/api/login');
    final response = await http.post(url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({
          "username": "$email",
          "password": "$mdp",
        }));
    print('Body : ${response.body}');
    print('Status : ${response.statusCode}');
    print('Headers : ${response.headers}');
    print('Request : ${response.request}');
    var data = jsonDecode(response.body);
    var token = data['token'];

    return token;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test JSON'),
        ),
        body: Center(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Se Connecter',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Veuillez entrez un email valide",
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre mail',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: mdpController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrez votre mot de passe';
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var token = veriflogin();
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) => const SecondRoute()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      ),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}


class _MyAppState extends State<MyApp> {
  var _data = '';
  var _json = '';

 /*Future<void> fetchData() async {
    var url = Uri.http('192.168.1.12:8000', '/api/etudiants');
    final response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print('Body : ${response.body}');
    print('Status : ${response.statusCode}');
    print('Headers : ${response.headers}');
    print('Request : ${response.request}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _data = data.toString();
        _json = jsonEncode(data);
      });
    } else {
      setState(() {
        _data = 'Failed to load data';
        _json = 'Erreur';
      });
    }
  } */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage()
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Se Connecter ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
      ),
    );
  }
}
