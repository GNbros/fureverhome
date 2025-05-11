import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fureverhome/firebase_options.dart';
import 'package:fureverhome/pages/login/login.dart';
import 'package:fureverhome/services/database_service.dart';

Future<void> main() async {
  // Ensure that all Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the database (this will ensure the database is ready before the app starts)
  await DatabaseHelper().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Login(),
    );
  }
}