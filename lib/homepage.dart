import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<int>? bodySnake;
  bool newScore = false;

  //user score
  int currentScore = 0;
  int? highScore;
  int? previousHighScore;

  @override
  void initState() {
    super.initState();
    checkHighScore();
  }

  void checkHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int? currentHighScore = prefs.getInt("theHighScore");
      currentHighScore ??= 0;

      highScore = currentHighScore;
      previousHighScore = currentHighScore;
      print("THe high score is: $highScore");
    });
  }

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
        }

        break;
      default:
    }
    //snake is eating food

    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      // remove tail
      snakePos.removeAt(0);
    }
  }

  void eatFood() {
    setState(() {
      currentScore++;
      if (currentScore > highScore!) {
        highScore = highScore! + 1;
      }
    });
    while (snakePos.contains(foodPos)) {
      //making sure the new food is not where the snake is
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  //game over

  bool gameOver() {
    //the game is over when the snake runs into itself
    //this occurs when there is a duplicate position in the snakePos list

    //this list is the body of the snake (no head)
    bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake!.contains(snakePos.last) && currentScore != 0) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //user current score

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Current Score"),
                    Text(
                      currentScore.toString(),
                      style: const TextStyle(fontSize: 36),
                    ),
                  ],
                ),
                //highscores, top 5 or top 10

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("High Score"),
                    Text(
                      highScore.toString(),
                      style: const TextStyle(fontSize: 36, color: Colors.green),
                    ),
                  ],
                )
              ],
            ),
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
            child: Center(
              child: MaterialButton(
                onPressed: startGame,
                color: Colors.pink,
                child: const Text("PLAY"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentHighScore = prefs.getInt("theHighScore");
    print("Current high score is $currentHighScore");
    if (currentHighScore == null) {
      prefs.setInt("theHighScore", currentScore);
    } else if (currentHighScore < currentScore) {
      prefs.setInt("theHighScore", currentScore);
    }
  }

  void startGame() {
    print("STARTED");
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        //keep the snake moving
        moveSnake();

        // check if the game is over

        if (gameOver()) {
          Future<void> save() async {
            await saveHighScore();
          }

          save();

          if (currentScore > previousHighScore!) {
            newScore = true;
          }

          print(
              "The current score is: $currentScore and high score is $highScore");

          timer.cancel();
          //display a message to the user
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Game over"),
                content: newScore
                    ? Text("High score! ${currentScore.toString()}")
                    : Text("Your score is ${currentScore.toString()}"),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        currentScore = 0;
                      });
                      bodySnake = [];
                      snakePos = [0, 1, 2];
                      foodPos = 55;
                      newScore = false;
                      checkHighScore();
                      startGame();

                      Navigator.pop(context);
                    },
                    child: const Text("Restart"),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }
}
