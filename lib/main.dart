// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;

  var bottomButtonColor = Color(0xFF40CA88);

  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282E3D),
      body: Stack(
        children: [
          Align (
            alignment: Alignment(0, -0.8),
            child: Text("Test your\n reaction speed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize:38, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
          Align (
            alignment:  Alignment.center,
            child: ColoredBox(
              color: Color(0xFF6D6D6D),
              child: SizedBox(
                height: 140,
                width: 230,
                child: Center(
                  child: Text(millisecondsText,
                    style: TextStyle(fontSize:36, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Align (
            alignment: Alignment(0, 0.8),
            child: GestureDetector (
              onTap:  () =>  setState(() {
                switch (gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondsText = "";
                    _startWaitingTimer();
                    bottomButtonColor = Color(0xFFE0982D);
                    break;
                  case GameState.waiting:
                    bottomButtonColor = Color(0xFFE02D47);
                    gameState = GameState.canBeStopped;
                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    bottomButtonColor = Color(0xFF40CA88);
                    break;
                  }
              }),
              child: ColoredBox(
                color: bottomButtonColor,
                child: SizedBox(
                  height: 120,
                  width: 190,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(7000) + 1000;
    Timer(Duration(milliseconds: randomMilliseconds), () {
     setState(() {
       gameState = GameState.canBeStopped;
       bottomButtonColor = Color(0xFFE02D47);
     });
     _startStoppableTimer();
   });
  }



  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }


  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

}


enum GameState { readyToStart, waiting, canBeStopped }