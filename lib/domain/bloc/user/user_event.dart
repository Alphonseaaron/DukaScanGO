part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class OnGetUserEvent extends UserEvent {
  final firebase_auth.User user;

  OnGetUserEvent(this.user);
}

class OnGetAllUsersEvent extends UserEvent {}

class OnUpdateUserRoleEvent extends UserEvent {
  final User user;
  final String role;

  OnUpdateUserRoleEvent(this.user, this.role);
}

class OnSelectPictureEvent extends UserEvent {
  final String pictureProfilePath;

  OnSelectPictureEvent(this.pictureProfilePath);
}

class OnClearPicturePathEvent extends UserEvent {}

class OnChangeImageProfileEvent extends UserEvent {
  final XFile image;

  OnChangeImageProfileEvent(this.image);
}

class OnEditUserEvent extends UserEvent {
  final String name;
  final String lastname;
  final String phone;
  final String country;
  final String countryCode;
  final String dialingCode;
  final String flag;
  final Map<String, dynamic> currency;
  final Map<String, dynamic> geo;

  OnEditUserEvent(this.name, this.lastname, this.phone, this.country,
      this.countryCode, this.dialingCode, this.flag, this.currency, this.geo);
}

class OnChangePasswordEvent extends UserEvent {
  final String currentPassword;
  final String newPassword;

  OnChangePasswordEvent(this.currentPassword, this.newPassword);
}

class OnRegisterDeliveryEvent extends UserEvent {
  final String name;
  final String lastname;
  final String phone;
  final String email;
  final String password;
  final String image;
  final String country;
  final String countryCode;
  final String dialingCode;
  final String flag;
  final Map<String, dynamic> currency;
  final Map<String, dynamic> geo;

  OnRegisterDeliveryEvent(
      this.name,
      this.lastname,
      this.phone,
      this.email,
      this.password,
      this.image,
      this.country,
      this.countryCode,
      this.dialingCode,
      this.flag,
      this.currency,
      this.geo);
}

class OnRegisterClientEvent extends UserEvent {
  final String name;
  final String lastname;
  final String phone;
  final String email;
  final String password;
  final String image;
  final String country;
  final String countryCode;
  final String dialingCode;
  final String flag;
  final Map<String, dynamic> currency;
  final Map<String, dynamic> geo;

  OnRegisterClientEvent(
      this.name,
      this.lastname,
      this.phone,
      this.email,
      this.password,
      this.image,
      this.country,
      this.countryCode,
      this.dialingCode,
      this.flag,
      this.currency,
      this.geo);
}

class OnDeleteStreetAddressEvent extends UserEvent {
  final int uid;

  OnDeleteStreetAddressEvent(this.uid);
}

class OnAddNewAddressEvent extends UserEvent {
  final String street;
  final String reference;
  final LatLng location;

  OnAddNewAddressEvent(this.street, this.reference, this.location);
}

class OnSelectAddressButtonEvent extends UserEvent {
  final int uidAddress;
  final String addressName;

  OnSelectAddressButtonEvent(this.uidAddress, this.addressName);
}

class OnUpdateDeliveryToClientEvent extends UserEvent {
  final String idPerson;

  OnUpdateDeliveryToClientEvent(this.idPerson);
}