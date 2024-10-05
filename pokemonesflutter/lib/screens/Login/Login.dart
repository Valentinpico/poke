// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../utils/Validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    final url = Uri.parse(
        'http://192.168.0.121:3000/api/user/login'); // Cambia la URL a tu endpoint
    final body = jsonEncode({
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['token'];
        // decode tokem jwt y sacar el id del usuario

        // guardar el id del usuario en shared preferences
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', token);

        final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final userId = decodedToken['userId'];
        print(userId);
        await prefs.setString('userId', userId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al iniciar sesión')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Inicio de sesión')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            children: [
              const Text('Ingresa con tu email y contraseña'),
              const SizedBox(height: 18),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateEmail(value),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) => Validators.validatePassword(value),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                child: Text(_isLoading ? 'Cargando' : 'Iniciar Sesión'),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () {
                  _emailController.clear();
                  _passwordController.clear();
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ));
  }
}
