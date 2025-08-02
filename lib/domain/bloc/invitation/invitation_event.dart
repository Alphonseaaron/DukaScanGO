part of 'invitation_bloc.dart';

@immutable
abstract class InvitationEvent {}

class OnSendInvitationEvent extends InvitationEvent {
  final String email;
  final String role;
  final List<String> permissions;
  final String storeId;

  OnSendInvitationEvent(this.email, this.role, this.permissions, this.storeId);
}

class OnAcceptInvitationEvent extends InvitationEvent {
  final Invitation invitation;

  OnAcceptInvitationEvent(this.invitation);
}

class OnDeclineInvitationEvent extends InvitationEvent {
  final String invitationId;

  OnDeclineInvitationEvent(this.invitationId);
}

class OnGetInvitationsForUserEvent extends InvitationEvent {}
