import "package:flutter/material.dart";
import './direction.dart';

class Controls extends StatelessWidget {
  // const Controls({super.key});
  final Function callback;
  final Function restart;
  Controls(this.callback, this.restart);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // UP
        ElevatedButton(
            onPressed: () {
              callback(Direction.Top);
            },
            child: Text('up')),

        // DOWN
        ElevatedButton(
            onPressed: () {
              callback(Direction.Bottom);
            },
            child: Text('down')),

        // RIGHT
        ElevatedButton(
            onPressed: () {
              callback(Direction.Right);
            },
            child: Text('right')),

        // LEFT
        ElevatedButton(
            onPressed: () {
              callback(Direction.Left);
            },
            child: Text('left')),

        ElevatedButton(
            onPressed: () {
              restart();
            },
            child: Text('Restart')),
      ],
    );
  }
}
