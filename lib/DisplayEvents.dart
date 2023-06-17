// To display the events

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Utils/globals.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'DateAndTime.dart';


class DisplayEvents extends StatefulWidget {
  const DisplayEvents({Key? key}) : super(key: key);

  @override
  State<DisplayEvents> createState() => _DisplayEventsState();
}

class _DisplayEventsState extends State<DisplayEvents> {

  // list to contain the objects of the ComplaintsData
  List<dynamic>? list;
  int? listSize;
  bool isLoading = false;

  // To get the menu of the selectedDay
  void fetchData() async {

    isLoading = true;

    var url = Uri.parse(API.GET_ALL_EVENTS_DATA);
    var response = await http.get(url);

    try{
      if (response.statusCode == 200) {
        // Request successful, parse the response data

        List<dynamic> data = json.decode(response.body);
        // FeedbackData feedback = FeedbackData.fromJson(data[0]);

        setState(() {
          list = data.map<EventData>((json) => EventData.fromJson(json)).toList();
          listSize = list?.length;
          isLoading = false;
        });

      }
      else {
        // Request failed, handle the error
        Fluttertoast.showToast(msg: "Error in fetching data");
        setState(() {
          isLoading = false;
        });
      }
    }
    catch(e){
      setState(() {
        isLoading = false;
      });
    }

  }

  _DisplayEventsState(){
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading ? const Expanded(child: Center(child: CircularProgressIndicator())) : Expanded(
      child: ListView.builder(
        itemCount: listSize,
        itemBuilder: (context, index) {
          return EventCard(eventData: list?[index]);
        },
      ),
    ));

  }
}

class EventCard extends StatelessWidget {

  EventData? eventData;

  EventCard({Key? key, this.eventData}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${eventData?.title}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(
                  DateAndTime.convertedDateAndTime(eventData?.dateAndTime),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${eventData?.location}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${eventData?.organizer}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${eventData?.contactInformation}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.event_available, size: 16),
                const SizedBox(width: 4),
                Text(
                  eventData != null ?  (eventData?.registrationRequired == 1)
                                    ? 'Registration Required' : 'No Registration Required'
                                    : '',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.timer, size: 16),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Deadline: ${DateAndTime.convertedDateAndTime(eventData?.registrationDeadline)}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${eventData?.description}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventData {
  int? id;
  String? title;
  String? description;
  String? dateAndTime;
  String? location;
  String? organizer;
  String? category;
  int? registrationRequired;
  String? registrationDeadline;
  String? contactInformation;
  String? createdAt;
  String? updatedAt;

  EventData(
      {this.id,
        this.title,
        this.description,
        this.dateAndTime,
        this.location,
        this.organizer,
        this.category,
        this.registrationRequired,
        this.registrationDeadline,
        this.contactInformation,
        this.createdAt,
        this.updatedAt});

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    dateAndTime = json['date_and_time'];
    location = json['location'];
    organizer = json['organizer'];
    category = json['category'];
    registrationRequired = json['registration_required'];
    registrationDeadline = json['registration_deadline'];
    contactInformation = json['contact_information'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['date_and_time'] = dateAndTime;
    data['location'] = location;
    data['organizer'] = organizer;
    data['category'] = category;
    data['registration_required'] = registrationRequired;
    data['registration_deadline'] = registrationDeadline;
    data['contact_information'] = contactInformation;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
