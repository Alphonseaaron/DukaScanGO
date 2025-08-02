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

class RegisterClientScreen extends StatefulWidget {
  @override
  _RegisterClientScreenState createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen> {
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _referralCodeController;

  String _fullPhoneNumber = '';
  Map<String, dynamic> _countryData = {};

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _referralCodeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    clearForm();
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  void clearForm() {
    _nameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _referralCodeController.clear();
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
              'Client Registered successfully',
              () => Navigator.pushReplacement(
                  context, routeFrave(page: LoginScreen())));
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
            text: 'Create a Account',
          ),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                if (_keyForm.currentState!.validate()) {
                  userBloc.add(OnRegisterClientEvent(
                    _nameController.text,
                    _lastnameController.text,
                    _fullPhoneNumber,
                    _emailController.text,
                    _passwordController.text,
                    userBloc.state.pictureProfilePath,
                    _countryData['country'],
                    _countryData['countryCode'],
                    _countryData['dialingCode'],
                    _countryData['flag'],
                    _countryData['currency'],
                    _countryData['geo'],
                    referralCode: _referralCodeController.text,
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
              Align(alignment: Alignment.center, child: _PictureRegistre()),
              const SizedBox(height: 40.0),
              const TextCustom(text: 'Name'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _nameController,
                hintText: 'Enter your name',
                validator: RequiredValidator(errorText: 'Name is required'),
              ),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Lastname'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _lastnameController,
                hintText: 'Enter your lastname',
                validator:
                    RequiredValidator(errorText: 'Lastname is required'),
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
              FormFieldFrave(
                  controller: _emailController,
                  hintText: 'email@frave.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: validatedEmail),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Password'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _passwordController,
                hintText: '********',
                isPassword: true,
                validator: passwordValidator,
              ),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Referral Code (Optional)'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _referralCodeController,
                hintText: 'Enter referral code',
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _PictureRegistre extends StatelessWidget {

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid, color: Colors.grey[300]!),
        shape: BoxShape.circle
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => modalPictureRegister(
          ctx: context, 
          onPressedChange: () async {

            final permissionGallery = await Permission.photos.request();
            
            switch ( permissionGallery ){

              case PermissionStatus.granted:
                Navigator.pop(context);
                final XFile? imagePath = await _picker.pickImage(source: ImageSource.gallery);
                if( imagePath != null ) userBloc.add( OnSelectPictureEvent(imagePath.path));
                break;
              case PermissionStatus.denied:
              case PermissionStatus.restricted:
              case PermissionStatus.limited:
              case PermissionStatus.permanentlyDenied:
                openAppSettings();
                break;
            }
            
          },
          onPressedTake: () async {

            final permissionPhotos = await Permission.camera.request();

            switch ( permissionPhotos ){

              case PermissionStatus.granted:
                Navigator.pop(context);
                final XFile? photoPath = await _picker.pickImage(source: ImageSource.camera);
                if( photoPath != null ) userBloc.add( OnSelectPictureEvent(photoPath.path));
                break;

              case PermissionStatus.denied:
              case PermissionStatus.restricted:
              case PermissionStatus.limited:
              case PermissionStatus.permanentlyDenied:
                openAppSettings();
                break;
            }

          }
        ),
        child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) 
                => state.pictureProfilePath == ''
                   ? Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: const [
                        Icon(Icons.wallpaper_rounded, size: 60, color: ColorsFrave.primaryColor ),
                        SizedBox(height: 10.0),
                        TextCustom(text: 'Picture', color: Colors.grey )
                     ],
                    ) 
                   : Container(
                      height: 100,  
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(state.pictureProfilePath))
                        )
                      ),
                     ),
            ),
           
      ),
    );
  }
}
