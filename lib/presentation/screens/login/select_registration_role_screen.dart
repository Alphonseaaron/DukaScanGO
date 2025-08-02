import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/screens/login/register_screen.dart';
import 'package:dukascango/presentation/themes/colors_frave.dart';

class SelectRegistrationRoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextCustom(
                text: 'Choose your Role',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: ColorsFrave.secundaryColor,
              ),
              SizedBox(height: 30),
              _BtnRol(
                svg: 'Assets/svg/restaurante.svg',
                text: 'Store Owner',
                color1: ColorsFrave.primaryColor.withOpacity(.2),
                color2: Colors.greenAccent.withOpacity(.1),
                onPressed: () => Navigator.push(
                    context,
                    routeFrave(
                        page: RegisterScreen(
                      role: 'Store Owner',
                    ))),
              ),
              _BtnRol(
                svg: 'Assets/svg/bussiness-man.svg',
                text: 'Wholesaler',
                color1: const Color(0xffFE6488).withOpacity(.2),
                color2: Colors.amber.withOpacity(.1),
                onPressed: () => Navigator.push(
                    context,
                    routeFrave(
                        page: RegisterScreen(
                      role: 'Wholesaler',
                    ))),
              ),
              _BtnRol(
                svg: 'Assets/svg/delivery-bike.svg',
                text: 'Delivery',
                color1: const Color(0xff8956FF).withOpacity(.2),
                color2: Colors.purpleAccent.withOpacity(.1),
                onPressed: () => Navigator.push(
                    context,
                    routeFrave(
                        page: RegisterScreen(
                      role: 'Delivery',
                    ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BtnRol extends StatelessWidget {
  final String svg;
  final String text;
  final Color color1;
  final Color color2;
  final VoidCallback? onPressed;

  const _BtnRol(
      {required this.svg,
      required this.text,
      required this.color1,
      required this.color2,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onPressed,
        child: Container(
          height: 130,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft, colors: [color1, color2]),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(
                  svg,
                  height: 100,
                ),
                TextCustom(
                    text: text, fontSize: 20, color: ColorsFrave.secundaryColor)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
