import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_flutter_game/controls.dart';
import 'package:snake_flutter_game/peiceModal.dart';
import './direction.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

// use future delay instead of timer.periodic

class _GameState extends State<Game> {
  // Length of the Snake
  int length = 1;

  // Invisible boundary inside playground
  int normalBoundary = 10;

  // size of snake peice
  int sizeOfPeice = 15;

  late Size screenSize;
  late double screenWidth;
  late double screenHeight;
  late int mainCanvasWidth;
  late int mainCanvasHeight;

  // Direction to move
  Direction direction = Direction.Bottom;

  // Store previous direction, this will be used in boundary validation
  // Direction previousDirection = Direction.Bottom;

  // position of the snake peices
  List<Peice> positions = [];

  // dont worry about this
  bool flag = true;

  // Timer? timer;

  // restart (stops future dalayed)
  bool futureBool = true;

  // food location  or null(when eaten or win)
  Offset? getFood;

  // speed of snake (increses with snakes become larger)
  int speed = 500;

  // move snake relative to timer
  List<Peice> incrementPosition() {
    for (int i = positions.length - 1; i > 0; i--) {
      positions[i].posX = positions[i - 1].posX;
      positions[i].posY = positions[i - 1].posY;
    }

    switch (direction) {
      case Direction.Right:
        positions[0].posX += sizeOfPeice;
        break;
      case Direction.Left:
        positions[0].posX -= sizeOfPeice;
        break;
      case Direction.Top:
        positions[0].posY -= sizeOfPeice;
        break;
      case Direction.Bottom:
        positions[0].posY += sizeOfPeice;
        break;
    }

    return positions;
  }

  void restart() {
    setState(() {
      futureBool = false;
      flag = true;
      positions = [];
      length = 1;
      speed = 500;
    });
  }

  int nearestIntFactorNumber(double num) {
    int remainder = num.toInt() % sizeOfPeice;
    return ((num.toInt() - remainder) - sizeOfPeice);
  }

  // for food position, in imaginary grid cell
  Offset locationRespectToGrid(int posx, int posy) {
    int remainderx = posx % sizeOfPeice;
    int remaindery = posy % sizeOfPeice;

    return Offset(
        (posx - remainderx).toDouble(), (posy - remaindery).toDouble());
  }

  Offset? foodPosition() {
    int playgroundxLength = (mainCanvasWidth ~/ sizeOfPeice);
    int playgroundyLength = (mainCanvasHeight ~/ sizeOfPeice);

    // By multiplying playground x and y grid cells
    // i got total grid cells
    // now subtracting position length, i check
    // do i have any grid cell left to position food
    if ((playgroundxLength * playgroundyLength - positions.length) > 0) {
      bool checkfood = true;
      late Offset offset;

      // now by check food is true, i loop through every single
      // grid cell until reach the empty grid cell, which is not
      // acquired by the position.

      while (checkfood) {
        int locationy = Random().nextInt(mainCanvasHeight);
        int locationx = Random().nextInt(mainCanvasWidth);
        // print(locationx);
        offset = locationRespectToGrid(locationx, locationy);

        bool check = positions.any((element) =>
            element.posX == offset.dx.toInt() &&
            element.posY == offset.dy.toInt());

        if (check) {
          checkfood = true;
        } else {
          checkfood = false;
        }
      }

      return offset;
    } else {
      print('you win');

      // game over dialog box...
      return null;
    }
  }

