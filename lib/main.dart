import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxlogin/Constants/auth_constans.dart';
import 'Controller/auth_controller.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await firebaseInitialization.then((value) {
   Get.put(AuthController());
 });
 runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const CircularProgressIndicator(),
    );

}

}