import 'package:flutter/material.dart';
import 'dart:math';

class CustomQrCode extends StatelessWidget {
  final String data;
  final double size;

  const CustomQrCode({Key? key, required this.data, this.size = 200.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 21, // A common QR code version 1 size
        ),
        itemBuilder: (context, index) {
          final random = Random(data.hashCode + index);
          return Container(
            color: random.nextBool() ? Colors.black : Colors.white,
          );
        },
        itemCount: 21 * 21,
      ),
    );
  }
}
