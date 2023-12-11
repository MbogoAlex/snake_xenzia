import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake/blank_pixel.dart';
import 'package:snake/food_pixel.dart';
import 'package:snake/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  int totalNumberOfSquares = 100;
  List<int> snakePos = [0, 1, 2];
  int foodPos = 55;

  //snake direction is initially to the right
  var currentdirection = snake_direction.RIGHT;

  void moveSnake() {
    switch (currentdirection) {
      case snake_direction.RIGHT:
        {
          // add a head
          //if snake is at the right wall, need to re-adjust
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }

          // remove tail
          snakePos.removeAt(0);
        }

        break;
      case snake_direction.LEFT:
        {
          // add a head
          //if snake is at the left wall, need to re-adjust
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }

          // remove tail
          snakePos.removeAt(0);
        }

        break;
      case snake_direction.UP:
        {
          // add a head
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }

          // remove tail
          snakePos.removeAt(0);
        }

        break;
      case snake_direction.DOWN:
        {
          // add a head
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }

          // remove tail
          snakePos.removeAt(0);
        }

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                print("Tapped");
                if (details.delta.dy > 0 &&
                    currentdirection != snake_direction.UP) {
                  currentdirection = snake_direction.DOWN;
                } else if (details.delta.dy < 0 &&
                    currentdirection != snake_direction.DOWN) {
                  currentdirection = snake_direction.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                print("Tapped");
                if (details.delta.dx > 0 &&
                    currentdirection != snake_direction.LEFT) {
                  currentdirection = snake_direction.RIGHT;
                } else if (details.delta.dx < 0 &&
                    currentdirection != snake_direction.RIGHT) {
                  currentdirection = snake_direction.LEFT;
                }
              },
              child: GridView.builder(
                itemCount: totalNumberOfSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSize,
                ),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPos == index) {
                    return const FoodPixel();
                  } else {
                    return const BlankPixel();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  onPressed: startGame,
                  child: Text("PLAY"),
                  color: Colors.pink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startGame() {
    print("STARTED");
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
      });
    });
  }
}
