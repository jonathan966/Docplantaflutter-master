import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getxlogin/Constants/auth_constans.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;




class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Inicio"),
          backgroundColor: Colors.green,
          centerTitle: true),
      backgroundColor: Colors.white,
      body: Center(
        child: Card(
          color: Colors.green, // Color de la tarjeta
          elevation: 8.0, // Elevación de la tarjeta (sombra)
          margin: EdgeInsets.all(16.0), // Márgenes alrededor de la tarjeta
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¡Bienvenido a Docplanta!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Cambia el color del texto aquí
                  ),
                ),
                SizedBox(height: 16.0),
                // Agrega otros widgets según sea necesario
              ],
            ),
          ),
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
                icon: Icon(Icons.yard),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThirdPage()),
                  );
                },
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.medication),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FourthPage()),
                  );
                },
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.device_thermostat),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FifthPage()),
                  );
                },
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.import_contacts),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SixPage()),
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


class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  late String plantaId = '';

  final CollectionReference plantasCollection =
  FirebaseFirestore.instance.collection('plantas');

  void registrarPlanta() async {
    await plantasCollection.add({
      'nombre': nombreController.text,
      'descripcion': descripcionController.text,
    });

    nombreController.clear();
    descripcionController.clear();
    plantaId = ''; // Restablece plantaId después de registrar

    // Regresa a la pantalla anterior
    Navigator.pop(context);
  }

  void editarPlanta() async {
    await plantasCollection.doc(plantaId).update({
      'nombre': nombreController.text,
      'descripcion': descripcionController.text,
    });

    nombreController.clear();
    descripcionController.clear();
    plantaId = ''; // Restablece plantaId después de editar

    // Regresa a la pantalla anterior
    Navigator.pop(context);
  }

  void eliminarPlanta(String plantaId) async {
    await plantasCollection.doc(plantaId).delete();
    nombreController.clear();
    descripcionController.clear();
    plantaId = ''; // Restablece plantaId después de eliminar

    // Regresa a la pantalla anterior
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de plantas "),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nombreController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Nombre de la planta',
                filled: true,
                fillColor: Colors.grey[200],
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descripcionController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Descripción',
                filled: true,
                fillColor: Colors.grey[200],
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: plantaId.isEmpty ? registrarPlanta : editarPlanta,
                  child: Text(plantaId.isEmpty ? 'Registrar' : 'Editar'),
                ),
                if (plantaId.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () {
                      eliminarPlanta(plantaId);
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Eliminar'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            // Lista de plantas
            BottomAppBar(
              color: Colors.green,
              shape: CircularNotchedRectangle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(),
                    Text(
                      'Lista de Plantas:',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    StreamBuilder(
                      stream: plantasCollection.snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        var plantas = snapshot.data?.docs ?? [];

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: plantas.length,
                          itemBuilder: (context, index) {
                            var planta = plantas[index];

                            return ListTile(
                              title: Text(
                                planta['nombre'],
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                planta['descripcion'],
                                style: TextStyle(color: Colors.black),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        plantaId = planta.id;
                                        nombreController.text =
                                        planta['nombre'];
                                        descripcionController.text =
                                        planta['descripcion'];
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        plantaId = planta.id;
                                        eliminarPlanta(plantaId);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  final TextEditingController nombreEnfermedadController = TextEditingController();
  late String plantaSeleccionada = '';
  final TextEditingController numPlantasEnfermasController = TextEditingController();
  final TextEditingController descripcionEnfermedadController = TextEditingController();
  late DateTime fechaSeleccionada = DateTime.now();
  late String enfermedadId = '';

  final CollectionReference enfermedadesCollection = FirebaseFirestore.instance.collection('enfermedades');
  final CollectionReference plantasCollection = FirebaseFirestore.instance.collection('plantas');

  List<QueryDocumentSnapshot<Object?>> plantas = [];
  List<QueryDocumentSnapshot<Object?>> enfermedades = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      cargarDatosIniciales();
    });
  }

  void cargarDatosIniciales() async {
    var plantasSnapshot = await plantasCollection.get();
    var enfermedadesSnapshot = await enfermedadesCollection.get();

    setState(() {
      plantaSeleccionada = plantasSnapshot.docs.isNotEmpty ? plantasSnapshot.docs[0].id : '';
      plantas = List.from(plantasSnapshot.docs);
      enfermedades = List.from(enfermedadesSnapshot.docs);
    });
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fechaSeleccionadaNueva = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (fechaSeleccionadaNueva != null && fechaSeleccionadaNueva != fechaSeleccionada) {
      setState(() {
        fechaSeleccionada = fechaSeleccionadaNueva;
      });
    }
  }

  void registrarEnfermedad() async {
    await enfermedadesCollection.add({
      'nombreEnfermedad': nombreEnfermedadController.text,
      'plantaSeleccionada': plantaSeleccionada,
      'numPlantasEnfermas': numPlantasEnfermasController.text,
      'descripcionEnfermedad': descripcionEnfermedadController.text,
      'fecha': fechaSeleccionada,
    });

    limpiarCampos();
    cargarDatosIniciales();
  }

  void editarEnfermedad() async {
    await enfermedadesCollection.doc(enfermedadId).update({
      'nombreEnfermedad': nombreEnfermedadController.text,
      'plantaSeleccionada': plantaSeleccionada,
      'numPlantasEnfermas': numPlantasEnfermasController.text,
      'descripcionEnfermedad': descripcionEnfermedadController.text,
      'fecha': fechaSeleccionada,
    });

    limpiarCampos();
    cargarDatosIniciales();
  }

  void eliminarEnfermedad() async {
    await enfermedadesCollection.doc(enfermedadId).delete();
    limpiarCampos();
    cargarDatosIniciales();
  }

  void limpiarCampos() {
    setState(() {
      nombreEnfermedadController.clear();
      plantaSeleccionada = plantas.isNotEmpty ? plantas[0].id : '';
      numPlantasEnfermasController.clear();
      descripcionEnfermedadController.clear();
      fechaSeleccionada = DateTime.now();
      enfermedadId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar enfermedaes"), backgroundColor: Colors.green),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nombreEnfermedadController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Nombre de la enfermedad',
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButton<String>(
                  hint: Text('Seleccione una planta', style: TextStyle(color: Colors.black)),
                  value: plantaSeleccionada,
                  onChanged: (String? newValue) {
                    setState(() {
                      plantaSeleccionada = newValue!;
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  items: plantas
                      .map((planta) => DropdownMenuItem<String>(
                    value: planta.id,
                    child: Text(
                      planta['nombre'],
                      style: TextStyle(color: Colors.black),
                    ),
                  ))
                      .toList(),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: numPlantasEnfermasController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Número de plantas enfermas',
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: descripcionEnfermedadController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Descripción de la enfermedad',
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _seleccionarFecha,
                  child: Text('Seleccionar Fecha'),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: enfermedadId.isEmpty ? registrarEnfermedad : editarEnfermedad,
                      child: Text(enfermedadId.isEmpty ? 'Registrar' : 'Editar'),
                    ),
                    if (enfermedadId.isNotEmpty)
                      ElevatedButton(
                        onPressed: eliminarEnfermedad,
                        child: Text('Eliminar'),
                      ),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      // Lista de enfermedades
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),
              Text(
                'Lista de Enfermedades:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: enfermedades.length,
                itemBuilder: (context, index) {
                  var enfermedad = enfermedades[index];
                  return ListTile(
                    title: Text(enfermedad['nombreEnfermedad']),
                    subtitle: Text(enfermedad['descripcionEnfermedad']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            setState(() {
                              enfermedadId = enfermedad.id;
                              nombreEnfermedadController.text = enfermedad['nombreEnfermedad'];
                              plantaSeleccionada = enfermedad['plantaSeleccionada'];
                              numPlantasEnfermasController.text = enfermedad['numPlantasEnfermas'];
                              descripcionEnfermedadController.text = enfermedad['descripcionEnfermedad'];
                              fechaSeleccionada = enfermedad['fecha'].toDate();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              enfermedadId = enfermedad.id;
                              eliminarEnfermedad();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*class FifthPage extends StatelessWidget {
  final String youtubeVideoUrl = "https://www.youtube.com/watch?v=3WttLiwm99U"; // Reemplaza con tu URL de video de YouTube

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fifth Page"), backgroundColor: Colors.green),
      backgroundColor: Colors.white,
      body: WebView(
        initialUrl: youtubeVideoUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}*/

class FifthPage extends StatefulWidget {
  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  final TextEditingController nombreInvernaderoController = TextEditingController();
  late String plantaSeleccionada = '';
  final TextEditingController descripcionInvernaderoController = TextEditingController();
  late String invernaderoId = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final CollectionReference invernaderosCollection = FirebaseFirestore.instance.collection('invernaderos');
  final CollectionReference plantasCollection = FirebaseFirestore.instance.collection('plantas');
  final CollectionReference sensoresCollection = FirebaseFirestore.instance.collection('sensores');
  late double humValue;
  late double tempValue;
  bool mostrarSnackBar = false;
  List<QueryDocumentSnapshot<Object?>> plantas = [];
  List<QueryDocumentSnapshot<Object?>> invernaderos = [];

  @override
  void initState() {
    super.initState();
    humValue = 0.0; // Inicializar con un valor predeterminado
    tempValue = 0.0;
    initNotifications();
    cargarDatosIniciales();
    cargarDatosSensores();
  }


  void initNotifications() async {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // Reemplaza 'app_icon' con tu icono

    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    // Cierra la conexión del paquete de notificaciones al cerrar la aplicación
    flutterLocalNotificationsPlugin.cancelAll();
    super.dispose();
  }


  void cargarDatosIniciales() async {
    var plantasSnapshot = await plantasCollection.get();
    var invernaderosSnapshot = await invernaderosCollection.get();

    setState(() {
      plantaSeleccionada = plantasSnapshot.docs.isNotEmpty ? plantasSnapshot.docs[0].id : '';
      plantas = List.from(plantasSnapshot.docs);
      invernaderos = List.from(invernaderosSnapshot.docs);
    });
  }


  void cargarDatosSensores() {
    sensoresCollection.snapshots().listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          humValue = (querySnapshot.docs[0]['hum'] as num).toDouble();
          tempValue = (querySnapshot.docs[0]['temp'] as num).toDouble();
          if (tempValue >= 27) {
            mostrarNotificacion();
            mostrarSnackBar = true; // Muestra el SnackBar cuando se cumple la condición
          } else {
            mostrarSnackBar = false; // Oculta el SnackBar en otros casos
          }
        });
      }
    });
  }

  Future<void> mostrarNotificacion() async {
    print('Iniciando la función mostrarNotificacion');

    try {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        'channel_description',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        fullScreenIntent: true,
      );

      var iOSPlatformChannelSpecifics = IOSNotificationDetails();

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      print('Antes de llamar a flutterLocalNotificationsPlugin.show');

      // Verificar si tempValue es nulo antes de usarlo
      String temperaturaMensaje = 'Se recomienda revisar la temperatura.';

      if (tempValue != null) {
        temperaturaMensaje += ' Temperatura actual: $tempValue';
      }

      await flutterLocalNotificationsPlugin.show(
        0,
        'Revisar Temperatura',
        temperaturaMensaje,
        platformChannelSpecifics,
        payload: 'notification_payload',
      );

      print('Después de llamar a flutterLocalNotificationsPlugin.show');
      print('Notificación mostrada correctamente');
    } catch (e) {
      print('Error al mostrar la notificación: $e');
    }
  }



  Future<void> _seleccionarFecha() async {
    final DateTime? fechaSeleccionadaNueva = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (fechaSeleccionadaNueva != null && fechaSeleccionadaNueva != DateTime.now()) {
      // Puedes hacer algo con la nueva fecha seleccionada si es necesario
    }
  }

  void registrarInvernadero() async {
    await invernaderosCollection.add({
      'nombreInvernadero': nombreInvernaderoController.text,
      'plantaSeleccionada': plantaSeleccionada,
      'descripcionInvernadero': descripcionInvernaderoController.text,
    });

    limpiarCampos();
    cargarDatosIniciales();
  }

  void editarInvernadero() async {
    await invernaderosCollection.doc(invernaderoId).update({
      'nombreInvernadero': nombreInvernaderoController.text,
      'plantaSeleccionada': plantaSeleccionada,
      'descripcionInvernadero': descripcionInvernaderoController.text,
    });

    limpiarCampos();
    cargarDatosIniciales();
  }

  void eliminarInvernadero() async {
    await invernaderosCollection.doc(invernaderoId).delete();
    limpiarCampos();
    cargarDatosIniciales();
  }

  void limpiarCampos() {
    setState(() {
      nombreInvernaderoController.clear();
      plantaSeleccionada = plantas.isNotEmpty ? plantas[0].id : '';
      descripcionInvernaderoController.clear();
      invernaderoId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Invernadero"), backgroundColor: Colors.green),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nombreInvernaderoController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Nombre del Invernadero',
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButton<String>(
                  hint: Text('Seleccione una planta', style: TextStyle(color: Colors.black)),
                  value: plantaSeleccionada,
                  onChanged: (String? newValue) {
                    setState(() {
                      plantaSeleccionada = newValue!;
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  items: plantas
                      .map((planta) => DropdownMenuItem<String>(
                    value: planta.id,
                    child: Text(
                      planta['nombre'],
                      style: TextStyle(color: Colors.black),
                    ),
                  ))
                      .toList(),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: descripcionInvernaderoController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Descripción del Invernadero',
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _seleccionarFecha,
                  child: Text('Seleccionar Fecha'),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: invernaderoId.isEmpty ? registrarInvernadero : editarInvernadero,
                      child: Text(invernaderoId.isEmpty ? 'Registrar' : 'Editar'),
                    ),
                    if (invernaderoId.isNotEmpty)
                      ElevatedButton(
                        onPressed: eliminarInvernadero,
                        child: Text('Eliminar'),
                      ),
                  ],
                ),
                SizedBox(height: 16.0),

                Card(
                  color: Colors.green,
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sensor',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text('Humedad: $humValue'),
                        Text('Temperatura: $tempValue'),
                        if (mostrarSnackBar)
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      'Se recomienda revisar la temperatura. Temperatura actual: $tempValue',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                            },
                            child: Text('Advertencia'),
                          ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      // Lista de invernaderos
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),
              Text(
                'Lista de Invernaderos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: invernaderos.length,
                itemBuilder: (context, index) {
                  var invernadero = invernaderos[index];
                  return ListTile(
                    title: Text(invernadero['nombreInvernadero']),
                    subtitle: Text(invernadero['descripcionInvernadero']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            setState(() {
                              invernaderoId = invernadero.id;
                              nombreInvernaderoController.text = invernadero['nombreInvernadero'];
                              plantaSeleccionada = invernadero['plantaSeleccionada'];
                              descripcionInvernaderoController.text = invernadero['descripcionInvernadero'];
                              // fechaSeleccionada = invernadero['fecha'].toDate(); // No hay fecha en el código original
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              invernaderoId = invernadero.id;
                              eliminarInvernadero();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SixPage extends StatelessWidget {
final List<String> imagePaths = [
  'assets/images/docplanta.png',
  'assets/images/docplanta.png',
  // Agrega más rutas de imágenes según sea necesario
];

final List<String> linkUrls = [
  'https://www.youtube.com/watch?v=3WttLiwm99U',
  'https://flutter.dev/',
  // Agrega más URLs de enlaces según sea necesario
];

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Cursos'), backgroundColor: Colors.green),
    backgroundColor: Colors.white,
    body: ListView.builder(
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: InkWell(
            onTap: () {
              _launchURL(context, linkUrls[index]);
            },
            child: Image.asset(
              imagePaths[index],
              width: 100.0,
              height: 100.0,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    ),
  );
}

void _launchURL(BuildContext context, String url) {
  try {
    FlutterWebBrowser.openWebPage(
      url: url,
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  } catch (e) {
    print('Error launching URL: $e');
  }
}
}


void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
