import 'package:flutter/material.dart';
import 'views/home/home_page.dart'; // make sure this path exists

void main() {
  runApp(const FurEverApp());
}

class FurEverApp extends StatelessWidget {
  const FurEverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FurEver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
