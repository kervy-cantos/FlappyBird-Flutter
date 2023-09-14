import 'package:flutter/material.dart';

class Obstacles extends StatelessWidget {
  final obstacleWidth;
  final obstacleHeight;
  final obstacleX;
  final bool isBottomBarrier;

  Obstacles(
      {this.obstacleWidth,
      this.obstacleHeight,
      this.obstacleX,
      required this.isBottomBarrier});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
          (2 * obstacleX + obstacleWidth) / (2 - obstacleWidth),
          isBottomBarrier ? 1.1 : -1.1),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.black54),
          borderRadius: BorderRadius.circular(15),
          color: Colors.green.shade700,
        ),
        width: MediaQuery.of(context).size.width * obstacleWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * obstacleHeight / 2,
      ),
    );
  }
}
