// To display all the complaints

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Utils/globals.dart';
import 'dart:core';
import 'DateAndTime.dart';

class ComplaintsDisplay extends StatefulWidget {
  const ComplaintsDisplay({Key? key}) : super(key: key);

  @override
  State<ComplaintsDisplay> createState() => _ComplaintsDisplayState();
}

class _ComplaintsDisplayState extends State<ComplaintsDisplay> {

  // list to contain the objects of the ComplaintsData
  List<dynamic>? list;
  int? listSize;
  bool isLoading = false;

  // To get the menu of the selectedDay
  void fetchData() async {

    isLoading = true;

    var url = Uri.parse(API.ALL_COMPLAINTS_DATA);
    var response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        // Request successful, parse the response data

        List<dynamic> data = json.decode(response.body);
        // FeedbackData feedback = FeedbackData.fromJson(data[0]);

        setState(() {
          list = data.map<ComplaintsData>((json) => ComplaintsData.fromJson(json)).toList();
          listSize = list?.length;
          isLoading =false;
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

  // constructor to call the menu of monday by default
  _ComplaintsDisplayState(){
    fetchData();
  }

  @override
  Widget build(BuildContext context) {

    return (isLoading ? const Expanded(child: Center(child: CircularProgressIndicator())) : Expanded(
            child: ListView.builder(
              itemCount: listSize,
              itemBuilder: (context, index) {
                return ComplaintCard(complaintsData: list?[index]);
              },
            ),
      ));


  }
}

class ComplaintCard extends StatelessWidget {

  ComplaintsData? complaintsData;

  ComplaintCard({Key? key, this.complaintsData}):super(key: key);

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
            const Text(
              'Complaint Title:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              '${complaintsData?.complaintTitle}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Name: ${complaintsData?.name}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Room No: ${complaintsData?.roomNo}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Hostel: ${complaintsData?.hostel}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              '${complaintsData?.description}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Created At:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Text(
              DateAndTime.convertedDateAndTime(complaintsData?.createdAt),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );

  }
}


class ComplaintsData {
  int? complaintId;
  String? name;
  String? complaintTitle;
  int? roomNo;
  String? hostel;
  String? description;
  String? createdAt;
  String? updatedAt;

  ComplaintsData(
      {this.complaintId,
        this.name,
        this.complaintTitle,
        this.roomNo,
        this.hostel,
        this.description,
        this.createdAt,
        this.updatedAt});

  ComplaintsData.fromJson(Map<String, dynamic> json) {
    complaintId = json['complaint_id'];
    name = json['name'];
    complaintTitle = json['complaint_title'];
    roomNo = json['room_no'];
    hostel = json['hostel'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['complaint_id'] = complaintId;
    data['name'] = name;
    data['complaint_title'] = complaintTitle;
    data['room_no'] = roomNo;
    data['hostel'] = hostel;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

