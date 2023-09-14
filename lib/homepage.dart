import 'dart:async';
import 'dart:math';
import 'package:dino/janjan.dart';
import 'package:dino/obstacles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double janJump = 0;
  double time = 0;
  double height = 0;
  double initialHeight = 0;
  bool startGame = false;
  double gravity = -4.9;
  double velocity = 3.5;
  double janWidth = 0.2;
  double janHeight = 0.2;
  int score = 0;
  int roundedScore = 0;
  int bestScore = 0;

  static double obstacleSpaces = 1.2;

  List<double> getRandomBarrierHeight() {
    // Generate a random height for the first barrier.
    double minHeight = 0.1; // Adjust as needed.
    double maxHeight = 0.7; // Adjust as needed.

    Random random = Random();
    double firstBarrierHeight =
        minHeight + random.nextDouble() * (maxHeight - minHeight);

    // Calculate the height for the second barrier to ensure the sum is 0.9.
    double secondBarrierHeight = 0.9 - firstBarrierHeight;

    return [firstBarrierHeight, secondBarrierHeight];
  }

  static List<double> barrierX = [1, obstacleSpaces + 1];
  static double barrierWidth = 0.3;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  void gameStart() {
    setState(() {
      time = 0;
      initialHeight = janJump;
      if (roundedScore > bestScore) {
        bestScore = roundedScore;
      }
    });
  }

  void handleScore() {
    // Use a Set to track scored barriers.
    Set<int> scoredBarriers = {};

    for (int i = 0; i < barrierX.length; i++) {
      if (!scoredBarriers.contains(i) &&
          barrierX[i] < janWidth &&
          barrierX[i] + barrierWidth >= janWidth) {
        // Increment the score when a barrier passes the janjan character.
        score++;
        scoredBarriers.add(i); // Mark this barrier as scored.
      }
    }
  }

  void jump() {
    startGame = true;
    initialHeight = janJump;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      handleScore();
      time += 0.04;
      height = gravity * time * time + velocity * time;
      setState(() {
        janJump = initialHeight - height;
      });

      for (int i = 0; i < barrierX.length; i++) {
        barrierX[i] -= 0.03; // Adjust this value to control obstacle speed.

        // Check if the obstacle is out of the screen and reset its position.
        if (barrierX[i] < -barrierWidth - 1) {
          barrierX[i] = barrierX[(i + 1) % 2] + obstacleSpaces + barrierWidth;

          // Randomize the first barrier's height.
          if (i == 0) {
            List<double> randomizedHeights = getRandomBarrierHeight();
            barrierHeight[i][0] = randomizedHeights[0];
            barrierHeight[i][1] = randomizedHeights[1];
          }
          // Reset to the right side of the screen.
        }
        roundedScore = (score / 10).round();
      }

      if (birdDown()) {
        timer.cancel();
        _showDialog();
        score = 0;
      }
    });
  }

  bool birdDown() {
    if (janJump >= 1 || janJump <= -1) {
      return true;
    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= janWidth - 0.14 &&
          barrierX[i] + barrierWidth >= 0 &&
          (janJump <= -1.1 + barrierHeight[i][0] ||
              janJump + janHeight - 0.08 >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void gameReset() {
    Navigator.pop(context);
    setState(() {
      janJump = 0;
      startGame = false;
      time = 0;
      initialHeight = janJump;
      barrierX = [1, obstacleSpaces + 1];
      barrierHeight = [
        getRandomBarrierHeight(),
        [0.9 - barrierHeight[0][0], 0.9 - barrierHeight[0][1]],
        getRandomBarrierHeight(),
        [0.9 - barrierHeight[1][0], 0.9 - barrierHeight[1][1]],
      ];
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey,
            title: Center(
              child: Text(
                "G A M E  O V E R",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: gameReset,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                      padding: EdgeInsets.all(7),
                      color: Colors.black26,
                      child: Text(
                        "P L A Y  A G A I N",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (startGame) {
            gameStart();
          } else {
            jump();
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        alignment: Alignment(0, janJump),
                        duration: Duration(milliseconds: 0),
                        color: Colors.amber.shade700,
                        child: Janjan(
                          janJump: janJump,
                          janWidth: janWidth,
                          janHeight: janHeight,
                        ),
                      ),
                      Container(
                          alignment: Alignment(0, -0.3),
                          child: startGame
                              ? Text("")
                              : Text(
                                  "T A P  T O  P L A Y",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                      Obstacles(
                        obstacleX: barrierX[0],
                        obstacleWidth: barrierWidth,
                        obstacleHeight: barrierHeight[0][0],
                        isBottomBarrier: false,
                      ),
                      Obstacles(
                        obstacleX: barrierX[0],
                        obstacleWidth: barrierWidth,
                        obstacleHeight: barrierHeight[0][1],
                        isBottomBarrier: true,
                      ),
                      Obstacles(
                        obstacleX: barrierX[1],
                        obstacleWidth: barrierWidth,
                        obstacleHeight: barrierHeight[1][0],
                        isBottomBarrier: false,
                      ),
                      Obstacles(
                        obstacleX: barrierX[1],
                        obstacleWidth: barrierWidth,
                        obstacleHeight: barrierHeight[1][1],
                        isBottomBarrier: true,
                      )
                    ],
                  )),
              Container(
                height: 15,
                color: Colors.green,
              ),
              Expanded(
                  child: Container(
                color: Colors.black87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Score",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(
                          height: 20,
                        ),
                        Text("$roundedScore",
                            style: TextStyle(color: Colors.white, fontSize: 30))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("BEST",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(
                          height: 20,
                        ),
                        Text("$bestScore",
                            style: TextStyle(color: Colors.white, fontSize: 30))
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
