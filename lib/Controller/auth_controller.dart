import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:getxlogin/Screens/HomeScreen/home.dart';
import 'package:getxlogin/Screens/Register/register.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:getxlogin/Constants/auth_constans.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  late Rx<GoogleSignInAccount?> googleSignInAccount;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(auth.currentUser);
    googleSignInAccount = Rx<GoogleSignInAccount?>(googleSignIn.currentUser);
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
    googleSignInAccount.bindStream(googleSignIn.onCurrentUserChanged);
    ever(googleSignInAccount, _setInitialScreenGoogle);
    super.onReady();
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const Register());
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) {
    print(googleSignInAccount);
    if (googleSignInAccount != null) {
      Get.offAll(() => const Register());
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  Future<bool> emailRegister(String email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      return true; // Registro exitoso
    } catch (_) {
      return false; // Fallo en el registro
    }
  }

  Future<bool> emailLogin(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true; // Inicio de sesión exitoso
    } catch (_) {
      return false; // Fallo en el inicio de sesión
    }
  }

  void signOut() async {
    await auth.signOut();
  }

  void SignInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        await auth.signInWithCredential(credential).catchError((_) {
          print("Error signing in with Google");
        });
      }
    } catch (_) {
      print("Error signing in with Google");
    }
  }
}