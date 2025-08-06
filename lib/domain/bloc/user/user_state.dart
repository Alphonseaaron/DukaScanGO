part of 'user_bloc.dart';

@immutable
class UserState {
  final User? user;
  final List<User> users;
  final String? pictureProfilePath;
  final bool? isUpdated;

  const UserState(
      {this.user, this.users = const [], this.pictureProfilePath, this.isUpdated});

  UserState copyWith(
          {User? user,
          List<User>? users,
          String? pictureProfilePath,
          bool? isUpdated}) =>
      UserState(
          user: user ?? this.user,
          users: users ?? this.users,
          pictureProfilePath: pictureProfilePath ?? this.pictureProfilePath,
          isUpdated: isUpdated ?? this.isUpdated);
}

class LoadingUserState extends UserState {}

class SuccessUserState extends UserState {}

class FailureUserState extends UserState {
  final String error;

  FailureUserState(this.error);
}