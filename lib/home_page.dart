// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_tracker/util/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// habitName, habitStarted, timeSpent(seconds), timeGoal
  List habitList = [
    ['Exercise', false, 0, 1],
    ['Practice DSA', false, 0, 20],
    ['Complete Course', false, 0, 30],
    ['Mock papers', false, 0, 40],
  ];

  void habitStarted(int index) {
    var startTime = DateTime.now();
    int elapsedTime = habitList[index][2];
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          //if the user stopped the timer
          if (!habitList[index][1]) {
            timer.cancel();
          }

          //elapsed time after staring the timer
          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime + currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }

    //doesnt run in the background
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
    //     habitList[index][2]++;
    //   });
    // });
  }

  void settingsOpened(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Settings for ' + habitList[index][0]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 207, 190, 190),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 29, 29),
        title: Text(
          'One step closer to success',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: habitList.length,
        itemBuilder: ((context, index) {
          return HabitTile(
            habitName: habitList[index][0],
            onTap: () {
              habitStarted(index);
            },
            settingsTapped: () {
              settingsOpened(index);
            },
            habitStarted: habitList[index][1],
            timeSpent: habitList[index][2],
            timeGoal: habitList[index][3],
          );
        }),
      ),
    );
  }
}
