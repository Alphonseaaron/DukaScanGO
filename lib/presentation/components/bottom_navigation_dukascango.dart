import 'package:flutter/material.dart';
import 'package:dukascango/presentation/components/components.dart';
import 'package:dukascango/presentation/screens/client/self_scan/store_checkin_screen.dart';
import 'package:dukascango/presentation/screens/client/cart_client_screen.dart';
import 'package:dukascango/presentation/screens/client/client_home_screen.dart';
import 'package:dukascango/presentation/screens/client/profile_client_screen.dart';
import 'package:dukascango/presentation/screens/client/search_client_screen.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class BottomNavigationDukascango extends StatelessWidget {

  final int index;

  BottomNavigationDukascango(this.index);

  @override
  Widget build(BuildContext context){
    
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: -5)
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ItemButton(
            i: 0, 
            index: index, 
            iconData: Icons.home_outlined, 
            text: 'Home',
            onPressed: () => Navigator.pushReplacement(context, routeDukascango(page: ClientHomeScreen())),
            ),
          _ItemButton(
            i: 1, 
            index: index, 
            iconData: Icons.search, 
            text: 'Search',
            onPressed: () => Navigator.pushReplacement(context, routeDukascango(page: SearchClientScreen())),
            ),
          _ItemButton(
            i: 2, 
            index: index, 
            iconData: Icons.qr_code_scanner,
            text: 'Scan & Go',
            onPressed: () => Navigator.push(context, routeDukascango(page: StoreCheckinScreen())),
            ),
          _ItemButton(
            i: 3,
            index: index,
            iconData: Icons.local_mall_outlined, 
            text: 'Cart',
            onPressed: () => Navigator.pushReplacement(context, routeDukascango(page: CartClientScreen())),
          ),
          _ItemButton(
            i: 4,
            index: index, 
            iconData: Icons.person_outline_outlined, 
            text: 'Profile',
            onPressed: () => Navigator.pushReplacement(context, routeDukascango(page: ProfileClientScreen())),
            ),
        ],
      )
    );
  }
}

class _ItemButton extends StatelessWidget {
  
  final int i;
  final int index;
  final IconData iconData;
  final String text;
  final VoidCallback? onPressed;

  const _ItemButton({ required this.i, required this.index, required this.iconData, required this.text, this.onPressed });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: ( i == index ) ? ColorsDukascango.primaryColor.withAlpha(230) : Colors.transparent,
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: ( i == index ) 
          ? Row(
            children: [
                Icon(iconData, color: Colors.white, size: 25),
                const SizedBox(width: 6.0),
                TextCustom(text: text, fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500 )
              ],
            )
          :  Icon(iconData, size: 28),
      ),
    );
  }
}