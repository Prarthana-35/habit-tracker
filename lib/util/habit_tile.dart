import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap; //type for gesture detector
  final VoidCallback settingsTapped;
  final int timeSpent;
  final int timeGoal;
  final bool habitStarted;

  const HabitTile({
    Key? key,
    required this.habitName,
    required this.onTap,
    required this.settingsTapped,
    required this.timeSpent,
    required this.timeGoal,
    required this.habitStarted,
  }) : super(key: key);

  String formatToMinSec(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(
        5); //rounds up the number e.g.  1.toStringAsFixed(3) = 1.000, more the value more the accuracy

    //if seconds is single digit
    if (secs.length == 1) {
      secs = '0' + secs;
    }

    if (mins[1] == '.') {
      // 58 secs = 58/60 = 0.966... min it returns 0 min [ doesnt round to 1 min]
      mins = mins.substring(0, 1);
    }
    return mins + ':' + secs;
  }

  //Progress Overview
  double percentCompleted() {
    return (timeSpent) / (timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Stack(
                      children: [
                        CircularPercentIndicator(
                          radius: 50,
                          percent: percentCompleted() < 1
                              ? percentCompleted()
                              : 1, // percent value is b/w 0.0 and 1.0
                          progressColor: percentCompleted() > 0.5
                              ? Colors.green
                              : Colors.red,
                        ),
                        Center(
                          child: Icon(
                              habitStarted ? Icons.pause : Icons.play_arrow),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatToMinSec(timeSpent) +
                          ' / ' +
                          timeGoal.toString() +
                          ' = ' +
                          (percentCompleted() * 100).toStringAsFixed(0) +
                          '%',
                      // '2:00/10:00 = 20%',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: settingsTapped,
              child: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
