import 'package:flutter/material.dart';

class Janjan extends StatelessWidget {
  final janJump;
  final double janWidth;
  final double janHeight;

  Janjan({this.janJump, required this.janWidth, required this.janHeight});
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, (2 * janJump + janHeight) / (2 - janHeight)),
        child: Image.asset(
          'lib/images/janjan.png',
          width: MediaQuery.of(context).size.height * janWidth / 2,
          height: MediaQuery.of(context).size.height * 3 / 4 * janHeight / 2,
        ));
  }
}
