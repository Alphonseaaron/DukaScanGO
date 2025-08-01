import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dukascango/domain/models/invitation.dart';
import 'package:dukascango/domain/services/invitation_services.dart';
import 'package:dukascango/domain/services/user_services.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

part 'invitation_event.dart';
part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final InvitationServices _invitationServices = InvitationServices();
  final UserServices _userServices = UserServices();
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  InvitationBloc() : super(const InvitationInitial()) {
    on<OnSendInvitationEvent>(_onSendInvitation);
    on<OnAcceptInvitationEvent>(_onAcceptInvitation);
    on<OnDeclineInvitationEvent>(_onDeclineInvitation);
    on<OnGetInvitationsForUserEvent>(_onGetInvitationsForUser);
  }

  Future<void> _onSendInvitation(
      OnSendInvitationEvent event, Emitter<InvitationState> emit) async {
    try {
      emit(InvitationLoading());
      // This is a simplified implementation. A real app would need to
      // look up the user by email, which is not directly possible with
      // Firestore security rules by default. This assumes a cloud function
      // or a different database structure.
      // For now, I'll assume we can get the user by email.
      final user = await _userServices.getUserByEmail(event.email);
      if (user == null) {
        emit(InvitationFailure('User not found.'));
        return;
      }
      final invitation = Invitation(
        storeId: 'store_id', // TODO: Get real store ID
        userId: user.uid,
        role: event.role,
        permissions: event.permissions,
        status: 'pending',
        dateInvited: DateTime.now(),
      );
      await _invitationServices.createInvitation(invitation);
      emit(InvitationSuccess());
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onAcceptInvitation(
      OnAcceptInvitationEvent event, Emitter<InvitationState> emit) async {
    try {
      emit(InvitationLoading());
      await _invitationServices.updateInvitationStatus(
          event.invitationId, 'accepted');
      // TODO: Update user role
      emit(InvitationSuccess());
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onDeclineInvitation(
      OnDeclineInvitationEvent event, Emitter<InvitationState> emit) async {
    try {
      emit(InvitationLoading());
      await _invitationServices.updateInvitationStatus(
          event.invitationId, 'declined');
      emit(InvitationSuccess());
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onGetInvitationsForUser(
      OnGetInvitationsForUserEvent event, Emitter<InvitationState> emit) async {
    try {
      emit(InvitationLoading());
      final userId = _firebaseAuth.currentUser!.uid;
      final invitations =
          await _invitationServices.getInvitationsForUser(userId);
      emit(state.copyWith(invitations: invitations));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }
}
