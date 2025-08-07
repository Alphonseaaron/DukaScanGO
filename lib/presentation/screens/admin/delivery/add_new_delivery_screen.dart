import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/screens/admin/admin_home_screen.dart';
import 'package:dukascango/presentation/components/phone_number_field.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class AddNewDeliveryScreen extends StatefulWidget {
  @override
  _AddNewDeliveryScreenState createState() => _AddNewDeliveryScreenState();
}

class _AddNewDeliveryScreenState extends State<AddNewDeliveryScreen> {
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String _fullPhoneNumber = '';
  Map<String, dynamic> _countryData = {};

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    clearTextEditingController();
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearTextEditingController() {
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
        }
        if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(
              context,
              'Delivery Successfully Registered',
              () => Navigator.pushAndRemoveUntil(context,
                  routeDukascango(page: AdminHomeScreen()), (route) => false));
          userBloc.add(OnClearPicturePathEvent());
        }
        if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: 'Add New Delivery'),
          centerTitle: true,
          leadingWidth: 80,
          leading: TextButton(
            child: const TextCustom(
                text: 'Cancel',
                color: ColorsDukascango.primaryColor,
                fontSize: 17),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    userBloc.add(OnRegisterDeliveryEvent(
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
                child: const TextCustom(
                    text: ' Save ', color: ColorsDukascango.primaryColor))
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
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Name'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                hintText: 'name',
                controller: _nameController,
                validator: RequiredValidator(errorText: 'Name is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Lastname'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                controller: _lastnameController,
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
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Email'),
              const SizedBox(height: 5.0),
              FormFieldDukascango(
                  controller: _emailController,
                  hintText: 'email@dukascango.com',
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
            
            Navigator.pop(context);
            final XFile? imagePath = await _picker.pickImage(source: ImageSource.gallery);
            if( imagePath != null ) userBloc.add( OnSelectPictureEvent(imagePath.path));

          },
          onPressedTake: () async {

            Navigator.pop(context);
            final XFile? photoPath = await _picker.pickImage(source: ImageSource.camera);
            if( photoPath != null ) userBloc.add( OnSelectPictureEvent(photoPath.path));

          }
        ),
        child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) 
                => state.pictureProfilePath == ''
                   ? Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: const [
                        Icon(Icons.wallpaper_rounded, size: 60, color: ColorsDukascango.primaryColor ),
                        SizedBox(height: 10.0),
                        TextCustom(text: 'Picture', color: Colors.black45 )
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