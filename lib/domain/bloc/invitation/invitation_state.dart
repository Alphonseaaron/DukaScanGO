part of 'invitation_bloc.dart';

@immutable
abstract class InvitationState {
  final List<Invitation> invitations;

  const InvitationState({this.invitations = const []});

  InvitationState copyWith({List<Invitation>? invitations}) {
    return InvitationInitial(
      invitations: invitations ?? this.invitations,
    );
  }
}

class InvitationInitial extends InvitationState {
  const InvitationInitial({List<Invitation> invitations = const []})
      : super(invitations: invitations);
}

class InvitationLoading extends InvitationState {}

class InvitationSuccess extends InvitationState {}

class InvitationFailure extends InvitationState {
  final String error;

  InvitationFailure(this.error);
}
