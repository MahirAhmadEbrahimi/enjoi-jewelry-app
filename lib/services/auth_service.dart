import 'package:firebase_auth/firebase_auth.dart';

class SignUpResult {
  final String? error;
  final String? uid;
  const SignUpResult({this.error, this.uid});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// SIGN UP
  Future<SignUpResult> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await user.user!.updateDisplayName(name);

      return SignUpResult(uid: user.user!.uid);
    } on FirebaseAuthException catch (e) {
      return SignUpResult(error: e.message);
    }
  }

  /// LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
