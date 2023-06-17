// Mess food feedback

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Utils/globals.dart';
import 'package:http/http.dart' as http;
import 'MessFoodFeedbackRegistration.dart';
import 'DateAndTime.dart';
import 'dart:core';


class MessFoodFeedback extends StatefulWidget {
  const MessFoodFeedback({Key? key}) : super(key: key);

  @override
  State<MessFoodFeedback> createState() => _MessFoodFeedbackState();
}

class _MessFoodFeedbackState extends State<MessFoodFeedback> {

  // list to contain the objects of the FeedbackData
  List<dynamic>? list;
  int? listSize;
  bool isLoading = false;

  // To get all the feedbacks
  void fetchData() async {

    isLoading = true;

    try {
      var url = Uri.parse(API.ALL_FEEDBACK_DATA);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Request successful, parse the response data

        List<dynamic> data = json.decode(response.body);
        // FeedbackData feedback = FeedbackData.fromJson(data[0]);

        setState(() {
          list = data.map<FeedbackData>((json) => FeedbackData.fromJson(json))
              .toList();
          listSize = list?.length;
          isLoading = false;
        });
      } else {
        // Request failed, handle the error
        Fluttertoast.showToast(msg: "Error in fetching data");
        setState(() {
          isLoading = false;
        });
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: "Error in fetching data");
      setState(() {
        isLoading = false;
      });
    }
  }

  _MessFoodFeedbackState(){
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading ? const Expanded(child: Center(child: CircularProgressIndicator())) : Container(
      height: 600, // Set a fixed height or use other appropriate height constraints
      child: Column(
        children: [

          // THE FEEDBACKS
          Expanded(
            child: ListView.builder(
              itemCount: listSize,
              itemBuilder: (context, index) {
                return FeedbackCard(feedback: list?[index]);
              },
            ),
          ),
          const SizedBox(height: 8.0),

          // ADD FEEDBACK BUTTON
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessFoodFeedbackRegistration()
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Change the button's background color
              foregroundColor: Colors.white, // Change the button's text color
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Adjust the button's padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the button's border radius
              ),
            ),
            child: const Text(
              'Add Feedback',
              style: TextStyle(fontSize: 16.0), // Adjust the button's text style
            ),
          ),
        ],
      ),
    ));
  }
}

// to display a single feedback
class FeedbackCard extends StatelessWidget {

  FeedbackData? feedback;
  int rating = 0;

  FeedbackCard({Key? key, this.feedback}) : super(key: key){
    final feedback = this.feedback;

    // set the rating
    if(feedback != null){
      rating = feedback.rating!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ("${feedback?.title}"),
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Submitted on: ${DateAndTime.convertedDateAndTime(feedback?.createdAt)}',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Meal: ${feedback?.day} ${feedback?.type}',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: List.generate(
                  rating,
                    (index) => const Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                  size: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              "${feedback?.description}",
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FeedbackData {
  int? feedbackId;
  String? type;
  String? day;
  int? rating;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;

  FeedbackData(
      {this.feedbackId,
        this.type,
        this.day,
        this.rating,
        this.title,
        this.description,
        this.createdAt,
        this.updatedAt});

  FeedbackData.fromJson(Map<String, dynamic> json) {
    feedbackId = json['feedback_id'];
    type = json['type'];
    day = json['day'];
    rating = json['rating'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feedback_id'] = feedbackId;
    data['type'] = type;
    data['day'] = day;
    data['rating'] = rating;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
