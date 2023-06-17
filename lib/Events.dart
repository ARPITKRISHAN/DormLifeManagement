// To show and register information about the events

import 'package:flutter/material.dart';
import 'DisplayEvents.dart';
import 'EventRegistration.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  int displayWhat = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
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
                      child: Text('Events'),
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
                      child: Text('Add Event'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EventRegistration()
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // if displayWhat is 1 tehn display food menu else display feedback
            (displayWhat == 1 ? DisplayEvents() : EventRegistration()),

          ],
        ),
      ),
    );
  }
}
