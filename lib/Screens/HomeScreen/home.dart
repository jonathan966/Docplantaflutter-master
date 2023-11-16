import 'package:flutter/material.dart';
import 'package:getxlogin/Constants/auth_constans.dart';

import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio"),backgroundColor: Colors.green, centerTitle: true),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.ac_unit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThirdPage()),
                  );
                },
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.beach_access),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FourthPage()),
                  );
                },
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.cake),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FifthPage()),
                  );
                },
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: authController.signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Third Page"),backgroundColor: Colors.green),
      backgroundColor: Colors.white,
      body: Center(
        child: const Text("This is the third page."),
      ),
    );
  }
}

class FourthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fourth Page"),backgroundColor: Colors.green),
      backgroundColor: Colors.white,
      body: Center(
        child: const Text("This is the fourth page."),
      ),
    );
  }
}

class FifthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fifth Page"),backgroundColor: Colors.green),
      backgroundColor: Colors.white,
      body: Center(
        child: const Text("This is the fifth page."),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}