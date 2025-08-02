import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/screens/client/client_home_screen.dart';
import 'package:dukascango/presentation/screens/home/select_role_screen.dart';
import 'package:dukascango/presentation/screens/login/login_screen.dart';
import 'package:dukascango/presentation/screens/wholesaler/wholesaler_home_screen.dart';
import 'package:dukascango/presentation/themes/colors_frave.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dukascango/presentation/walkthrough/client_walkthrough.dart';
import 'package:dukascango/presentation/walkthrough/admin_walkthrough.dart';
import 'package:dukascango/presentation/walkthrough/delivery_walkthrough.dart';
import 'package:dukascango/presentation/walkthrough/wholesaler_walkthrough.dart';

class CheckingLoginScreen extends StatefulWidget {
  
  @override
  _CheckingLoginScreenState createState() => _CheckingLoginScreenState();
}


class _CheckingLoginScreenState extends State<CheckingLoginScreen> with TickerProviderStateMixin {

  late AnimationController _animationController;
  
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_animationController)..addStatusListener((status) {
      if( status == AnimationStatus.completed ){
        _animationController.reverse();
      } else if ( status == AnimationStatus.dismissed ){
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        
        if( state is LoadingAuthState ){

          Navigator.pushReplacement(context, routeFrave(page: CheckingLoginScreen()));
        
        } else if ( state is LogOutAuthState ){

          Navigator.pushAndRemoveUntil(context, routeFrave(page: LoginScreen()), (route) => false);    
         
        } else if ( state.rolId != null && state.rolId != '' ){

          userBloc.add( OnGetUserEvent(state.user!) );

          final prefs = await SharedPreferences.getInstance();
          final walkthroughCompleted = prefs.getBool('walkthrough_completed') ?? false;

          if (!walkthroughCompleted) {
            if (state.rolId == '1') {
              Navigator.pushAndRemoveUntil(context, routeFrave(page: AdminWalkthroughScreen()), (route) => false);
            } else if (state.rolId == '2') {
              Navigator.pushAndRemoveUntil(context, routeFrave(page: ClientWalkthroughScreen()), (route) => false);
            } else if (state.rolId == '3') {
              Navigator.pushAndRemoveUntil(context, routeFrave(page: DeliveryWalkthroughScreen()), (route) => false);
            } else if (state.rolId == '4') {
              Navigator.pushAndRemoveUntil(context, routeFrave(page: WholesalerWalkthroughScreen()), (route) => false);
            }
          } else {
            if( state.rolId  == '1' || state.rolId  == '3' ){
              Navigator.pushAndRemoveUntil(context, routeFrave(page: SelectRoleScreen()), (route) => false);
            } else if ( state.rolId  == '2' ){
              Navigator.pushAndRemoveUntil(context, routeFrave(page: ClientHomeScreen()), (route) => false);
            } else if ( state.rolId == '4' ){
              Navigator.pushAndRemoveUntil(context, routeFrave(page: WholesalerHomeScreen()), (route) => false);
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorsFrave.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) 
                  => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset('Assets/Logo/logo-white.png'),
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}