import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/screens/login/login_screen.dart';
import 'package:dukascango/presentation/components/phone_number_field.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';
import 'package:dukascango/domain/bloc/user/user_bloc.dart';
import 'package:dukascango/presentation/components/picture_registre.dart';

class RegisterStoreOwnerScreen extends StatefulWidget {
  @override
  _RegisterStoreOwnerScreenState createState() =>
      _RegisterStoreOwnerScreenState();
}

class _RegisterStoreOwnerScreenState extends State<RegisterStoreOwnerScreen> {
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String _fullPhoneNumber = '';
  Map<String, dynamic> _countryData = {};

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    clearForm();
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearForm() {
    _nameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context);
        } else if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(
              context,
              'Store Owner Registered successfully',
              () => Navigator.pushReplacement(
                  context, routeDukascango(page: LoginScreen())));
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              clearForm();
            },
            child: Container(
                alignment: Alignment.center,
                child: const TextCustom(
                    text: 'Cancel',
                    color: ColorsDukascango.primaryColor,
                    fontSize: 15)),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 70,
          title: const TextCustom(
            text: 'Register as Store Owner',
          ),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                if (_keyForm.currentState!.validate()) {
                  userBloc.add(OnRegisterStoreOwnerEvent(
                    _nameController.text,
                    _lastnameController.text,
                    _fullPhoneNumber,
                    _emailController.text,
                    _passwordController.text,
                    userBloc.state.pictureProfilePath,
                    _countryData['country'] ?? '',
                    _countryData['countryCode'] ?? '',
                    _countryData['dialingCode'] ?? '',
                    _countryData['flag'] ?? '',
                    _countryData['currency'] ?? {},
                    _countryData['geo'] ?? {},
                  ));
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                alignment: Alignment.center,
                child: const TextCustom(
                    text: 'Save',
                    color: ColorsDukascango.primaryColor,
                    fontSize: 15),
              ),
            ),
          ],
        ),
        body: Form(
          key: _keyForm,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              const SizedBox(height: 20.0),
              Align(alignment: Alignment.center, child: PictureRegistre()),
              const SizedBox(height: 40.0),
              const TextCustom(text: 'Name'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _nameController,
                hintText: 'Enter your name',
                validator: RequiredValidator(errorText: 'Name is required'),
              ),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Lastname'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _lastnameController,
                hintText: 'Enter your lastname',
                validator: RequiredValidator(errorText: 'Lastname is required'),
              ),
              const SizedBox(height: 15.0),
              PhoneNumberField(
                onChanged: (fullPhoneNumber, countryData) {
                  setState(() {
                    _fullPhoneNumber = fullPhoneNumber;
                    _countryData = countryData;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Email'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                  controller: _emailController,
                  hintText: 'email@frave.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: validatedEmail),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Password'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _passwordController,
                hintText: '********',
                isPassword: true,
                validator: passwordValidator,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
