import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial()) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthStateLoading());
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        // Cek database dulu
        DocumentSnapshot userDoc =
            await users.doc(userCredential.user!.uid).get();

        if (!userDoc.exists) {
          await users.doc(userCredential.user!.uid).set({
            'email': userCredential.user!.email,
            'uid': userCredential.user!.uid,
            'name': userCredential.user!.displayName,
            'photoUrl': userCredential.user!.photoURL,
            'createAt': Timestamp.now(),
            'lastLoginAt': Timestamp.now(),
          });
        } else {
          await users.doc(userCredential.user!.uid).set({
            'lastLoginAt': Timestamp.now(),
          }, SetOptions(merge: true));
        }

        emit(AuthStateLoaded());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(AuthStateError(message: 'No user found for that email.'));
        } else if (e.code == 'wrong-password') {
          emit(AuthStateError(
              message: 'Wrong password provided for that user.'));
        } else {
          emit(AuthStateError(message: 'Login failed: ${e.message}'));
        }
      } catch (e) {
        emit(AuthStateError(
            message: 'An unknown error occurred: ${e.toString()}'));
      }
    });

    // on<AuthEventLogout>((event, emit) async {
    //   try {
    //     emit(AuthStateLoading()); 
    //     await auth.signOut(); 
    //     emit(AuthStateLogout()); 
    //   } catch (e) {
    //     emit(AuthStateError(message: 'Logout failed: ${e.toString()}'));
    //   }
    // });
  }
}
