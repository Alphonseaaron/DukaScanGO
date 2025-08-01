import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/helpers/helpers.dart';
import 'package:dukascango/presentation/screens/client/client_home_screen.dart';
import 'package:dukascango/presentation/screens/home/select_role_screen.dart';
import 'package:dukascango/presentation/screens/intro/intro_screen.dart';
import 'package:dukascango/presentation/screens/login/forgot_password_screen.dart';
import 'package:dukascango/presentation/themes/colors_frave.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  
  final _keyForm = GlobalKey<FormState>();
  
  @override
  void initState() {

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }


  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){

    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        
        if( state is LoadingAuthState ){

          modalLoading(context);
        
        } else if ( state is FailureAuthState ){

          Navigator.pop(context);
          errorMessageSnack(context, state.error);

        } else if ( state.rolId != null && state.rolId != '' ){

          userBloc.add( OnGetUserEvent(state.user!) );
          Navigator.pop(context);

          if( state.rolId == '1' || state.rolId == '3' ){

            Navigator.pushAndRemoveUntil(context, routeFrave(page: SelectRoleScreen()), (route) => false);
          
          } else if ( state.rolId == '2' ){

            Navigator.pushAndRemoveUntil(context, routeFrave(page: ClientHomeScreen()), (route) => false);
        
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: Form(
                key: _keyForm,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.05,
                      vertical: constraints.maxHeight * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pushReplacement(
                                  context, routeFrave(page: IntroScreen())),
                              borderRadius: BorderRadius.circular(100.0),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    shape: BoxShape.circle),
                                child: const Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: Colors.black,
                                    size: 20),
                              ),
                            ),
                            Row(
                              children: const [
                                TextCustom(
                                    text: 'Frave ',
                                    color: ColorsFrave.primaryColor,
                                    fontWeight: FontWeight.w500),
                                TextCustom(
                                    text: 'Food',
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Image.asset('Assets/Logo/logo-black.png',
                          height: constraints.maxHeight * 0.2),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Container(
                        alignment: Alignment.center,
                        child: const TextCustom(
                            text: 'Welcome back!',
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff14222E)),
                      ),
                      const SizedBox(height: 5.0),
                      Align(
                        alignment: Alignment.center,
                        child: const TextCustom(
                            text:
                                'Use your credentials below and login to your account.',
                            textAlign: TextAlign.center,
                            color: Colors.grey,
                            maxLine: 2,
                            fontSize: 16),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      const TextCustom(text: 'Email Address'),
                      const SizedBox(height: 5.0),
                      FormFieldFrave(
                        controller: _emailController,
                        hintText: 'email@frave.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: validatedEmail,
                      ),
                      const SizedBox(height: 20.0),
                      const TextCustom(text: 'Password'),
                      const SizedBox(height: 5.0),
                      FormFieldFrave(
                        controller: _passwordController,
                        hintText: '********',
                        isPassword: true,
                        validator: passwordValidator,
                      ),
                      const SizedBox(height: 10.0),
                      Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () => Navigator.push(context,
                                  routeFrave(page: ForgotPasswordScreen())),
                              child: const TextCustom(
                                  text: 'Forgot Password?',
                                  fontSize: 17,
                                  color: ColorsFrave.primaryColor))),
                      SizedBox(height: constraints.maxHeight * 0.04),
                      BtnFrave(
                        text: 'Login',
                        fontSize: 21,
                        height: 50,
                        fontWeight: FontWeight.w500,
                        onPressed: () {
                          if (_keyForm.currentState!.validate()) {
                            authBloc.add(LoginEvent(
                                _emailController.text, _passwordController.text));
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}