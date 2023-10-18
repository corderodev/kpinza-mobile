import 'package:flutter/material.dart';
import 'package:kpinza_mobile/screens/MainScreen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();

  bool _isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isSignIn ? 'Inicio de sesión' : 'Registro de cuenta',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            if (!_isSignIn)
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(labelText: 'Alias'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isSignIn) {
                  final email = _emailController.text;
                  final password = _passwordController.text;

                  if (email == 'admin' && password == 'admin') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Credenciales incorrectas. Por favor, intenta de nuevo.',
                      ),
                    ));
                  }
                } else {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                }
              },
              child: Text(_isSignIn ? 'Iniciar Sesión' : 'Registrar Cuenta'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignIn = !_isSignIn;
                });
              },
              child: Text(_isSignIn
                  ? '¿No tienes una cuenta? Regístrate aquí'
                  : '¿Ya tienes una cuenta? Inicia sesión aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
