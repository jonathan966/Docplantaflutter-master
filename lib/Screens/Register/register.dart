import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxlogin/Constants/auth_constans.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Docplanta"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/docplanta.png",
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 10),
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
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    bool signUpResult = await authController.emailRegister(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (!signUpResult) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Correo ya registrado. Prueba con otro.'),
                        ),
                      );
                    }
                  },
                  child: Text("Sign Up"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool loginResult = await authController.emailLogin(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (!loginResult) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Contraseña incorrecta. Inténtalo de nuevo.'),
                        ),
                      );
                    }
                  },
                  child: Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}