import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:restaurant/domain/services/auth_Services.dart';
import 'package:restaurant/domain/services/user_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthServices _authServices = AuthServices();

  AuthBloc() : super(AuthState()) {
    on<LoginEvent>(_onLogin);
    on<CheckLoginEvent>(_onCheckLogin);
    on<LogOutEvent>(_onLogOut);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingAuthState());

      final user = await _authServices.signInWithEmailAndPassword(
          event.email, event.password);

      if (user != null) {
        // TODO: Get user role from Firestore
        final userServices = UserServices();
        final userDb = await userServices.getUserById(user.uid);
        if (userDb != null) {
          emit(state.copyWith(user: user, rolId: userDb.rolId));
        } else {
          emit(FailureAuthState('Failed to get user role'));
        }
      } else {
        emit(FailureAuthState('Invalid credentials'));
      }
    } catch (e) {
      emit(FailureAuthState(e.toString()));
    }
  }

  Future<void> _onCheckLogin(
      CheckLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingAuthState());

      final user = _authServices.getCurrentUser();

      if (user != null) {
        // TODO: Get user role from Firestore
        final userServices = UserServices();
        final userDb = await userServices.getUserById(user.uid);
        if (userDb != null) {
          emit(state.copyWith(user: user, rolId: userDb.rolId));
        } else {
          emit(FailureAuthState('Failed to get user role'));
        }
      } else {
        emit(LogOutAuthState());
      }
    } catch (e) {
      emit(FailureAuthState(e.toString()));
    }
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    await _authServices.signOut();
    emit(LogOutAuthState());
    return emit(state.copyWith(user: null, rolId: ''));
  }
}
