// To display the food menu of mess

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'Utils/globals.dart';
import 'dart:core';

class MessFoodMenuDisplay extends StatefulWidget {
  const MessFoodMenuDisplay({Key? key}) : super(key: key);

  @override
  State<MessFoodMenuDisplay> createState() => _MessFoodMenuDisplayState();
}

class _MessFoodMenuDisplayState extends State<MessFoodMenuDisplay> {

  // find the index of the day
  Map<String, String> day = {
    'Monday' : '1',
    'Tuesday' : '2',
    'Wednesday' : '3',
    'Thursday': '4',
    'Friday': '5',
    'Saturday' : '6',
    'Sunday' : '7',
  };

  MessMenuOfTheDay? menu;
  String selectedDay = 'Monday';
  bool isLoading = false;

  // To get the menu of the selectedDay
  Future<void> fetchData(String? dayID) async {
    
    isLoading = true;

    try{
      var url = Uri.parse('${API.MESS_MENU_OF_THE_DAY}/${dayID}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Request successful, parse the response data
        setState(() {
          menu = MessMenuOfTheDay.fromJson(jsonDecode(response.body));
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
      // Fluttertoast.showToast(msg: "Error in fetching data");
      setState(() {
        isLoading = false;
      });
    }

  }

  // constructor to call the menu of monday by default
  _MessFoodMenuDisplayState(){
    fetchData('1');
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading ? const Expanded(child: Center(child: CircularProgressIndicator())) :  Column(
        children: [
          MessCard(title: "Breakfast", menu: menu?.breakfast, timing: "7:30 - 9:30 am"),
          MessCard(title: "Lunch", menu: menu?.lunch, timing: "12:00 - 2:15 pm"),
          MessCard(title: "Snacks", menu: menu?.snacks, timing: "4:45 - 6:15 pm"),
          MessCard(title: "Dinner", menu: menu?.dinner, timing: "7:30 - 9:45 pm"),
          // TO select the day
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                value: selectedDay,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                underline: const SizedBox(), // Remove the default underline
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDay = newValue!;
                    fetchData(day[selectedDay]);
                  });
                },
                items: <String>[
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ]
    ) );
  }
}

// Card to display the breakfast, lunch etc
class MessCard extends StatelessWidget {

  String? title;
  String? menu;
  String? timing;

  MessCard({Key? key, this.title, this.menu, this.timing}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.breakfast_dining),
        title: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("${title}")
        ),
        subtitle: Container(
            height: 60,
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text("${menu}")
        ),
        trailing: Text("${timing}"),
      ),
    );
  }
}

// To store the response of the api
// It stores the menu of a particular day
class MessMenuOfTheDay {
  int? dayId;
  String? dayname;
  String? breakfast;
  String? lunch;
  String? snacks;
  String? dinner;
  Null? createdAt;
  Null? updatedAt;

  MessMenuOfTheDay(
      {this.dayId,
        this.dayname,
        this.breakfast,
        this.lunch,
        this.snacks,
        this.dinner,
        this.createdAt,
        this.updatedAt});

  MessMenuOfTheDay.fromJson(Map<String, dynamic> json) {
    dayId = json['day_id'];
    dayname = json['dayname'];
    breakfast = json['breakfast'];
    lunch = json['lunch'];
    snacks = json['snacks'];
    dinner = json['dinner'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_id'] = dayId;
    data['dayname'] = dayname;
    data['breakfast'] = breakfast;
    data['lunch'] = lunch;
    data['snacks'] = snacks;
    data['dinner'] = dinner;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
