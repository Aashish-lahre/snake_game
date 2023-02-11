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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AspectRatio(
          // widthFactor: 0.5,
          // heightFactor: 1,
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: Stack(
              // alignment: Alignment.bottomCenter,
              children: [
                // top
                button(
                  Alignment.topCenter,
                  () {
                    callback(Direction.Top);
                  },
                  const Icon(
                    Icons.keyboard_arrow_up,
                    size: 30,
                  ),
                ),
                // right
                button(
                  Alignment.centerRight,
                  () {
                    callback(Direction.Right);
                  },
                  const Icon(
                    Icons.keyboard_arrow_right,
                    size: 30,
                  ),
                ),
                // bottom
                button(
                  Alignment.bottomCenter,
                  () {
                    callback(Direction.Bottom);
                  },
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 30,
                  ),
                ),

                //left
                button(
                  Alignment.centerLeft,
                  () {
                    callback(Direction.Left);
                  },
                  const Icon(
                    Icons.keyboard_arrow_left,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              restart();
            },
            icon: Icon(Icons.restart_alt_sharp)),
      ],
    );
  }
}

Widget button(Alignment align, VoidCallback callback, Icon icon) {
  return Align(
      alignment: align,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: callback,
          splashColor: Colors.amber,
          child: icon,
        ),
      ));
}

// Row(
//       children: [
//         // UP
//         ElevatedButton(
//             onPressed: () {
//               callback(Direction.Top);
//             },
//             child: Text('up')),

//         // DOWN
//         ElevatedButton(
//             onPressed: () {
//               callback(Direction.Bottom);
//             },
//             child: Text('down')),

//         // RIGHT
//         ElevatedButton(
//             onPressed: () {
//               callback(Direction.Right);
//             },
//             child: Text('right')),

//         // LEFT
//         ElevatedButton(
//             onPressed: () {
//               callback(Direction.Left);
//             },
//             child: Text('left')),

//         ElevatedButton(
//             onPressed: () {
//               restart();
//             },
//             child: Text('Restart')),
//       ],
//     );
