import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:restaurant/domain/models/user.dart' as UserModel;
import 'package:restaurant/domain/services/user_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'user_event.dart';
part 'user_state.dart';

import 'package:firebase_auth/firebase_auth.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserServices _userServices = UserServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserBloc() : super(const UserState()) {
    on<OnGetUserEvent>(_onGetUser);
    on<OnSelectPictureEvent>(_onSelectPicture);
    on<OnClearPicturePathEvent>(_onClearPicturePath);
    on<OnChangeImageProfileEvent>(_onChangePictureProfile);
    on<OnEditUserEvent>(_onEditProfileUser);
    on<OnChangePasswordEvent>(_onChangePassword);
    on<OnRegisterClientEvent>(_onRegisterClient);
    on<OnRegisterDeliveryEvent>(_onRegisterDelivery);
  }

  Future<void> _onGetUser(OnGetUserEvent event, Emitter<UserState> emit) async {
    final user = await _userServices.getUserById(event.user.uid);
    if (user != null) {
      emit(state.copyWith(user: user));
    }
  }

  Future<void> _onSelectPicture(
      OnSelectPictureEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(pictureProfilePath: event.pictureProfilePath));
  }

  Future<void> _onClearPicturePath(
      OnClearPicturePathEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(pictureProfilePath: ''));
  }

  Future<void> _onChangePictureProfile(
      OnChangeImageProfileEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      final imageUrl = await _userServices.uploadImage(event.image);
      await _userServices.updateUserProfileImage(state.user!.uid, imageUrl);
      final user = await _userServices.getUserById(state.user!.uid);
      emit(SuccessUserState());
      emit(state.copyWith(user: user));
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onEditProfileUser(
      OnEditUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      final updatedUser = state.user!.copyWith(
        name: event.name,
        lastname: event.lastname,
        phone: event.phone,
        country: event.country,
        countryCode: event.countryCode,
        dialingCode: event.dialingCode,
        flag: event.flag,
        currency: event.currency,
        geo: event.geo,
      );
      await _userServices.updateUser(updatedUser);
      final user = await _userServices.getUserById(state.user!.uid);
      emit(SuccessUserState());
      emit(state.copyWith(user: user));
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onChangePassword(
      OnChangePasswordEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      // TODO: Implement change password with Firebase Auth
      emit(SuccessUserState());
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onRegisterClient(
      OnRegisterClientEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = UserModel.User(
        uid: userCredential.user!.uid,
        name: event.name,
        lastname: event.lastname,
        email: event.email,
        phone: event.phone,
        rolId: '2', // Assuming '2' is for clients
        country: event.country,
        countryCode: event.countryCode,
        dialingCode: event.dialingCode,
        flag: event.flag,
        currency: event.currency,
        geo: event.geo,
      );
      await _userServices.addUser(user);
      emit(SuccessUserState());
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onRegisterDelivery(
      OnRegisterDeliveryEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = UserModel.User(
        uid: userCredential.user!.uid,
        name: event.name,
        lastname: event.lastname,
        email: event.email,
        phone: event.phone,
        rolId: '3', // Assuming '3' is for delivery
        country: event.country,
        countryCode: event.countryCode,
        dialingCode: event.dialingCode,
        flag: event.flag,
        currency: event.currency,
        geo: event.geo,
      );
      await _userServices.addUser(user);
      emit(SuccessUserState());
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }
}
