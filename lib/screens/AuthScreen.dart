import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kpinza_mobile/screens/MainScreen.dart';
import 'package:kpinza_mobile/utils/firebase_utils.dart';
import 'package:kpinza_mobile/class/User.dart';

class UserGlobal {
  static String? uid;
}

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

  Future<void> _authenticate() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      if (_isSignIn) {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        UserGlobal.uid = userCredential.user!.uid;
      } else {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseUtils.saveUser(AppUser(
          uid: userCredential.user!.uid,
          email: email,
          alias: _aliasController.text,
        ));

        UserGlobal.uid = userCredential.user!.uid;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/logo_kpinza.png',
                  height: 100,
                  width: 100,
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(20)),
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
              onPressed: _authenticate,
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
