import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:getxlogin/Screens/HomeScreen/home.dart';
import 'package:getxlogin/Screens/Register/register.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:getxlogin/Constants/auth_constans.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  late Rx<GoogleSignInAccount?> googleSingInAccount;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(auth.currentUser);
    googleSingInAccount = Rx<GoogleSignInAccount?>(googleSignIn.currentUser);
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser,_setInitialScreen);
    googleSingInAccount.bindStream(googleSignIn.onCurrentUserChanged);
    ever(googleSingInAccount,_setInitialScreenGoogle);
    super.onReady();
  }

  _setInitialScreen(User? user){
    if(user == null){
      Get.offAll(() => const Register());
    }else{
      Get.offAll(() => const HomePage());
    }
  }


  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount){
    print(googleSignInAccount);
    if(googleSingInAccount != null){
      Get.offAll(() => const Register());
    }else{
      Get.offAll(() => const HomePage());
      }
      }

  void SignInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSingInAccount = await googleSignIn.signIn();
      if (googleSingInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSingInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        await auth.signInWithCredential(credential).catchError((onError) {
          print("Error is $onError");
        });
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void emailRegister(String email, password) {
    try {
      auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {
      Get.snackbar("Error", firebaseAuthException.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void emailLogin(String email, password) {
    try {
      auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {
      Get.snackbar("Error", firebaseAuthException.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOut() async {
    await auth.signOut();
  }
}
