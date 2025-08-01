import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:dukascango/domain/models/user.dart';
import 'package:dukascango/domain/models/wholesaler.dart';
import 'package:dukascango/domain/services/user_services.dart';
import 'package:dukascango/domain/services/wholesaler_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:image_picker/image_picker.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserServices _userServices = UserServices();
  final WholesalerServices _wholesalerServices = WholesalerServices();
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  UserBloc() : super(const UserState()) {
    on<OnGetUserEvent>(_onGetUser);
    on<OnSelectPictureEvent>(_onSelectPicture);
    on<OnClearPicturePathEvent>(_onClearPicturePath);
    on<OnChangeImageProfileEvent>(_onChangePictureProfile);
    on<OnEditUserEvent>(_onEditProfileUser);
    on<OnChangePasswordEvent>(_onChangePassword);
    on<OnRegisterClientEvent>(_onRegisterClient);
    on<OnRegisterStoreOwnerEvent>(_onRegisterStoreOwner);
    on<OnRegisterWholesalerEvent>(_onRegisterWholesaler);
    on<OnRegisterDeliveryEvent>(_onRegisterDelivery);
    on<OnGetAllUsersEvent>(_onGetAllUsers);
    on<OnUpdateUserRoleEvent>(_onUpdateUserRole);
  }

  Future<void> _onGetAllUsers(
      OnGetAllUsersEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      final users = await _userServices.getAllUsers();
      emit(state.copyWith(users: users));
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onUpdateUserRole(
      OnUpdateUserRoleEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      await _userServices.updateUser(event.user.copyWith(rolId: event.role));
      final users = await _userServices.getAllUsers();
      emit(SuccessUserState());
      emit(state.copyWith(users: users));
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
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
      final user = User(
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
      final wholesaler = Wholesaler(
        uid: userCredential.user!.uid,
        businessName: event.name,
        contactPerson: event.lastname,
        deliveryAreas: [],
        paymentDetails: '',
      );
      await _wholesalerServices.addWholesaler(wholesaler);
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
      final user = User(
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

  Future<void> _onRegisterWholesaler(
      OnRegisterWholesalerEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = User(
        uid: userCredential.user!.uid,
        name: event.name,
        lastname: event.lastname,
        email: event.email,
        phone: event.phone,
        rolId: '4', // Assuming '4' is for wholesaler
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

  Future<void> _onRegisterStoreOwner(
      OnRegisterStoreOwnerEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = User(
        uid: userCredential.user!.uid,
        name: event.name,
        lastname: event.lastname,
        email: event.email,
        phone: event.phone,
        rolId: '1', // Assuming '1' is for store owner
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
