part of 'user_bloc.dart';

@immutable
class UserState {
  final User? user;
  final List<User> users;
  final String? pictureProfilePath;
  final bool? isUpdated;
  final String? addressName;
  final String? uidAddress;

  const UserState(
      {this.user, this.users = const [], this.pictureProfilePath, this.isUpdated, this.addressName, this.uidAddress});

  UserState copyWith(
          {User? user,
          List<User>? users,
          String? pictureProfilePath,
          bool? isUpdated,
          String? addressName,
          String? uidAddress,
          }) =>
      UserState(
          user: user ?? this.user,
          users: users ?? this.users,
          pictureProfilePath: pictureProfilePath ?? this.pictureProfilePath,
          isUpdated: isUpdated ?? this.isUpdated,
          addressName: addressName ?? this.addressName,
          uidAddress: uidAddress ?? this.uidAddress,
      );
}

class LoadingUserState extends UserState {}

class SuccessUserState extends UserState {}

class FailureUserState extends UserState {
  final String error;

  FailureUserState(this.error);
}