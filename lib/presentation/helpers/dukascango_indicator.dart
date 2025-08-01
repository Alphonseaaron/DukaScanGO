import 'package:flutter/material.dart';
import 'package:dukascango/presentation/themes/colors_dukascango.dart';

class DukascangoIndicatorTabBar extends Decoration {
  
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _DukascangoPainterIndicator(this, onChanged);

}



class _DukascangoPainterIndicator extends BoxPainter {

  final DukascangoIndicatorTabBar decoration;

  _DukascangoPainterIndicator(this.decoration, VoidCallback? onChanged) : super(onChanged);
  

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {

    Rect rect;

    rect = Offset(offset.dx + 6, ( configuration.size!.height - 3 )) & Size(configuration.size!.width - 12, 3);

    final paint = Paint()
      ..color = ColorsDukascango.primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndCorners(rect, topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)), paint);


  }



}