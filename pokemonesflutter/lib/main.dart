import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/Login/Login.dart';
import './screens/Register/Register.dart';
import './screens/Home/Home.dart';
import './screens/Favoritos/FavoritosPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Debug print
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Pokémon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
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
          print('Token: $token'); // Debug print
          return token != null ? HomePage() : const LoginPage();
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => HomePage(),
        '/favorites': (context) => const FavoritePage(),
      },
    );
  }
}
