import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

//control para mostrar la contraseña/ocultar la contraseña
   bool _isObsure = true;

  @override
  Widget build(BuildContext context) {
    // Obtiene el tamaño de la pantalla
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox( //contine la animacion de Rive
                width: screenSize.width,
                height: 200,
                child: const RiveAnimation.asset('assets/login-bear-animation.riv'),
              ),
              //para separar el RiveAnimation del resto de los elementos
              SizedBox(height: 10),
              // texfield es para elegir el tipo de teclado
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //contraseña
              TextField(
                obscureText: _isObsure,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObsure ? Icons.visibility : Icons.visibility_off),//icono para mostrar la contraseña
                    onPressed: () {
                      //Para refrescar el icono
                      setState(() {
                        _isObsure = !_isObsure;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}