part of 'invitation_bloc.dart';

@immutable
abstract class InvitationEvent {}

class OnSendInvitationEvent extends InvitationEvent {
  final String email;
  final String role;
  final List<String> permissions;

  OnSendInvitationEvent(this.email, this.role, this.permissions);
}

class OnAcceptInvitationEvent extends InvitationEvent {
  final String invitationId;

  OnAcceptInvitationEvent(this.invitationId);
}

class OnDeclineInvitationEvent extends InvitationEvent {
  final String invitationId;

  OnDeclineInvitationEvent(this.invitationId);
}

class OnGetInvitationsForUserEvent extends InvitationEvent {}
