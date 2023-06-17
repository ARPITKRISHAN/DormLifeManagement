// complaints landing page
// contains complaints display and complaint registration

import 'package:flutter/material.dart';
import 'ComplaintsDisplay.dart';
import 'ComplaintRegistration.dart';

class Complaints extends StatefulWidget {
  const Complaints({Key? key}) : super(key: key);

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {

  int displayWhat = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaints"),
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
                      child: const Text('Complaints'),
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
                      child: const Text('Register Complaint'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ComplaintRegistration()
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // if displayWhat is 1 tehn display food menu else display feedback
            (displayWhat == 1 ? const ComplaintsDisplay() : const ComplaintRegistration()),

          ],
        ),
      ),
    );
  }
}