  Widget dialogBox(String text) {
    return AlertDialog(
      title: const Text('Game Over'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          Text('Score : ${length - 1}'),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              restart();
              Navigator.of(context).pop();
            },
            child: const Text('Restart')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close')),
      ],
    );
  }

  void checkFuture() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (futureBool) {
        // body collision
        bool check = positions.any((element) {
          if (element == positions[0]) {
            return false;
          } else {
            if (element.posX == positions[0].posX &&
                element.posY == positions[0].posY) {
              return true;
            }
            return false;
          }
        });

        if (check) {
          // game over dialog box
          showDialog(
            context: context,
            builder: (c) => dialogBox('Reason: Bite itself'),
          );
        } else {
          // food eaten or not
          if (positions[0].posX == getFood!.dx.toInt() &&
              positions[0].posY == getFood!.dy.toInt()) {
            getFood = null;
            length += 1;
          }

          // boundary check
          if (positions[0].posX == mainCanvasWidth - sizeOfPeice) {
            if (direction != Direction.Right) {
              setState(() {});
              checkFuture();
            } else {
              // wall collided
              // dialogBox();
              showDialog(
                context: context,
                builder: (c) => dialogBox('Reason: Wall colided'),
              );
            }
          } else if (positions[0].posX == 0) {
            if (direction != Direction.Left) {
              setState(() {});
              checkFuture();
            } else {
              showDialog(
                context: context,
                builder: (c) => dialogBox('Reason: Wall colided'),
              );
            }
          } else if (positions[0].posY == mainCanvasHeight - 15) {
            if (direction != Direction.Bottom) {
              setState(() {});
              checkFuture();
            } else {
              showDialog(
                context: context,
                builder: (c) => dialogBox('Reason: Wall colided'),
              );
            }
          } else if (positions[0].posY == 0) {
            if (direction != Direction.Top) {
              setState(() {});
              checkFuture();
            } else {
              showDialog(
                context: context,
                builder: (c) => dialogBox('Reason: Wall colided'),
              );
            }
          } else {
            setState(() {});
            checkFuture();
          }
        }
      }
    });
  }

  // After control button click, change direction of the snake
  void changeDirection(Direction newDirection) {
    // if the direction, which is called by the player is opposite
    // to the direction of snake moving, then snake will do nothing
    // for this action
    if ((newDirection == Direction.Top && direction == Direction.Bottom) ||
        (newDirection == Direction.Bottom && direction == Direction.Top) ||
        (newDirection == Direction.Left && direction == Direction.Right) ||
        (newDirection == Direction.Right && direction == Direction.Left)) {
    } else {
      // if the direction which is called is valid
      // then, direction will change to player needs

      // previousDirection = direction;
      direction = newDirection;
      futureBool = true;
      print('future bool : $futureBool');
      if (flag) {
        checkFuture();
        flag = false;
      }
    }
  }

  Peice randomStartPosition(int boundaryRange) {
    // Randomly select position in x-axis
    var posx = Random().nextInt((mainCanvasWidth * 0.8).toInt()) +
        (mainCanvasWidth * 0.1).toInt();

    posx = nearestIntFactorNumber(posx.toDouble());

    // Randomly select position in y-axis
    var posy =
        Random().nextInt(((mainCanvasHeight * 0.8) - boundaryRange).toInt()) +
            (mainCanvasHeight * 0.1).toInt();

    posy = nearestIntFactorNumber(posy.toDouble());

    // customize positions depending on direction
    // Eg - if direction is right, then posx should be less, so can we have
    // enough space in x axis to start the game

    switch (direction) {
      case Direction.Right:
        posx =
            Random().nextInt((mainCanvasWidth * 0.3 - boundaryRange).toInt()) +
                (mainCanvasWidth * 0.2).toInt();
        posx = nearestIntFactorNumber(posx.toDouble());
        print('posx : $posx');
        break;
      case Direction.Left:
        posx =
            Random().nextInt((mainCanvasWidth * 0.4 - boundaryRange).toInt()) +
                boundaryRange +
                (mainCanvasWidth * 0.3).toInt();
        posx = nearestIntFactorNumber(posx.toDouble());
        print('posx : $posx');

        break;
      case Direction.Top:
        posy =
            Random().nextInt((mainCanvasHeight * 0.3 - boundaryRange).toInt()) +
                (mainCanvasHeight * 0.5).toInt();
        // print('random start: case : posy: $posy');
        posy = nearestIntFactorNumber(posy.toDouble());
        print('posy : $posy');

        break;

      case Direction.Bottom:
        posy =
            Random().nextInt((mainCanvasHeight * 0.4 - boundaryRange).toInt()) +
                (mainCanvasHeight * 0.2).toInt();
        posy = nearestIntFactorNumber(posy.toDouble());
        print('posy : $posy');

        break;
    }

    return Peice(color: Colors.blue, posX: posx, posY: posy, size: sizeOfPeice);
  }

  //  Position of Single peices
  Peice getPeice(int posx, int posy) {
    // this function is called, when position length(snake size) is 1
    // to get another pieces behind it
    late int newPosx;
    late int newPosy;
    switch (direction) {
      case Direction.Right:
        newPosx = posx - sizeOfPeice;
        newPosy = posy;
        break;
      case Direction.Left:
        newPosx = posx + sizeOfPeice;
        newPosy = posy;
        break;
      case Direction.Top:
        newPosy = posy + sizeOfPeice;
        newPosx = posx;
        break;

      case Direction.Bottom:
        newPosy = posy - sizeOfPeice;
        newPosx = posx;
        break;
    }

    // print('get Piece : newPosy: $newPosy');
    // print('get Piece : newPosx: $newPosx');

    return Peice(
        posX: newPosx, posY: newPosy, size: sizeOfPeice, color: Colors.red);
  }

  // position of snake including all peices
  List<Peice> getPeices() {
    // when snake size is 0, if block will get all the pieces
    if (positions.isEmpty) {
      positions.add(randomStartPosition(normalBoundary));

      while (length > positions.length) {
        int posx = positions[positions.length - 1].posX;
        int posy = positions[positions.length - 1].posY;

        positions.add(getPeice(posx, posy));
      }

      return positions;
    } else {
      while (length > positions.length) {
        int posx = positions[positions.length - 1].posX;
        int posy = positions[positions.length - 1].posY;

        positions.add(getPeice(posx, posy));
      }
      // move the snake
      // get peices will get called after every timer click
      // and increment snake position
      // if (positions[0].posX == mainCanvasWidth) {
      //   print('position matched');
      //   return positions;
      // }
      return incrementPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    // distance between peices
    // int distancebtPeices = sizeOfPeice;

    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;

    // playground width and height
    mainCanvasWidth = nearestIntFactorNumber(screenWidth * 0.9);
    mainCanvasHeight = nearestIntFactorNumber(screenHeight * 0.6);
    // print('main height : $mainCanvasHeight');

    getFood ??= foodPosition();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Some Blank Space from Top...
          Container(
            width: screenWidth,
            height: screenHeight * 0.1,
            child: Center(child: Text('Score : ${length - 1}')),
          ),

          // Game PlayGround...
          getFood == null
              ? Text('You won')
              : Container(
                  width: mainCanvasWidth.toDouble(),
                  height: mainCanvasHeight.toDouble(),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(color: Colors.blueGrey, width: 1),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    // clipBehavior: Clip.none,
                    children: [
                      ...getPeices().map((peice) {
                        return Positioned(
                            left: peice.posX.toDouble(),
                            top: peice.posY.toDouble(),
                            child: Container(
                              width: peice.size.toDouble(),
                              height: peice.size.toDouble(),
                              decoration: BoxDecoration(
                                color: peice.color,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ));
                      }).toList(),
                      Positioned(
                          left: getFood!.dx,
                          top: getFood!.dy,
                          child: Container(
                            width: sizeOfPeice.toDouble(),
                            height: sizeOfPeice.toDouble(),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ))
                    ],
                  ),
                ),

          // Game Controls...
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
              ),
              child: Controls(changeDirection, restart),
            ),
          ),
        ],
      ),
    );
  }
}
