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

Future<String> veriflogin(String email, mdp) async {
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

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class LoginPage extends StatelessWidget {
  static final emailController = TextEditingController();
  static final mdpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

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
                      hintText: 'Veuillez entrez votre mot de passe',
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
                        var token = veriflogin(
                            emailController.text, mdpController.text);
                        print('TOKEN : $token');
                        print('TOKEN : ${token.toString()}');
                        if (token.toString().isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            '/second',
                          );
                        }
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
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => LoginPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => SecondRoute(),
      },
    );
  }
}

Future<void> getApi() async {
  String email = LoginPage.emailController.text;
  String mdp = LoginPage.mdpController.text;
  var token = veriflogin(email, mdp);
  var url = Uri.http('192.168.1.12:8000', '/api/etudiants');
  final response = await http.get(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  print('Body : ${response.body}');
  print('Status : ${response.statusCode}');
  print('Headers : ${response.headers}');
  print('Request : ${response.request}');
  var data = jsonDecode(response.body);

  return data;
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion Réussie'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Connexion réussie ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            Text(veriflogin(LoginPage.emailController.text, LoginPage.mdpController.text).then(String result){
              setState(() {
                tokenn = result;
              });
            }),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Retour")),
          ],
        ),
      ),
    );
  }
}
