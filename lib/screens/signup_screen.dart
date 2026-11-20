import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  String? _emailError;
  String? _passError;
  String? _confirmError;

  // B2: validaciones
  bool _isValidEmail(String email) =>
      email.endsWith('@tecdesoftware.edu.mx') &&
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);

  bool _isValidPassword(String pass) =>
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$')
          .hasMatch(pass);

  // B3: registro en Firebase
  Future<void> _onRegister() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    setState(() {
      _emailError = _isValidEmail(email)
          ? null
          : 'Usa tu correo institucional (@tecdesoftware.edu.mx)';
      _passError = _isValidPassword(pass)
          ? null
          : 'No cumple las reglas de la contraseña';
      _confirmError = confirm == pass ? null : 'Las contraseñas no coinciden';
    });

    if (_emailError != null || _passError != null || _confirmError != null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada. Ahora inicia sesión.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      final msg = e is FirebaseAuthException
          ? (e.message ?? 'No se pudo crear la cuenta')
          : 'No se pudo crear la cuenta';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo institucional',
                helperText: 'Debe terminar en @tecdesoftware.edu.mx',
                errorText: _emailError,
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                helperText:
                    'Mínimo 8 caracteres, mayúscula, minúscula, número y símbolo',
                helperMaxLines: 2,
                errorText: _passError,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmCtrl,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                errorText: _confirmError,
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onRegister,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Registrarme'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}