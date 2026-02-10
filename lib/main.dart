import 'package:cripto_din/pages/login/login_page.dart';
import 'package:flutter/material.dart';
//plug-in principal do Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//inicializando firebase no projeto
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }
}
