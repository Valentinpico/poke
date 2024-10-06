import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/Login/login.dart';
import 'screens/Register/register.dart';
import 'screens/Home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Pokémon',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.blueGrey[400],
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[400],
        ),
      ),
      home: FutureBuilder<String?>(
        future: SharedPreferences.getInstance().then((prefs) {
          return prefs.getString('auth_token');
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: Text("Cargando...")));
          }
          if (snapshot.hasError) {
            return const Scaffold(
                body: Center(child: Text('Error al obtener el token')));
          }
          final token = snapshot.data;
          return token != null ? HomePage() : const LoginPage();
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
