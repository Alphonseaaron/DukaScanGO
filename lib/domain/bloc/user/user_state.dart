part of 'user_bloc.dart';

@immutable
class UserState {
  final String? pictureProfilePath;
  final int? uidAddress;
  final String? addressName;
  final UserModel.User? user;

  const UserState({
    this.uidAddress,
    this.addressName,
    this.pictureProfilePath,
    this.user,
  });

  UserState copyWith({
    int? uidAddress,
    String? addressName,
    String? pictureProfilePath,
    UserModel.User? user,
  }) =>
      UserState(
        uidAddress: uidAddress ?? this.uidAddress,
        addressName: addressName ?? this.addressName,
        pictureProfilePath: pictureProfilePath ?? this.pictureProfilePath,
        user: user ?? this.user,
      );
}


class LoadingUserState extends UserState {}

class SuccessUserState extends UserState {}

class FailureUserState extends UserState {
  final String error;

  FailureUserState(this.error);
}