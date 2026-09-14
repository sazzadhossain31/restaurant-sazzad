import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream of UserModel representing auth state changes
  Stream<UserModel?> get onAuthStateChanged {
    return _auth.authStateChanges().map((User? user) {
      return user != null ? UserModel.fromFirebase(user) : null;
    });
  }

  // Sign up with email & password
  Future<UserModel?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = result.user;
      return user != null ? UserModel.fromFirebase(user) : null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected authentication error occurred.';
    }
  }

  // Sign in with email & password
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = result.user;
      return user != null ? UserModel.fromFirebase(user) : null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected authentication error occurred.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out. Please try again.';
    }
  }

  // Custom error handler for friendly UI messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email address is already registered.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
