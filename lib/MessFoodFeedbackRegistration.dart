// To register the feedback of the food

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'Utils/globals.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';


class MessFoodFeedbackRegistration extends StatefulWidget {
  const MessFoodFeedbackRegistration({Key? key}) : super(key: key);

  @override
  State<MessFoodFeedbackRegistration> createState() => _MessFoodFeedbackRegistrationState();
}

class _MessFoodFeedbackRegistrationState extends State<MessFoodFeedbackRegistration> {
  @override
  Widget build(BuildContext context) {
      return  Scaffold(
        appBar: AppBar(
          title: const Text('Add Feedback'),
        ),
        body: AddFeedbackCard(),
      );
  }
}

class AddFeedbackCard extends StatefulWidget {
  @override
  _AddFeedbackCardState createState() => _AddFeedbackCardState();
}

class _AddFeedbackCardState extends State<AddFeedbackCard> {
  String selectedMealType = 'Breakfast';
  String selectedDayOfWeek = 'Monday';
  int selectedRating = 0;
  String feedbackTitle = '';
  String feedbackDescription = '';

  bool isLoading = false;

  // TO POST THE FEEDBACK
  void postFeedback() async {

    setState(() {
      isLoading = true;
    });

    try{
      final url = API.POST_MESS_FOOD_FEEDBACK_DATA;

      final params = {
        "type": selectedMealType,
        "day": selectedDayOfWeek,
        "rating": selectedRating,
        "title": feedbackTitle,
        "description": feedbackDescription
      };

      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(params));

      if (response.statusCode == 200) {
        // Request successful
        // Successful API call
        Fluttertoast.showToast(msg: "Success! Feedback submitted successfully");

        setState(() {
          isLoading = false;
        });

      } else {
        // Request failed
        Fluttertoast.showToast(msg: "Error in submitting feedback");
        setState(() {
          isLoading = false;
        });
      }
    }
    catch(e){
      // Exception occurred
      Fluttertoast.showToast(msg: "Error in submitting feedback");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading ?

      Column(
        children: const [
          Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      )
        :
      Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Feedback Form',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),

              DropdownButtonFormField<String>(
                value: selectedMealType,
                items: [
                  'Breakfast',
                  'Lunch',
                  'Snacks',
                  'Dinner',
                ].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMealType = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Meal Type',
                ),
              ),

              const SizedBox(height: 16.0),

              DropdownButtonFormField<String>(
                value: selectedDayOfWeek,
                items: [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday',
                ].map((day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDayOfWeek = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Day of the Week',
                ),
              ),

              const SizedBox(height: 16.0),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Feedback Title',
                ),
                onChanged: (value) {
                  setState(() {
                    feedbackTitle = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                // maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Feedback Description',
                ),
                onChanged: (value) {
                  setState(() {
                    feedbackDescription = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              Center(
                child: Container(

                  margin: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      postFeedback();
                    },
                    child: Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));

  }
}

