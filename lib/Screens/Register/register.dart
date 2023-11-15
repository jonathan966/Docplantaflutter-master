import 'package:getxlogin/Constants/auth_constans.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Docplanta"),backgroundColor: Colors.green, centerTitle: true),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente.
        children: [
          Image.asset("assets/images/docplanta.png", width: 100, height: 100), // Ajusta el tamaño según tus necesidades
          TextField(
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.grey),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _emailController,
            style: TextStyle(color: Colors.black),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Contraseña",
              hintStyle: TextStyle(color: Colors.grey),
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 30),
          Center( // Envuelve los botones en un widget Center para centrarlos horizontalmente.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los botones en la fila.
              children: [
                ElevatedButton(
                  onPressed: () async {
                    authController.emailRegister(
                      _emailController.text, _passwordController.text,
                    );
                  },
                  child: Text("sign up"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    authController.emailLogin(
                      _emailController.text, _passwordController.text,
                    );
                  },
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
