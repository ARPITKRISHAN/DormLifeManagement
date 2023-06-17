// Mess landing page
// contains food menu and feedback

import 'package:flutter/material.dart';
import 'MessFoodMenuDisplay.dart';
import  'MessFoodFeedback.dart';

class Mess extends StatefulWidget {
  const Mess({Key? key}) : super(key: key);

  @override
  State<Mess> createState() => _MessState();
}

class _MessState extends State<Mess> {

  int displayWhat = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Mess"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      child: Text('Menu'),
                      onPressed: () {
                        setState(() {
                          displayWhat = 1;
                        });
                      },

                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      child: Text('Feedback'),
                      onPressed: () {
                        setState(() {
                          displayWhat = 2;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            // if displayWhat is 1 tehn display food menu else display feedback
            (displayWhat == 1 ? MessFoodMenuDisplay() : MessFoodFeedback()),

          ],
        ),
      ),
    );
  }
}

