import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/config/firebase_config.dart';
import 'auth_repository.dart';

class AuthRepositoryException implements Exception {
  const AuthRepositoryException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  String toString() {
    return code == null ? message : '$message ($code)';
  }
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: FirebaseConfig.googleWebClientId,
      );
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const AuthRepositoryException('Google sign in token was empty.');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      return _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AuthRepositoryException(
        error.message ?? 'Unable to sign in with Google.',
        error.code,
      );
    } on GoogleSignInException catch (error) {
      throw AuthRepositoryException(
        error.description ?? 'Google sign in failed.',
        error.code.name,
      );
    } on PlatformException catch (error) {
      throw AuthRepositoryException(
        error.message ?? 'Google sign in failed.',
        error.code,
      );
    } catch (_) {
      throw const AuthRepositoryException('Google sign in failed.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on FirebaseAuthException catch (error) {
      throw AuthRepositoryException(
        error.message ?? 'Unable to sign out.',
        error.code,
      );
    } on PlatformException catch (error) {
      throw AuthRepositoryException(
        error.message ?? 'Unable to sign out.',
        error.code,
      );
    } catch (_) {
      throw const AuthRepositoryException('Unable to sign out.');
    }
  }
}
