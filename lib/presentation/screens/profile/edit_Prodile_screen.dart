import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/components/phone_number_field.dart';
import 'package:dukascango/presentation/helpers/validate_form.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';
import 'package:dukascango/presentation/walkthrough/admin_walkthrough.dart';
import 'package:dukascango/presentation/walkthrough/delivery_walkthrough.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  String _fullPhoneNumber = '';
  Map<String, dynamic> _countryData = {};

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<UserBloc>(context).state.user!;
    _nameController = TextEditingController(text: user.name);
    _lastNameController = TextEditingController(text: user.lastname);
    _emailController = TextEditingController(text: user.email);
    _fullPhoneNumber = user.phone ?? '';
    _countryData = {
      "country": user.country,
      "countryCode": user.countryCode,
      "dialingCode": user.dialingCode,
      "flag": user.flag,
      "currency": user.currency,
      "geo": user.geo,
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
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
          modalSuccess(context, 'User updated', () => Navigator.pop(context));
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 80,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: const [
                SizedBox(width: 10.0),
                Icon(Icons.arrow_back_ios_new_rounded,
                    color: ColorsDukascango.primaryColor, size: 17),
                TextCustom(
                    text: 'Back',
                    fontSize: 17,
                    color: ColorsDukascango.primaryColor)
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    final user = BlocProvider.of<UserBloc>(context).state.user!;
                    if (user.rolId == '1') {
                      Navigator.push(context,
                          routeDukascango(page: AdminWalkthroughScreen()));
                    } else if (user.rolId == '3') {
                      Navigator.push(context,
                          routeDukascango(page: DeliveryWalkthroughScreen()));
                    }
                  },
                  child: TextCustom(
                    text: 'Walkthrough',
                    fontSize: 16,
                    color: Colors.amber[900]!,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      if (_keyForm.currentState!.validate()) {
                        userBloc.add(OnEditUserEvent(
                          _nameController.text,
                          _lastNameController.text,
                          _fullPhoneNumber,
                          _countryData['country'],
                          _countryData['countryCode'],
                          _countryData['dialingCode'],
                          _countryData['flag'],
                          _countryData['currency'],
                          _countryData['geo'],
                        ));
                      }
                    },
                    child: TextCustom(
                        text: 'Update account',
                        fontSize: 16,
                        color: Colors.amber[900]!))
              ],
            )
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _keyForm,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              children: [
                const TextCustom(
                    text: 'Name', color: ColorsDukascango.secundaryColor),
                const SizedBox(height: 5.0),
                FormFieldDukascango(
                    controller: _nameController,
                    validator:
                        RequiredValidator(errorText: 'Name is required')),
                const SizedBox(height: 20.0),
                const TextCustom(
                    text: 'Lastname', color: ColorsDukascango.secundaryColor),
                const SizedBox(height: 5.0),
                FormFieldDukascango(
                  controller: _lastNameController,
                  hintText: 'lastname',
                  validator:
                      RequiredValidator(errorText: 'Lastname is required'),
                ),
                const SizedBox(height: 20.0),
                PhoneNumberField(
                  onChanged: (fullPhoneNumber, countryData) {
                    setState(() {
                      _fullPhoneNumber = fullPhoneNumber;
                      _countryData = countryData;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                const TextCustom(
                    text: 'Email Address',
                    color: ColorsDukascango.secundaryColor),
                const SizedBox(height: 5.0),
                FormFieldDukascango(
                    controller: _emailController, readOnly: true),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
