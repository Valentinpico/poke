import 'package:flutter/material.dart';
import './screens/Login/Login.dart'; // Asegúrate de que LoginPage esté en un archivo separado llamado login_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App pokemon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Aquí cambiamos a LoginPage
    );
  }
}
